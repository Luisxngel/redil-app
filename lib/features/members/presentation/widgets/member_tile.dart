import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/member.dart';
import '../../../../core/utils/enum_extensions.dart';
import '../../../../core/theme/app_theme.dart';
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
               onPressed: () => context.push('/edit', extra: member),
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
          ],
        ),
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
