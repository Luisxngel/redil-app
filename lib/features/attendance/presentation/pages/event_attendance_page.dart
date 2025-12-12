import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/enum_extensions.dart';
import '../../../members/domain/entities/member.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';

class EventAttendancePage extends StatelessWidget {
  final String attendanceId;

  const EventAttendancePage({super.key, required this.attendanceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AttendanceBloc>()..add(AttendanceEvent.loadForm(attendanceId)),
      child: const _EventAttendanceView(),
    );
  }
}

class _EventAttendanceView extends StatelessWidget {
  const _EventAttendanceView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tomar Asistencia'),
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
           state.whenOrNull(
             actionSuccess: (msg) {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
               // Stay on page or pop? Usually pop after saving attendance? 
               // Or stay to allow corrections. User can pop manually.
               // Let's pop to confirm.
               context.pop();
             },
             error: (msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red)),
           );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            formLoaded: (existingEvent, allMembers, selectedIds) {
               if (existingEvent == null) {
                 return const Center(child: Text('Error: Evento no encontrado'));
               }

               // Group members
               final Map<MemberRole, List<Member>> groupedMembers = {};
              for (var member in allMembers) {
                if (!groupedMembers.containsKey(member.role)) {
                  groupedMembers[member.role] = [];
                }
                groupedMembers[member.role]!.add(member);
              }
               final sortedRoles = groupedMembers.keys.toList()
                ..sort((a, b) => a.index.compareTo(b.index));
              
              return Column(
                children: [
                  // HEADER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          existingEvent.description ?? 'Evento Sin Nombre',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat.yMMMMEEEEd('es').format(existingEvent.date),
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  
                  // BODY
                   Expanded(
                     child: ListView.builder(
                       itemCount: sortedRoles.length,
                       itemBuilder: (context, index) {
                          final role = sortedRoles[index];
                          final roleMembers = groupedMembers[role]!;
                          roleMembers.sort((a, b) => a.firstName.compareTo(b.firstName));
                          
                          final count = roleMembers.length;
                          final selectedInGroup = roleMembers.where((m) => selectedIds.contains(m.id)).length;

                          return ExpansionTile(
                            initiallyExpanded: true,
                            title: Row(
                              children: [
                                Text(
                                  role.labelPlural.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text('$selectedInGroup / $count', style: const TextStyle(fontSize: 12)),
                                )
                              ],
                            ),
                            children: roleMembers.map((member) {
                              final isSelected = selectedIds.contains(member.id);
                              return CheckboxListTile(
                                value: isSelected,
                                activeColor: Colors.green,
                                title: Text('${member.firstName} ${member.lastName}'),
                                secondary: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: isSelected ? Colors.green.withOpacity(0.2) : Colors.grey[200],
                                  child: Text(
                                    member.firstName[0],
                                    style: TextStyle(color: isSelected ? Colors.green : Colors.grey),
                                  ),
                                ),
                                onChanged: (val) {
                                  context.read<AttendanceBloc>().add(AttendanceEvent.toggleMember(member.id!));
                                },
                              );
                            }).toList(),
                          );
                       },
                     ),
                   ),
                   
                   // FOOTER ACTION
                   Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('CONFIRMAR ASISTENCIA'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                           context.read<AttendanceBloc>().add(AttendanceEvent.saveEvent(
                             date: existingEvent.date,
                             description: existingEvent.description,
                           ));
                        },
                      ),
                    ),
                   ),
                ],
              );
            },
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
