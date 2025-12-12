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

class AttendanceFormPage extends StatelessWidget {
  final String? attendanceId;

  const AttendanceFormPage({super.key, this.attendanceId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AttendanceBloc>()..add(AttendanceEvent.loadForm(attendanceId)),
      child: const _AttendanceFormView(),
    );
  }
}

class _AttendanceFormView extends StatefulWidget {
  const _AttendanceFormView();

  @override
  State<_AttendanceFormView> createState() => _AttendanceFormViewState();
}

class _AttendanceFormViewState extends State<_AttendanceFormView> {
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
               context.read<AttendanceBloc>().add(AttendanceEvent.saveEvent(
                 date: _selectedDate,
                 description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
               ));
            },
          )
        ],
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
           state.whenOrNull(
             actionSuccess: (msg) {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
               context.pop();
             },
             error: (msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red)),
             formLoaded: (existing, members, selected) {
                if (existing != null && _descController.text.isEmpty) {
                   // Only set once
                   _descController.text = existing.description ?? '';
                   // setState not needed if just text field?
                   // But date needs setState
                   // Wait, this listener runs every time state changes (including toggle).
                   // We shouldn't reset fields on toggle.
                   // Bloc emits a new FormLoaded on Toggle.
                   // We need a check.
                }
             }
           );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            formLoaded: (existingEvent, allMembers, selectedIds) {
               // Setup check for initial data load ONLY ONCE
               // Actually we can do it in Builder if we guard it, or initState equivalent.
               // A trick is to use a boolean flag in State or check if controllers are empty vs existing.
               if (existingEvent != null && _selectedDate == DateTime.now() && _selectedDate.difference(existingEvent.date).inSeconds.abs() > 5) { // Dummy check
                   // Ideally we set this in Bloc's state or pass it to UI differently.
                   // But let's trust that if the user hasn't changed it, we sync.
                   // A better way: The State holds the source of truth? No, TextField holds it.
                   // Let's just update `_selectedDate` if it matches default.
                   // For now, let's execute this assignment synchronously in the builder is okay? No, setState in builder is bad.
                   // We should initialize in `listener` but guard it.
               }
               // Wait, I can just use a local bool `_initialized`.
               if (!_initialized && existingEvent != null) {
                 WidgetsBinding.instance.addPostFrameCallback((_) {
                   setState(() {
                     _selectedDate = existingEvent.date;
                     _descController.text = existingEvent.description ?? '';
                     _initialized = true;
                   });
                 });
               } else if (!_initialized && existingEvent == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                   setState(() {
                     _initialized = true; // Mark as initialized for new event too
                   });
                 });
               }

              // Group logic (Duplicated from MembersPage, could be refactored to a shared widget)
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
                   Padding(
                     padding: const EdgeInsets.all(16.0),
                     child: Row(
                       children: [
                         Expanded(
                           child: InkWell(
                             onTap: () async {
                               final picked = await showDatePicker(
                                 context: context,
                                 initialDate: _selectedDate,
                                 firstDate: DateTime(2020),
                                 lastDate: DateTime(2030),
                               );
                               if (picked != null) {
                                 setState(() => _selectedDate = picked);
                               }
                             },
                             child: InputDecorator(
                               decoration: const InputDecoration(
                                 labelText: 'Fecha',
                                 border: OutlineInputBorder(),
                                 prefixIcon: Icon(Icons.calendar_today),
                               ),
                               child: Text(DateFormat.yMMMMEEEEd('es').format(_selectedDate)),
                             ),
                           ),
                         ),
                         const SizedBox(width: 16),
                         Expanded(
                           child: TextField(
                             controller: _descController,
                             decoration: const InputDecoration(
                               labelText: 'Descripción (Opcional)',
                               border: OutlineInputBorder(),
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                   const Divider(),
                   Expanded(
                     child: ListView.builder(
                       itemCount: sortedRoles.length,
                       itemBuilder: (context, index) {
                          final role = sortedRoles[index];
                          final roleMembers = groupedMembers[role]!;
                          roleMembers.sort((a, b) => a.firstName.compareTo(b.firstName));
                          
                          final count = roleMembers.length;
                          // Count selected in this group
                          final selectedInGroup = roleMembers.where((m) => selectedIds.contains(m.id)).length;

                          return ExpansionTile(
                            initiallyExpanded: true, // Always expand for taking roll? Or same logic? Let's Expand All for easier checklist.
                            title: Row(
                              children: [
                                Text(
                                  role.labelPlural.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                const Spacer(),
                                Chip(label: Text('$selectedInGroup / $count'), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,)
                              ],
                            ),
                            children: roleMembers.map((member) {
                              final isSelected = selectedIds.contains(member.id); // member.id should be the UUID string now
                              return CheckboxListTile(
                                value: isSelected,
                                title: Text('${member.firstName} ${member.lastName}'),
                                secondary: CircleAvatar(
                                  radius: 16,
                                  child: Text(member.firstName[0]),
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
                   Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('GUARDAR ASISTENCIA'),
                        onPressed: () {
                           context.read<AttendanceBloc>().add(AttendanceEvent.saveEvent(
                             date: _selectedDate,
                             description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
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

  bool _initialized = false;
}
