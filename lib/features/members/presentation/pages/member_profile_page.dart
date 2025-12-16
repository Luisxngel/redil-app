import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/pdf_service.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Perfil de Miembro'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Exportar Reporte',
            onPressed: () => _onExport(context),
          ),
        ],
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

  Future<void> _onExport(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generando reporte PDF...')),
    );

    try {
      final statsService = getIt<StatisticsService>();
      final stats = await statsService.getMemberStats(member.id!);
      
      // We need the history list for the PDF
      // The service call getMemberHistory returns List<Map>, but PDF needs List<Attendance> or similar.
      // StatisticsService.getMemberHistory returns List<Map>, not the raw entities.
      // However, we can fetch the raw history from the repo if exposed, OR just use the Map data if we adjust the PdfService.
      // Wait, PdfService defined above expects List<Attendance>. 
      // But we don't have easy access to List<Attendance> from here without a Repo call or new Service method.
      // Let's modify PdfService to accept List<Map<String, dynamic>> for history to be simpler and reuse existing service methods.
      // Refactoring PdfService signature in next tool call.
      
      // WAIT. I can just fetch the raw history if I had the AttendanceRepo.
      // BUT `StatisticsService` encapsulates that.
      // Better approach: Let's assume for now I will modify PdfService to take the List<Map> from getMemberHistory.
      // It serves the same purpose.
      
      final historyMap = await statsService.getMemberHistory(member.id!);
      
      // Generate
      final pdfService = getIt<PdfService>();
      final file = await pdfService.generateMemberDossier(member, stats, historyMap);
      
      if (context.mounted) {
         Share.shareXFiles([XFile(file.path)], text: 'Reporte de ${member.firstName} ${member.lastName}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar reporte: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildHeader(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getIt<StatisticsService>().getMemberStats(member.id!),
      builder: (context, snapshot) {
        // Default to grey if loading
        Color ringColor = Colors.grey;
        int extraCount = 0; 
        double percentage = 0.0;

        if (snapshot.hasData) {
          final stats = snapshot.data!;
          percentage = stats['percentage'] as double;
          final status = stats['status'] as String? ?? 'ACTIVE';
          extraCount = stats['extraCount'] as int? ?? 0;

          if (member.status == MemberStatus.suspended) {
             ringColor = Colors.red;
          } else if (member.status == MemberStatus.inactive) {
             ringColor = Colors.grey;
          } else if (status == 'NEUTRAL') {
             ringColor = Colors.grey; 
          } else if (percentage < 50) {
             ringColor = Colors.red;
          } else {
             ringColor = Colors.green;
          }
        } else if (member.status == MemberStatus.active) {
            ringColor = Colors.green;
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4), 
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: 3),
              ),
              child: CircleAvatar(
                radius: 50, 
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
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              member.role.label.toUpperCase(),
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
            ),
             if (percentage >= 100) ...[
                const SizedBox(height: 8),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                   decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                   ),
                   child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Icon(Icons.local_fire_department_rounded, size: 16, color: Colors.amber.shade800),
                         const SizedBox(width: 4),
                         Text('Persistencia Perfecta', style: TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900
                         )),
                      ],
                   ),
                ),
             ] else if (extraCount > 0) ...[
                const SizedBox(height: 8),
                Container(
                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                   decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                   ),
                   child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                         Icon(Icons.star_rate_rounded, size: 14, color: Colors.amber.shade800),
                         const SizedBox(width: 4),
                         Text('+$extraCount Extras', style: TextStyle(
                            fontSize: 12, 
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900
                         )),
                      ],
                   ),
                ),
             ],
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
                  onPressed: () {}, 
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
                   color: Theme.of(context).brightness == Brightness.dark 
                       ? const Color(0xFFEEEEEE) 
                       : const Color(0xFF616161),
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

         final now = DateTime.now();
         final futureEvents = history.where((e) => (e['date'] as DateTime).isAfter(now)).toList();
         final pastEvents = history.where((e) => (e['date'] as DateTime).isBefore(now) || (e['date'] as DateTime).isAtSameMomentAs(now)).toList();
         
         futureEvents.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
         pastEvents.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

         return Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             if (futureEvents.isNotEmpty) ...[
                Text('Próximos Eventos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: futureEvents.length,
                  itemBuilder: (context, index) {
                    final item = futureEvents[index];
                    final date = item['date'] as DateTime;
                    return ListTile(
                      leading: const Icon(Icons.access_time_rounded, color: Colors.grey),
                      title: Text(DateFormat('EEEE d MMM, y', 'es').format(date)),
                      subtitle: Text(item['description'] ?? 'Evento'),
                      trailing: const Text('Pendiente', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                    );
                  },
                ),
                const SizedBox(height: 24),
             ],

             Text('Historial Reciente', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[700])),
             const SizedBox(height: 12),
             if (pastEvents.isEmpty)
               const Text('No hay historial pasado.'),
             ListView.builder(
               shrinkWrap: true,
               physics: const NeverScrollableScrollPhysics(),
               itemCount: pastEvents.length,
               itemBuilder: (context, index) {
                 final item = pastEvents[index];
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
