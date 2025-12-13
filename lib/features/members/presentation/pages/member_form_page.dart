import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/member.dart';
import '../../../../core/utils/enum_extensions.dart';
import '../bloc/members_bloc.dart';
import '../bloc/members_event.dart';
import '../bloc/members_state.dart';

class MemberFormPage extends StatefulWidget {
  final Member? member;
  const MemberFormPage({super.key, this.member});

  @override
  State<MemberFormPage> createState() => _MemberFormPageState();
}

class _MemberFormPageState extends State<MemberFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  
  MemberRole _role = MemberRole.member;
  MemberStatus _status = MemberStatus.active;
  CivilStatus _civilStatus = CivilStatus.single;
  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      final m = widget.member!;
      _firstNameController.text = m.firstName;
      _lastNameController.text = m.lastName;
      _phoneController.text = m.phone;
      _addressController.text = m.address ?? '';
      _notesController.text = m.notes ?? '';
      _role = m.role;
      _status = m.status;
      _civilStatus = m.civilStatus ?? CivilStatus.single;
      _dateOfBirth = m.dateOfBirth;
      _civilStatus = m.civilStatus ?? CivilStatus.single;
      _dateOfBirth = m.dateOfBirth;
    } else {
      // Explicitly clear for new member to avoid any retained state issues
      _firstNameController.clear();
      _lastNameController.clear();
      _phoneController.clear();
      _addressController.clear();
      _notesController.clear();
      _role = MemberRole.member;
      _status = MemberStatus.active;
      _civilStatus = CivilStatus.single;
      _dateOfBirth = null;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() ?? false) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final phone = _phoneController.text.trim();
      final address = _addressController.text.trim().isEmpty ? null : _addressController.text.trim();
      final notes = _notesController.text.trim().isEmpty ? null : _notesController.text.trim();

      if (widget.member == null) {
        // --- CREACION: NUEVO ID OBLIGATORIO ---
        final newId = const Uuid().v4();
        print('DEBUG: Creating NEW member with ID: $newId');

        final newMember = Member(
          id: newId,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          address: address,
          role: _role,
          status: _status,
          civilStatus: _civilStatus,
          dateOfBirth: _dateOfBirth,
          notes: notes,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDeleted: false,
        );
        context.read<MembersBloc>().add(MembersEvent.addMember(newMember));

      } else {
        // --- EDICION: MANTENER ID EXISTENTE ---
        final existingId = widget.member!.id!;
        print('DEBUG: Updating EXISTING member with ID: $existingId');

        final updatedMember = Member(
          id: existingId,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          address: address,
          role: _role,
          status: _status,
          civilStatus: _civilStatus,
          dateOfBirth: _dateOfBirth,
          notes: notes,
          createdAt: widget.member!.createdAt,
          updatedAt: DateTime.now(),
          isDeleted: widget.member!.isDeleted,
        );
        // Repository's saveMember handles upsert, so we reuse AddMember event
        // (or ideally we'd have an UpdateMember event for clarity, but this works)
        context.read<MembersBloc>().add(MembersEvent.addMember(updatedMember));
      }
    }
  }
  
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dateOfBirth = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.member == null ? 'Nuevo Miembro' : 'Editar Miembro')),
      body: BlocListener<MembersBloc, MembersState>(
        listener: (context, state) {
          state.whenOrNull(
            actionSuccess: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
              context.pop();
            },
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(message), backgroundColor: Colors.red),
              );
            }
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                   TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Apellido',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                       if (v == null || v.isEmpty) return null;
                       if (!Member.isValidPhone(v)) return 'Formato inválido';
                       return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Dirección',
                      prefixIcon: Icon(Icons.place),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: _dateOfBirth == null 
                            ? '' 
                            : DateFormat('dd/MM/yyyy').format(_dateOfBirth!)
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Fecha de Nacimiento',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CivilStatus>(
                    value: _civilStatus,
                    decoration: const InputDecoration(
                      labelText: 'Estado Civil',
                      prefixIcon: Icon(Icons.family_restroom),
                    ),
                    items: CivilStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.label),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _civilStatus = v!),
                  ),
                   const SizedBox(height: 16),
                  DropdownButtonFormField<MemberRole>(
                    value: _role,
                    decoration: const InputDecoration(
                      labelText: 'Rol',
                      prefixIcon: Icon(Icons.badge),
                    ),
                    items: MemberRole.values.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role.label.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _role = v!),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<MemberStatus>(
                    value: _status,
                    decoration: const InputDecoration(
                      labelText: 'Estado',
                      prefixIcon: Icon(Icons.check_circle_outline),
                    ),
                    items: MemberStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status.label.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _status = v!),
                  ),
                   const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notas Pastorales',
                      prefixIcon: Icon(Icons.notes),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _save,
                      child: const Text('GUARDAR'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
