import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class IdentityDialog extends StatefulWidget {
  const IdentityDialog({super.key});

  @override
  State<IdentityDialog> createState() => _IdentityDialogState();
}

class _IdentityDialogState extends State<IdentityDialog> {
  late TextEditingController _nameController;
  late TextEditingController _churchController;

  @override
  void initState() {
    super.initState();
    final state = context.read<SettingsBloc>().state;
    _nameController = TextEditingController(text: state.userName);
    _churchController = TextEditingController(text: state.churchName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _churchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personalizar Identidad'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Tu Nombre',
                hintText: 'Ej. Pastor Juan',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _churchController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Ministerio',
                hintText: 'Ej. Iglesia Vida',
                prefixIcon: Icon(Icons.church_outlined),
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.tonal(
          onPressed: () {
            context.read<SettingsBloc>().add(
              SettingsEvent.updateIdentity(
                userName: _nameController.text.trim(),
                churchName: _churchController.text.trim(),
              ),
            );
            Navigator.pop(context);
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
