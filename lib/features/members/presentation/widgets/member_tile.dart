import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/member.dart';
import '../../../../core/utils/enum_extensions.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/statistics_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/members_bloc.dart';
import '../bloc/members_event.dart';
import 'whatsapp_message_dialog.dart';

class MemberTile extends StatelessWidget {
  final Member member;
  final VoidCallback? onTap;

  const MemberTile({super.key, required this.member, this.onTap});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getIt<StatisticsService>().getMemberStats(member.id!),
      builder: (context, snapshot) {
        final stats = snapshot.data ?? {'percentage': 0.0};
        final percentage = stats['percentage'] as double;
        final history = stats['history'] as List<Map<String, dynamic>>? ?? [];
        final status = stats['status'] as String? ?? 'ACTIVE';
        final extraCount = stats['extraCount'] as int? ?? 0;

        return Card(
          elevation: 0.5,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            onTap: () => _showMemberStatsDialog(context, percentage, history),
            leading: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getStatusColor(member, percentage, status),
                  width: 2.5,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Text(
                  member.firstName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '${member.firstName} ${member.lastName}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                  if (extraCount > 0)
                     Padding(
                       padding: const EdgeInsets.only(right: 8.0),
                       child: Icon(Icons.star_rate_rounded, size: 16, color: Colors.amber.shade800),
                     ),
                  if (_isBirthdayToday(member.dateOfBirth))
                    Icon(Icons.cake, color: Theme.of(context).colorScheme.secondary, size: 20),
              ],
            ),
            subtitle: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12, color: Colors.grey[600]),
                children: [
                  TextSpan(text: member.role.label.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w500)),
                  const TextSpan(text: '  |  '),
                  if (status == 'NEUTRAL')
                    const TextSpan(
                      text: '--', 
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)
                    )
                  else
                    TextSpan(
                      text: '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: percentage < 50 ? Colors.red : Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ... buttons ...
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
                   icon: const Icon(Icons.chat_bubble_outline, color: Colors.green),
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
      },
    );
  }

  Color _getStatusColor(Member member, double percentage, String status) {
    if (member.status == MemberStatus.suspended) return Colors.red;
    if (member.status == MemberStatus.inactive) return Colors.grey;
    if (status == 'NEUTRAL') return Colors.grey.withOpacity(0.5);
    
    // Heuristic: If percentage < 50% -> Warning/Red
    if (percentage < 50) return Colors.red;
    
    return Colors.green; // Default Active/Present
  }

  void _showMemberStatsDialog(BuildContext context, double percentage, List<Map<String, dynamic>> history) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('${member.firstName} ${member.lastName}', style: const TextStyle(fontWeight: FontWeight.bold))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Percentage Indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      value: percentage / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(percentage < 50 ? Colors.red : Colors.green),
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Últimos Eventos:', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              if (history.isEmpty)
                const Text('Sin historial reciente.', style: TextStyle(color: Colors.grey)),
              ...history.take(5).map((event) {
                final attended = event['attended'] as bool;
                final date = event['date'] as DateTime;
                final description = event['description'] as String? ?? 'Evento';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        attended ? Icons.check_circle_outline : Icons.cancel_outlined,
                        color: attended ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      // Extract Date
                      Expanded(
                        child: Text(
                           '${DateFormat('dd/MM').format(date)} - $description',
                           style: const TextStyle(fontSize: 13),
                           overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CERRAR'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/member/profile', extra: member);
              },
              child: const Text('VER PERFIL COMPLETO'),
            ),
          ],
        );
      },
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
}
