import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/communication_service.dart';
import '../../domain/entities/member.dart';

class WhatsAppMessageDialog extends StatefulWidget {
  final Member member;

  const WhatsAppMessageDialog({super.key, required this.member});

  @override
  State<WhatsAppMessageDialog> createState() => _WhatsAppMessageDialogState();
}

class _WhatsAppMessageDialogState extends State<WhatsAppMessageDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyTemplate(String template) {
    final text = template.replaceAll('[Name]', widget.member.firstName);
    _controller.text = text;
    // Move cursor to end
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  void _send() {
    final service = getIt<CommunicationService>();
    service.openWhatsApp(widget.member.phone, message: _controller.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Contactar a ${widget.member.firstName}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plantillas Rápidas:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.waving_hand, size: 16),
                  label: const Text('Saludar'),
                  onPressed: () => _applyTemplate('¡Hola [Name]! Bendiciones.'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.event_busy, size: 16),
                  label: const Text('Falta'),
                  onPressed: () => _applyTemplate('Hola [Name], te extrañamos hoy en el servicio.'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.cake, size: 16),
                  label: const Text('Cumpleaños'),
                  onPressed: () => _applyTemplate('¡Feliz cumpleaños [Name]! Que Dios te bendiga mucho.'),
                ),
                ActionChip(
                  avatar: const Icon(Icons.notifications, size: 16),
                  label: const Text('Recordatorio'),
                  onPressed: () => _applyTemplate('Hola [Name], recuerda que...'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Mensaje',
                border: OutlineInputBorder(),
                hintText: 'Escribe tu mensaje aquí...',
              ),
              maxLines: 5,
              minLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCELAR'),
        ),
        ElevatedButton.icon(
          onPressed: _send,
          icon: const Icon(Icons.send, size: 16),
          label: const Text('ENVIAR WHATSAPP'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
