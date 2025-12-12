import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/statistics_service.dart';
import '../../../../core/utils/enum_extensions.dart';
import '../../domain/entities/member.dart';
import '../widgets/whatsapp_message_dialog.dart';

class MemberProfilePage extends StatelessWidget {
  final Member member;

  const MemberProfilePage({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Match Dashboard bg
      appBar: AppBar(
        title: const Text('Perfil de Miembro'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildStatsCard(context),
            const SizedBox(height: 24),
            _buildHistoryList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getIt<StatisticsService>().getMemberStats(member.id!),
      builder: (context, snapshot) {
        // Default to grey if loading
        Color ringColor = Colors.grey;
        if (snapshot.hasData) {
          final percentage = snapshot.data!['percentage'] as double;
          // Exact same logic as Tile
          if (member.status == MemberStatus.suspended) {
             ringColor = Colors.red;
          } else if (member.status == MemberStatus.inactive) {
             ringColor = Colors.grey;
          } else if (percentage < 50) {
             ringColor = Colors.red;
          } else {
             ringColor = Colors.green;
          }
        } else if (member.status == MemberStatus.active) {
            // Optimistic active
            ringColor = Colors.green;
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4), // Ring thickness
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: 3),
              ),
              child: CircleAvatar(
                radius: 50, // Giant Avatar
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Text(
                  member.firstName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${member.firstName} ${member.lastName}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              member.role.label.toUpperCase(),
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              member.phone,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: () {}, // TODO: Implement call
                  icon: const Icon(Icons.call),
                  tooltip: 'Llamar',
                ),
                const SizedBox(width: 16),
                 IconButton.filledTonal(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => WhatsAppMessageDialog(member: member),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble), 
                   style: IconButton.styleFrom(
                     backgroundColor: Colors.green.shade50,
                     foregroundColor: Colors.green,
                   ),
                  tooltip: 'WhatsApp',
                ),
                const SizedBox(width: 16),
                IconButton.filledTonal(
                  onPressed: () => context.push('/edit', extra: member),
                  icon: const Icon(Icons.edit),
                  tooltip: 'Editar',
                ),
              ],
            ),
          ],
        );
      }
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getIt<StatisticsService>().getMemberHistory(member.id!),
      builder: (context, snapshot) {
         if (!snapshot.hasData) {
           return const Card(child: Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())));
         }
         final history = snapshot.data!;
         final total = history.length;
         final attended = history.where((e) => e['attended'] as bool).length;
         final percent = total > 0 ? (attended / total * 100) : 0.0;

         return Card(
           elevation: 2,
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
           child: Padding(
             padding: const EdgeInsets.all(20),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 _StatItem(
                   label: '% Asistencia',
                   value: '${percent.toStringAsFixed(1)}%',
                   color: Colors.blue,
                 ),
                 _StatItem(
                   label: 'Eventos',
                   value: attended.toString(),
                   color: Colors.purple,
                 ),
               ],
             ),
           ),
         );
      },
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getIt<StatisticsService>().getMemberHistory(member.id!),
      builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
           return const Center(child: CircularProgressIndicator());
         }
         if (snapshot.hasError) {
           return Text('Error: ${snapshot.error}');
         }
         final history = snapshot.data ?? [];
         
         if (history.isEmpty) {
           return const Center(child: Text('No hay historial de asistencia.'));
         }

         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             const Text('Historial Reciente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
             const SizedBox(height: 12),
             ListView.builder(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               itemCount: history.length,
               itemBuilder: (context, index) {
                 final item = history[index];
                 final date = item['date'] as DateTime;
                 final attended = item['attended'] as bool;
                 return ListTile(
                   leading: Icon(
                     attended ? Icons.check_circle_outline : Icons.cancel_outlined,
                     color: attended ? Colors.green : Colors.red,
                   ),
                   title: Text(DateFormat('EEEE d MMM, y', 'es').format(date)),
                   subtitle: Text(item['description'] ?? 'Evento'),
                 );
               },
             ),
           ],
         );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
