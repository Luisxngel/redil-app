import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/di/injection.dart';
import '../../../attendance/domain/entities/attendance.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_event.dart';
import '../../../attendance/presentation/bloc/attendance_state.dart';

class DashboardCalendar extends StatefulWidget {
  const DashboardCalendar({super.key});

  @override
  State<DashboardCalendar> createState() => _DashboardCalendarState();
}

class _DashboardCalendarState extends State<DashboardCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    // We need Attendance data. 
    // Ideally DashboardBloc handles this, but AttendanceBloc is the source.
    // Let's inject AttendanceBloc or assume it's provided above?
    // DashboardPage creates DashboardBloc. It does NOT currently provide AttendanceBloc.
    // We should wrap this widget with AttendanceBloc provider or use a Repository directly via StreamBuilder?
    // Better: wrap in BlocProvider locally just for reading history.
    
    return BlocProvider(
       create: (context) => getIt<AttendanceBloc>()..add(const AttendanceEvent.loadHistory()),
       child: BlocBuilder<AttendanceBloc, AttendanceState>(
         builder: (context, state) {
            final List<Attendance> allEvents = state.maybeWhen(
              historyLoaded: (events, _) => events,
              orElse: () => [],
            );

            // Map events to days
            // We need a map for the eventLoader
            final eventsMap = <DateTime, List<Attendance>>{};
            for (var event in allEvents) {
               final date = DateUtils.dateOnly(event.date);
               if (eventsMap[date] == null) eventsMap[date] = [];
               eventsMap[date]!.add(event);
            }

            final selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay, eventsMap);

            return Column(
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TableCalendar<Attendance>(
                      firstDay: DateTime.now().subtract(const Duration(days: 365)),
                      lastDay: DateTime.now().add(const Duration(days: 365)),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Mes',
                      },
                      
                      // Localization
                      locale: 'es_ES',
                      
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                           setState(() {
                             _calendarFormat = format;
                           });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      
                      eventLoader: (day) {
                        return _getEventsForDay(day, eventsMap);
                      },
                      
                      // Styling
                      calendarStyle: CalendarStyle(
                        // 1. TODAY DECORATION: Ring, not solid
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2.0),
                        ),
                        // 2. TODAY TEXT STYLE
                        todayTextStyle: TextStyle(
                          color: Theme.of(context).primaryColor, 
                          fontWeight: FontWeight.bold,
                        ),
                        // 3. SELECTED DECORATION: Solid fill
                        selectedDecoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        // Marker decoration handled below or default
                        markerDecoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // 4. MARKER BUILDER
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          if (events.isEmpty) return null;
                          if (isSameDay(day, _selectedDay)) return const SizedBox(); // Hide if selected
                          
                          return Positioned(
                             bottom: 1,
                             child: Container(
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 color: Theme.of(context).primaryColor,
                               ),
                               width: 7.0,
                               height: 7.0,
                               margin: const EdgeInsets.symmetric(horizontal: 1.5),
                             ),
                           );
                        },
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (selectedEvents.isNotEmpty) ...[
                   const Align(
                     alignment: Alignment.centerLeft,
                     child: Text("Eventos del día", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                   ),
                   const SizedBox(height: 8),
                   ...selectedEvents.map((e) => Card(
                     margin: const EdgeInsets.only(bottom: 8),
                     child: ListTile(
                       title: Text(e.title ?? e.description ?? 'Evento sin nombre'),
                       subtitle: Text(DateFormat('HH:mm').format(e.date)),
                       trailing: const Icon(Icons.chevron_right),
                       leading: Icon(Icons.event, color: Theme.of(context).primaryColor),
                       onTap: () => _showEventBriefing(context, e), // CHANGED
                     ),
                   )),
                ]
              ],
            );
         },
       ),
    );
  }

  List<Attendance> _getEventsForDay(DateTime day, Map<DateTime, List<Attendance>> map) {
    // Normalize logic
    final normalized = DateUtils.dateOnly(day);
    return map[normalized] ?? [];
  }

  // --- STEP 2: EVENT BRIEFING MODAL ---
  void _showEventBriefing(BuildContext context, Attendance event) {
    // Capture Bloc from current context (under BlocProvider)
    final bloc = context.read<AttendanceBloc>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) { // Use 'ctx' to avoid confusion, but we might need 'context' for theme
        final theme = Theme.of(context);
        final dateStr = DateFormat('EEEE d MMM', 'es').format(event.date);
        final timeStr = DateFormat('h:mm a').format(event.date);
        final isPast = event.date.isBefore(DateTime.now());

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(Icons.event, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title ?? 'Evento',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        // Badge
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPast ? Colors.grey[200] : Colors.amber[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isPast ? 'Finalizado' : 'Pendiente',
                            style: TextStyle(
                              fontSize: 10, 
                              color: isPast ? Colors.grey[800] : Colors.amber[900],
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // INFO ROW
              Row(
                children: [
                   Icon(Icons.access_time_rounded, size: 20, color: Colors.grey[600]),
                   const SizedBox(width: 8),
                   Text('$dateStr • $timeStr', style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(height: 12),
              
              // DESCRIPTION
              Text(
                event.description ?? "Sin detalles adicionales",
                style: TextStyle(color: Colors.grey[700], fontStyle: event.description == null ? FontStyle.italic : FontStyle.normal),
              ),
              const SizedBox(height: 12),

              // AUDIENCE
              Row(
                children: [
                   Icon(Icons.group_outlined, size: 20, color: Colors.grey[600]),
                   const SizedBox(width: 8),
                   Text("Dirigido a: ${event.targetRole}", style: TextStyle(color: Colors.grey[600])),
                ],
              ),

              const SizedBox(height: 32),

              // ACTION BAR
              Row(
                children: [
                  // 1. BIG BUTTON: Tomar Asistencia
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.push('/attendance/check', extra: event.id).then((_) {
                           // Try to refresh if possible
                           if (context.mounted) bloc.add(const AttendanceEvent.loadHistory());
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.checklist_rtl_rounded),
                      label: const Text("Tomar Asistencia"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 2. ICON BUTTON: Edit
                  IconButton.filledTonal(
                    onPressed: () {
                      Navigator.pop(ctx);
                      context.push('/attendance/form', extra: event.id).then((_) {
                           if (context.mounted) bloc.add(const AttendanceEvent.loadHistory());
                      });
                    },
                    icon: const Icon(Icons.edit_rounded, color: Colors.blue),
                    tooltip: 'Editar',
                  ),
                  const SizedBox(width: 8),
                  // 3. ICON BUTTON: Delete
                  IconButton.filledTonal(
                    onPressed: () {
                      // Confirmation
                      showDialog(
                        context: ctx,
                        builder: (confirmCtx) => AlertDialog(
                          title: const Text('Eliminar Evento'),
                          content: const Text('¿Estás seguro? Esta acción es irreversible.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(confirmCtx), child: const Text('CANCELAR')),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(confirmCtx); // Close Dialog
                                Navigator.pop(ctx); // Close Modal
                                bloc.add(AttendanceEvent.deleteEvent(event.id));
                              }, 
                              child: const Text('ELIMINAR', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                    tooltip: 'Eliminar',
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
