import 'dart:io';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../features/members/domain/entities/member.dart';
import '../utils/enum_extensions.dart'; // For role label

@lazySingleton
class PdfService {
  Future<File> generateMemberDossier(
    Member member,
    Map<String, dynamic> stats,
    List<Map<String, dynamic>> history,
  ) async {
    final pdf = pw.Document();
    
    // Extract Stats
    final percentage = stats['percentage'] as double? ?? 0.0;
    final extraCount = stats['extraCount'] as int? ?? 0;
    final status = stats['status'] as String? ?? 'ACTIVE';

    final now = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy', 'es');
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(member.firstName, 'REPORTE OFICIAL - REDIL', dateFormat.format(now)),
            pw.SizedBox(height: 20),
            _buildProfileSection(member, status),
            pw.SizedBox(height: 20),
            _buildStatsSection(percentage, extraCount),
            pw.SizedBox(height: 20),
            _buildHistoryTable(history, member.id!, dateFormat),
            pw.SizedBox(height: 20),
            _buildFooter(),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/reporte_${member.firstName}_${member.lastName}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<File> generateBattalionReport(
    List<Member> members,
    Map<String, Map<String, dynamic>> allStats,
  ) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'es');

    // Sort by Percentage Descending (using mutable copy)
    final List<Member> sortedMembers = List.from(members);
    sortedMembers.sort((a, b) {
       final statsA = allStats[a.id] ?? {};
       final statsB = allStats[b.id] ?? {};
       final percentA = statsA['percentage'] as double? ?? 0.0;
       final percentB = statsB['percentage'] as double? ?? 0.0;
       return percentB.compareTo(percentA);
    });

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.landscape,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
             _buildHeader('ESTADO DE FUERZA', 'REDIL - REPORTE GENERAL', dateFormat.format(now)),
             pw.SizedBox(height: 20),
             _buildBattalionTable(sortedMembers, allStats),
             pw.SizedBox(height: 20),
             _buildFooter(),
          ];
        }
      )
    );

     final output = await getTemporaryDirectory();
    final file = File('${output.path}/estado_fuerza_redil.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _buildHeader(String title, String subtitle, String date) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(subtitle, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900)),
            pw.Text(title, style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Generado: $date', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text('CONFIDENCIAL', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
            ),
          ],
        )
      ],
    );
  }

  pw.Widget _buildBattalionTable(List<Member> members, Map<String, Map<String, dynamic>> allStats) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey100),
          children: [
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Nombre', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Rol', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('% Asistencia', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Extras', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
            pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('Estado', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
          ],
        ),
        // Rows
        ...members.map((member) {
           final stats = allStats[member.id] ?? {};
           final percentage = stats['percentage'] as double? ?? 0.0;
           final extraCount = stats['extraCount'] as int? ?? 0;
           final status = stats['status'] as String? ?? 'ACTIVE'; // NEUTRAL or ACTIVE or RISK if implemented
           
           // Determine display status
           String displayStatus = 'ACTIVO';
           PdfColor statusColor = PdfColors.green700;
           
           if (member.status == MemberStatus.suspended) {
             displayStatus = 'SUSPENDIDO';
             statusColor = PdfColors.red700;
           } else if (member.status == MemberStatus.inactive) {
             displayStatus = 'INACTIVO';
              statusColor = PdfColors.grey600;
           } else if (status == 'NEUTRAL') {
             displayStatus = 'NEUTRAL';
             statusColor = PdfColors.grey600;
           } else if (percentage < 50) {
              displayStatus = 'RIESGO';
              statusColor = PdfColors.orange700;
           }

           return pw.TableRow(
             children: [
               pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('${member.firstName} ${member.lastName}')),
               pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(member.role.label)),
               pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text('${percentage.toStringAsFixed(1)}%')),
               pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(extraCount > 0 ? '+$extraCount' : '-')),
               pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(displayStatus, style: pw.TextStyle(color: statusColor, fontWeight: pw.FontWeight.bold))),
             ],
           );
        }),
      ],
    );
  }

  pw.Widget _buildProfileSection(Member member, String status) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Row(
        children: [
          pw.Container(
            width: 50,
            height: 50,
            decoration: const pw.BoxDecoration(
              color: PdfColors.grey200,
              shape: pw.BoxShape.circle,
            ),
            child: pw.Center(
               child: pw.Text(member.firstName.substring(0, 1).toUpperCase(), style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
          ),
          pw.SizedBox(width: 16),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('${member.firstName} ${member.lastName}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(member.role.label.toUpperCase(), style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
              pw.Text('Tel: ${member.phone}', style: const pw.TextStyle(fontSize: 12)),
            ],
          ),
          pw.Spacer(),
           pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('Estado', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
              pw.Text(status, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: status == 'ACTIVE' ? PdfColors.green700 : PdfColors.red700)),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildStatsSection(double percentage, int extraCount) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Container(
             padding: const pw.EdgeInsets.all(12),
             color: PdfColors.blue50,
             child: pw.Column(
               children: [
                 pw.Text('${percentage.toStringAsFixed(1)}%', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                 pw.Text('Asistencia (Estricta)', style: const pw.TextStyle(fontSize: 10)),
               ],
             )
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Expanded(
          child: pw.Container(
             padding: const pw.EdgeInsets.all(12),
             color: PdfColors.amber50,
             child: pw.Column(
               children: [
                 pw.Text('+$extraCount', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.amber800)),
                 pw.Text('Eventos Extras', style: const pw.TextStyle(fontSize: 10)),
               ],
             )
          ),
        ),
      ],
    );
  }

  pw.Widget _buildHistoryTable(List<Map<String, dynamic>> history, String memberId, DateFormat dateFormat) {
    final recent = history.take(10).toList();

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Historial Reciente (Últimos 10)', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Fecha', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Evento', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text('Asistencia', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              ],
            ),
            // Rows
            ...recent.map((event) {
               final date = event['date'] as DateTime;
               final description = event['description'] as String? ?? 'Evento';
               final attended = event['attended'] as bool;
               
               return pw.TableRow(
                 children: [
                   pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(dateFormat.format(date))),
                   pw.Padding(padding: const pw.EdgeInsets.all(4), child: pw.Text(description)),
                   pw.Padding(
                     padding: const pw.EdgeInsets.all(4), 
                     child: pw.Text(
                       attended ? 'ASISTIÓ' : 'FALTA', 
                       style: pw.TextStyle(color: attended ? PdfColors.green700 : PdfColors.red700, fontWeight: pw.FontWeight.bold)
                     )
                   ),
                 ],
               );
            }),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildFooter() {
     return pw.Column(
       children: [
         pw.Divider(color: PdfColors.grey300),
         pw.SizedBox(height: 4),
         pw.Row(
           mainAxisAlignment: pw.MainAxisAlignment.center,
           children: [
             pw.Text('Generado por Redil App', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
           ],
         ),
       ]
     );
  }
}
