import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/member.dart';
import '../../../../core/utils/enum_extensions.dart';
import '../bloc/member_form/member_form_bloc.dart';
import '../bloc/member_form/member_form_event.dart';
import '../bloc/member_form/member_form_state.dart';
import '../bloc/members_bloc.dart';
import '../bloc/members_event.dart';

class MemberFormPage extends StatelessWidget {
  final Member? member;
  const MemberFormPage({super.key, this.member});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MemberFormBloc>()..add(MemberFormEvent.initialize(member)),
      child: const _MemberFormView(),
    );
  }
}

class _MemberFormView extends StatefulWidget {
  const _MemberFormView();

  @override
  State<_MemberFormView> createState() => _MemberFormViewState();
}

class _MemberFormViewState extends State<_MemberFormView> {
  final _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && context.mounted) {
      context.read<MemberFormBloc>().add(MemberFormEvent.photoChanged(image.path));
    }
  }
  
  // Also offer Camera option
  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Cámara'),
              onTap: () async {
                Navigator.pop(ctx);
                final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                 if (image != null && context.mounted) {
                   context.read<MemberFormBloc>().add(MemberFormEvent.photoChanged(image.path));
                 }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galería'),
              onTap: () async {
                Navigator.pop(ctx);
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                 if (image != null && context.mounted) {
                   context.read<MemberFormBloc>().add(MemberFormEvent.photoChanged(image.path));
                 }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, DateTime? currentDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && context.mounted) {
      context.read<MemberFormBloc>().add(MemberFormEvent.dateOfBirthChanged(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MemberFormBloc, MemberFormState>(
      listener: (context, state) {
         if (state.isSuccess) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Miembro guardado correctamente')));
           // Refresh list
           context.read<MembersBloc>().add(const MembersEvent.loadMembers());
           context.pop();
         }
         if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red));
         }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.isEditing ? 'Editar Discípulo' : 'Nuevo Discípulo'),
            actions: [
              if (state.isSubmitting)
                const Padding(padding: EdgeInsets.all(16.0), child: CircularProgressIndicator.adaptive())
              else
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => context.read<MemberFormBloc>().add(const MemberFormEvent.submit()),
                )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // HEADER: Photo
                Center(
                  child: GestureDetector(
                    onTap: () => _showPhotoOptions(context),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: state.photoPath != null 
                             ? FileImage(File(state.photoPath!)) 
                             : null,
                          backgroundColor: Colors.grey[200],
                          child: state.photoPath == null 
                            ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                            : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Icon(Icons.edit, size: 16, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // SECTION 1: PERSONAL INFO
                _SectionTitle('INFORMACIÓN PERSONAL'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: state.firstName,
                        decoration: const InputDecoration(labelText: 'Nombre', prefixIcon: Icon(Icons.person)),
                        onChanged: (v) => context.read<MemberFormBloc>().add(MemberFormEvent.firstNameChanged(v)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: state.lastName,
                        decoration: const InputDecoration(labelText: 'Apellido', prefixIcon: Icon(Icons.person_outline)),
                        onChanged: (v) => context.read<MemberFormBloc>().add(MemberFormEvent.lastNameChanged(v)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickDate(context, state.dateOfBirth),
                        child: AbsorbPointer(
                          child: TextFormField(
                            key: ValueKey(state.dateOfBirth), // Force rebuild to update text
                            initialValue: state.dateOfBirth != null ? DateFormat('dd/MM/yyyy').format(state.dateOfBirth!) : '',
                            decoration: const InputDecoration(labelText: 'Fecha Nacimiento', prefixIcon: Icon(Icons.cake)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<CivilStatus>(
                        value: state.civilStatus,
                        decoration: const InputDecoration(labelText: 'Estado Civil', prefixIcon: Icon(Icons.family_restroom)),
                        items: CivilStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))).toList(),
                        onChanged: (v) => context.read<MemberFormBloc>().add(MemberFormEvent.civilStatusChanged(v!)),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // SECTION 2: CONTACTO Y PROFESIÓN
                _SectionTitle('CONTACTO Y PROFESIÓN'),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: state.phone,
                        decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone)),
                        keyboardType: TextInputType.phone,
                        onChanged: (v) => context.read<MemberFormBloc>().add(MemberFormEvent.phoneChanged(v)),
                      ),
                    ),
                     const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: state.profession, // NEW FIELD
                        decoration: const InputDecoration(labelText: 'Profesión', prefixIcon: Icon(Icons.work)),
                        onChanged: (v) => context.read<MemberFormBloc>().add(MemberFormEvent.professionChanged(v)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: state.address,
                  decoration: const InputDecoration(labelText: 'Dirección', prefixIcon: Icon(Icons.place)),
                  onChanged: (v) => context.read<MemberFormBloc>().add(MemberFormEvent.addressChanged(v)),
                ),

                const SizedBox(height: 24),

                // SECTION 3: ESTATUS ECLESIÁSTICO
                _SectionTitle('ESTATUS ECLESIÁSTICO'),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<MemberRole>(
                        value: state.role,
                        decoration: const InputDecoration(labelText: 'Rol', prefixIcon: Icon(Icons.badge)),
                        items: MemberRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label.toUpperCase()))).toList(),
                        onChanged: (v) => context.read<MemberFormBloc>().add(MemberFormEvent.roleChanged(v!)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<MemberStatus>(
                        value: state.status,
                        decoration: const InputDecoration(labelText: 'Estado', prefixIcon: Icon(Icons.check_circle_outline)),
                        items: MemberStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label.toUpperCase()))).toList(),
                        onChanged: (v) => context.read<MemberFormBloc>().add(MemberFormEvent.statusChanged(v!)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // FOOTER: NOTES
                TextFormField(
                  initialValue: state.notes,
                  decoration: const InputDecoration(labelText: 'Notas Pastorales', prefixIcon: Icon(Icons.notes)),
                  maxLines: 3,
                  onChanged: (v) => context.read<MemberFormBloc>().add(MemberFormEvent.notesChanged(v)),
                ),
                const SizedBox(height: 32),
                
                ElevatedButton(
                  onPressed: state.isSubmitting 
                    ? null 
                    : () => context.read<MemberFormBloc>().add(const MemberFormEvent.submit()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('GUARDAR DATOS'),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
