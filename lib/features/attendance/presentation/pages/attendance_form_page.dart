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
  final TextEditingController _descController = TextEditingController();
  bool _initialized = false;
  String _targetRole = 'ALL';
  Set<String> _invitedIds = {};

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
                         _descController.text = existing.description ?? '';
                         _targetRole = existing.targetRole;
                         _invitedIds = Set.from(existing.invitedMemberIds);
                         _initialized = true;
                       });
                     }
                   });
                } else if (existing == null && !_initialized) {
                   _initialized = true;
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
                  
                  // DATE PICKER
                  InkWell(
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
                        labelText: 'Fecha del Evento',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                        helperText: 'Día en que se realizará la reunión',
                      ),
                      child: Text(
                        DateFormat.yMMMMEEEEd('es').format(_selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // DESCRIPTION
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre / Descripción',
                      hintText: 'Ej: Culto Dominical, Reunión de Jóvenes',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event_note),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // TARGET ROLE DROPDOWN
                  DropdownButtonFormField<String>(
                    value: _targetRole,
                    decoration: const InputDecoration(
                      labelText: 'Dirigido a:',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.people_alt_outlined),
                      helperText: 'Define quiénes deben asistir obligatoriamente',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'ALL', child: Text('Todo el Redil (Obligatorio)')),
                      DropdownMenuItem(value: 'LIDER', child: Text('Solo Líderes')),
                      DropdownMenuItem(value: 'MEMBER', child: Text('Solo Miembros')),
                      DropdownMenuItem(value: 'OPTIONAL', child: Text('Opcional / Libre')),
                      DropdownMenuItem(value: 'MANUAL', child: Text('Selección Manual')),
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
                    const Text('Seleccionar Invitados:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                         context.read<AttendanceBloc>().add(AttendanceEvent.saveEvent(
                           date: _selectedDate,
                           description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
                           targetRole: _targetRole,
                           invitedMemberIds: _invitedIds.toList(),
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
    );
  }
}
