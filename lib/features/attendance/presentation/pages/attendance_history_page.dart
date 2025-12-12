import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';

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
            historyLoaded: (history) {
              if (history.isEmpty) {
                return const Center(child: Text('No hay eventos registrados'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final event = history[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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
                        event.description ?? 'Evento sin nombre',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        DateFormat.yMMMMEEEEd('es').format(event.date),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      onTap: () {
                         context.push('/attendance/form', extra: event.id).then((_) {
                           if(context.mounted) {
                             context.read<AttendanceBloc>().add(const AttendanceEvent.loadHistory());
                           }
                         });
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                           showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Eliminar Evento'),
                              content: const Text('¿Estás seguro de que deseas eliminar este registro?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    context.read<AttendanceBloc>().add(AttendanceEvent.deleteEvent(event.id));
                                  },
                                  child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
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
               // The BlocProvider is created locally in this Page (above).
               // When we push, we are still in this context? No, Page Stack.
               // When we return, this widget is rebuilt? No, check behavior.
               // We should manually trigger checks or use a global bloc if we wanted persistence.
               // But here we just refresh local Bloc.
               context.read<AttendanceBloc>().add(const AttendanceEvent.loadHistory());
             }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
