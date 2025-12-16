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

  DateTime _normalizeDate(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

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
            final eventsMap = <String, List<Attendance>>{};
            print("--- INICIO DEBUG CALENDARIO (STRING KEYS) ---");
            print("Total eventos en la lista: ${allEvents.length}");

            for (var event in allEvents) {
               final key = _getDateKey(event.date);
               
               // PRINT EACH EVENT DATE
               print("Evento: ${event.date} -> Key: $key");

               if (eventsMap[key] == null) eventsMap[key] = [];
               eventsMap[key]!.add(event);
            }
            print("Total claves en mapa: ${eventsMap.keys.length}");
            print("--- FIN DEBUG CALENDARIO ---");

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
                        return eventsMap[_getDateKey(day)] ?? [];
                      },
                      
                      // Styling
                      calendarStyle: CalendarStyle(
                        // 1. TODAY DECORATION: Ring style (Restored)
                        todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2.0),
                          color: Colors.transparent, // No fill
                        ),
                        // 2. TODAY TEXT STYLE: Colored to match border
                        todayTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary, 
                          fontWeight: FontWeight.bold,
                        ),
                        // 3. SELECTED DECORATION: Solid fill (Kept as is)
                        selectedDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        // Marker decoration handled below or default
                        markerDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      // 4. MARKER BUILDER
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, day, events) {
                          if (events.isEmpty) return null;
                          if (isSameDay(day, _selectedDay)) return const SizedBox(); 
                          
                          return Positioned(
                             bottom: 1,
                             child: Transform.rotate(
                               angle: 0.785398, // 45 degrees
                               child: Container(
                                 width: 6.0,
                                 height: 6.0,
                                 decoration: BoxDecoration(
                                   color: Theme.of(context).colorScheme.primary,
                                   shape: BoxShape.rectangle,
                                   borderRadius: BorderRadius.circular(1),
                                 ),
                               ),
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
                       leading: Icon(Icons.calendar_today_rounded, color: Theme.of(context).colorScheme.primary),
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

  List<Attendance> _getEventsForDay(DateTime day, Map<String, List<Attendance>> map) {
    return map[_getDateKey(day)] ?? [];
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
