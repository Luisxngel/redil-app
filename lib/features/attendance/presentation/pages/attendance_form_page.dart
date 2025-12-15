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
      child: _AttendanceFormView(attendanceId: attendanceId),
    );
  }
}

class _AttendanceFormView extends StatefulWidget {
  final String? attendanceId;
  const _AttendanceFormView({this.attendanceId});

  @override
  State<_AttendanceFormView> createState() => _AttendanceFormViewState();
}

class _AttendanceFormViewState extends State<_AttendanceFormView> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now(); // NEW
  final TextEditingController _titleController = TextEditingController(); // NEW
  final TextEditingController _descController = TextEditingController();
  bool _initialized = false;
  String _targetRole = 'ALL';
  Set<String> _invitedIds = {};

  // Recurrence State
  bool _isRecurring = false;
  DateTime? _recurrenceEndDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.attendanceId == null ? 'Nuevo Evento' : 'Editar Evento'),
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
                if (existing != null && !_initialized) {
                   WidgetsBinding.instance.addPostFrameCallback((_) {
                     if (mounted) {
                       setState(() {
                         _selectedDate = existing.date;
                         _selectedTime = TimeOfDay.fromDateTime(existing.date);
                         // Migration Logic: If new 'title' is empty, use 'description' as Title if plausible
                         // Assuming schema update works, title is null for old events.
                         _titleController.text = existing.title ?? existing.description ?? '';
                         // Put details in description. If title was taken from description, maybe leave desc empty or duplicate? 
                         // Logic: If title is present, use desc as details. If only desc present, it goes to title.
                         _descController.text = existing.title == null ? '' : (existing.description ?? ''); 
                         
                         _targetRole = existing.targetRole;
                         _invitedIds = Set.from(existing.invitedMemberIds);
                         _initialized = true;
                       });
                     }
                   });
                } else if (existing == null && !_initialized) {
                   _initialized = true;
                   // Default time to next Sunday 10am? Or now.
                   _selectedTime = const TimeOfDay(hour: 10, minute: 0); 
                }
             }
           );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);
          if (isLoading) return const Center(child: CircularProgressIndicator());
          
          final allMembers = state.maybeWhen(
            formLoaded: (_, members, __) => members,
            orElse: () => <Member>[]
          );

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalles del Evento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  
                  // SECTION A: TEMPORAL (Row)
                  Row(
                    children: [
                      // Date Picker
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
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(_selectedDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Time Picker
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (picked != null) {
                              setState(() => _selectedTime = picked);
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Hora',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.access_time),
                            ),
                            child: Text(
                              _selectedTime.format(context),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // SECTION B: IDENTITY
                  // Title (Nombre)
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Evento',
                      hintText: 'Ej: Culto Dominical',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description (Detalles)
                  TextField(
                    controller: _descController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Descripción / Detalles',
                      hintText: 'Notas adicionales, tema del mensaje, etc.',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.notes_rounded),
                      alignLabelWithHint: true,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // SECTION C: LOGISTICS (Target Role)
                  DropdownButtonFormField<String>(
                    value: _targetRole,
                    decoration: const InputDecoration(
                      labelText: 'Dirigido a:',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.people_alt_outlined),
                      helperText: 'Define quiénes deben asistir obligatoriamente',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'ALL', child: Text('Todos el Redil')),
                      DropdownMenuItem(value: 'LIDER', child: Text('Solo Líderes')),
                      DropdownMenuItem(value: 'MEMBER', child: Text('Solo Miembros')),
                      DropdownMenuItem(value: 'MANUAL', child: Text('Selección Manual / Opcional')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _targetRole = val);
                      }
                    },
                  ),
                  
                  // MANUAL SELECTION LIST
                  if (_targetRole == 'MANUAL') ...[
                    const SizedBox(height: 16),
                    const Text('Seleccionar Invitados (Dejar vacío para evento opcional):', style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: allMembers.length,
                        itemBuilder: (context, index) {
                          final member = allMembers[index];
                          final isSelected = _invitedIds.contains(member.id);
                          return CheckboxListTile(
                            title: Text('${member.firstName} ${member.lastName}'),
                            subtitle: Text(member.role.label),
                            value: isSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val == true) {
                                  _invitedIds.add(member.id!);
                                } else {
                                  _invitedIds.remove(member.id);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // RECURRENCE OPTIONS (Only for new events)
                  if (widget.attendanceId == null) ...[
                     const Divider(),
                     SwitchListTile(
                       title: const Text('Repetir Evento Semanalmente'),
                       subtitle: const Text('Crea copias automáticas de este evento'),
                       value: _isRecurring,
                       onChanged: (val) {
                         setState(() {
                           _isRecurring = val;
                           if (val && _recurrenceEndDate == null) {
                             _recurrenceEndDate = _selectedDate.add(const Duration(days: 28)); // Default 4 weeks
                           }
                         });
                       },
                     ),
                     
                     if (_isRecurring) ...[
                       const SizedBox(height: 16),
                       InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _recurrenceEndDate ?? _selectedDate.add(const Duration(days: 7)),
                            firstDate: _selectedDate.add(const Duration(days: 1)),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() => _recurrenceEndDate = picked);
                          }
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Repetir hasta',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.update),
                            helperText: 'Fecha del último evento de la serie',
                          ),
                          child: Text(
                            _recurrenceEndDate != null ? DateFormat.yMMMMEEEEd('es').format(_recurrenceEndDate!) : 'Seleccionar fecha',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                     ],
                  ],

                  const SizedBox(height: 48), // Spacer replacement
                  
                  // SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: Text(widget.attendanceId == null ? 'CREAR EVENTO' : 'GUARDAR CAMBIOS'),
                       style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                         final invitedIds = (_targetRole == 'MANUAL') ? _invitedIds.toList() : <String>[];
                         
                         // COMBINE DATE AND TIME
                         final finalDate = DateTime(
                           _selectedDate.year,
                           _selectedDate.month,
                           _selectedDate.day,
                           _selectedTime.hour,
                           _selectedTime.minute,
                         );

                         context.read<AttendanceBloc>().add(AttendanceEvent.saveEvent(
                           date: finalDate, // Use combined date
                           title: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
                           description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
                           targetRole: _targetRole,
                           invitedMemberIds: invitedIds,
                           isRecurring: _isRecurring,
                           recurrenceFrequency: 'WEEKLY',
                           recurrenceEndDate: _recurrenceEndDate,
                         ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: widget.attendanceId != null
          ? FloatingActionButton.extended(
              onPressed: () {
                context.push('/attendance/check', extra: widget.attendanceId).then((_) {
                  if (context.mounted) {
                     context.read<AttendanceBloc>().add(AttendanceEvent.loadForm(widget.attendanceId));
                  }
                });
              },
              label: const Text('Tomar Asistencia'),
              icon: const Icon(Icons.checklist_rtl_rounded),
              backgroundColor: Theme.of(context).primaryColor,
            )
          : null,
    );
  }
}
