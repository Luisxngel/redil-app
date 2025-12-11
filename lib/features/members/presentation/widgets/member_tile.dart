import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/member.dart';
import '../../../../core/utils/enum_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/members_bloc.dart';
import '../bloc/members_event.dart';
import 'whatsapp_message_dialog.dart';

class MemberTile extends StatelessWidget {
  final Member member;
  final VoidCallback? onTap;

  const MemberTile({super.key, required this.member, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onTap,
        title: Row(
          children: [
            Expanded(
              child: Text(
                '${member.firstName} ${member.lastName}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            if (_isBirthdayToday(member.dateOfBirth))
              const Icon(Icons.cake, color: AppTheme.secondaryColor),
          ],
        ),
        subtitle: Text(
          member.role.label.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             _buildStatusIcon(member.status),
             const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  context.push('/edit', extra: member).then((_) {
                    if (context.mounted) {
                      context.read<MembersBloc>().add(const MembersEvent.loadMembers());
                    }
                  });
                },
              ),
             IconButton(
               icon: const Icon(Icons.chat, color: Colors.green),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => WhatsAppMessageDialog(member: member),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
        ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Enviar a papelera a ${member.firstName}?'),
        content: const Text('Podrás restaurarlo luego desde la papelera.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<MembersBloc>().add(MembersEvent.deleteMember(member.id!));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );
  }

  bool _isBirthdayToday(DateTime? dob) {
    if (dob == null) return false;
    final now = DateTime.now();
    return dob.day == now.day && dob.month == now.month;
  }

  Widget _buildStatusIcon(MemberStatus status) {
    Color color;
    switch (status) {
      case MemberStatus.active:
        color = Colors.green;
        break;
      case MemberStatus.inactive:
        color = Colors.grey;
        break;
      case MemberStatus.suspended:
        color = Colors.red;
        break;
    }
    return Tooltip(
      message: status.label,
      child: Icon(Icons.circle, color: color, size: 14),
    );
  }
}
