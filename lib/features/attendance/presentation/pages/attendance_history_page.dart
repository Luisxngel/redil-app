import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../models/attendance_group.dart';

class AttendanceHistoryPage extends StatelessWidget {
  const AttendanceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AttendanceBloc>()..add(const AttendanceEvent.loadHistory()),
      child: const _AttendanceHistoryView(),
    );
  }
}

class _AttendanceHistoryView extends StatelessWidget {
  const _AttendanceHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Eventos'),
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (msg) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), backgroundColor: Colors.red),
            ),
             actionSuccess: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.green),
              );
              // Reload history after deletion or other actions
              context.read<AttendanceBloc>().add(const AttendanceEvent.loadHistory());
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            historyLoaded: (history, scheduled) {
              if (history.isEmpty && scheduled.isEmpty) {
                return const Center(child: Text('No hay eventos registrados'));
              }
              
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Scheduled Section
                    if (scheduled.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/calendar_sync.svg',
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).primaryColor, 
                                BlendMode.srcIn
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Próximos Eventos (${scheduled.length})',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: scheduled.length,
                        itemBuilder: (context, index) {
                          final group = scheduled[index];
                          final event = group.mainEvent;
                          return Card(
                            elevation: 3,
                            color: Theme.of(context).colorScheme.primaryContainer,
                            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                child: group.isRecurring 
                                  ? Icon(Icons.repeat, color: Theme.of(context).colorScheme.onPrimary, size: 20)
                                  : Icon(Icons.event, color: Theme.of(context).colorScheme.onPrimary, size: 20),
                              ),
                              title: Text(
                                event.title ?? event.description ?? 'Evento Programado',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat.yMMMMEEEEd('es').format(event.date),
                                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
                                  ),
                                  if (group.count > 1)
                                    Text('${group.count} sesiones programadas', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              trailing: _buildEventActions(context, event),
                              onTap: () {
                                 _showEventDetails(context, group);
                              },
                            ),
                          );
                        },
                      ),
                    ],

                    // 2. History Section
                    if (history.isNotEmpty) ...[
                       Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Text(
                          'Historial Pasado',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final event = history[index];
                          return Card(
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                child: Text(
                                  '${event.presentMemberIds.length}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              title: Text(
                                event.title ?? event.description ?? 'Evento Pasado',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                DateFormat.yMMMMEEEEd('es').format(event.date),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              onTap: () {
                                 context.push('/attendance/check', extra: event.id).then((_) {
                                   if(context.mounted) {
                                     context.read<AttendanceBloc>().add(const AttendanceEvent.loadHistory());
                                   }
                                 });
                              },
                              trailing: _buildEventActions(context, event),
                            ),
                          );
                        },
                      ),
                    ],
                    
                    const SizedBox(height: 80),
                  ],
                ),
              );
            },
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/attendance/form', extra: null).then((_) {
             if(context.mounted) {
               context.read<AttendanceBloc>().add(const AttendanceEvent.loadHistory());
             }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventActions(BuildContext context, dynamic event) {
    // Assuming event is of type Attendance
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. TAKE ATTENDANCE
        IconButton(
          icon: const Icon(Icons.checklist_rtl_rounded, color: Colors.green),
          tooltip: 'Tomar Asistencia',
          onPressed: () {
            context.push('/attendance/check', extra: event.id).then((_) {
               if(context.mounted) {
                 context.read<AttendanceBloc>().add(const AttendanceEvent.loadHistory());
               }
            });
          },
        ),
        // 2. EDIT
        IconButton(
          icon: const Icon(Icons.edit_rounded, color: Colors.blue),
          tooltip: 'Editar',
          onPressed: () {
            context.push('/attendance/form', extra: event.id).then((_) {
               if(context.mounted) {
                 context.read<AttendanceBloc>().add(const AttendanceEvent.loadHistory());
               }
            });
          },
        ),
        // 3. DELETE
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
          tooltip: 'Eliminar',
          onPressed: () => _showDeleteConfirmation(context, event),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar Evento'),
        content: Text("¿Estás seguro de que deseas eliminar '${event.title ?? event.description ?? 'este evento'}'? Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AttendanceBloc>().add(AttendanceEvent.deleteEvent(event.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, AttendanceGroup group) {
    final startDate = group.mainEvent.date;
    final endDate = startDate.add(Duration(days: (group.count - 1) * 7));
    
    final dateFormat = DateFormat.yMMMMd('es');
    final rangeText = 'Del ${dateFormat.format(startDate)} al ${dateFormat.format(endDate)}';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(Icons.repeat, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.mainEvent.title ?? group.mainEvent.description ?? 'Evento Recurrente',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Detalle de Recurrencia',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildInfoRow(Icons.date_range, 'Rango de Fechas', rangeText),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.layers, 'Total de Sesiones', '${group.count} sesiones programadas'),
              const SizedBox(height: 32),
              
              // New Actions in Modal Too
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                       Navigator.pop(ctx);
                       context.read<AttendanceBloc>().add(AttendanceEvent.deleteEvent(group.mainEvent.id));
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('ELIMINAR TODO'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                   ElevatedButton.icon(
                    onPressed: () {
                       Navigator.pop(ctx);
                       context.push('/attendance/form', extra: group.mainEvent.id).then((_) {
                           if(context.mounted) {
                              context.read<AttendanceBloc>().add(const AttendanceEvent.loadHistory());
                           }
                       });
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('EDITAR PRÓXIMO'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}
