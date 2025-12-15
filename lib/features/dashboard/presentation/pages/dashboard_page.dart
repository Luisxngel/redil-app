import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../../members/domain/entities/member.dart'; 
import '../../../members/domain/entities/member_risk.dart'; 
import '../../../../core/services/statistics_service.dart'; // NEW
import '../../../members/domain/repositories/member_repository.dart'; // NEW for Actions
import '../widgets/dashboard_calendar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardBloc>()..add(const DashboardEvent.loadDashboardData()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  // STEP 1: STATE MANAGEMENT
  bool _isMulticolor = true;

  // --- APPEARANCE MODAL ---
  void _showAppearanceModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (modalContext) {
        // Use StatefulBuilder if we want the switch to animate immediately inside the modal 
        // while also updating the parent state.
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Apariencia', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const Divider(),
                SwitchListTile(
                  title: const Text('Tablero Multicolor'),
                  subtitle: const Text('Usar colores semánticos en tarjetas'),
                  value: _isMulticolor,
                  secondary: const Icon(Icons.color_lens_outlined),
                  onChanged: (val) {
                    setStateModal(() => _isMulticolor = val); // Update local modal state
                    setState(() => _isMulticolor = val); // Update main screen state
                  },
                ),
                ListTile(
                  title: const Text('Tema de la Aplicación'),
                  subtitle: const Text('Cambiar el color global del Redil'),
                  leading: const Icon(Icons.format_paint_outlined),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Close modal first? User instruction says "Trigger logic".
                    // Generally better to close sheet then open dialog to avoid stacking issues.
                    Navigator.pop(context); 
                    _showThemeDialog(context);
                  },
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        );
      },
    );
  }

  // --- MODAL ACTIONS ---

  void _showAttendeesModal(BuildContext context, List<Member> attendees) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return _buildListModal(
          context: context, 
          title: 'Asistentes Recientes',
          emptyMessage: 'No hubo asistentes registrados.', 
          itemBuilder: (context, index) {
            final member = attendees[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text((member.firstName ?? '-')[0], style: TextStyle(color: Theme.of(context).colorScheme.primary)),
              ),
              title: Text('${member.firstName ?? 'Sin Nombre'} ${member.lastName ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(member.role.name.toUpperCase(), style: const TextStyle(fontSize: 10)),
              onTap: () => _showMemberDetail(context, member),
            );
          },
          itemCount: attendees.length,
        );
      },
    );
  }

  void _showRiskModal(BuildContext context, List<MemberRisk> riskList) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder( // Use StatefulBuilder to allow local list removal
          builder: (context, setStateModal) {
            final currentList = riskList;

            return _buildListModal(
              context: context,
              title: 'Por Pastorear (Riesgo)',
              emptyMessage: '¡Excelente! Nadie faltó recientemente.',
              itemBuilder: (context, index) {
                final risk = currentList[index];
                final member = risk.member;
                
                // Calculate Days Absent (Approximate logic based on absences for now, 
                // ideally show last attendance date interval)
                // Let's just say "X ausencias consecutivas" is the key metric.
                
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  elevation: 0,
                  color: Colors.red[50], // Light red background for urgency
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red[100]!),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Text((member.firstName ?? '-')[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${member.firstName ?? 'Sin Nombre'} ${member.lastName ?? ''}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Text(
                                    '${risk.consecutiveAbsences} cultos consecutivos (aprox. ${risk.consecutiveAbsences * 7} días)',
                                    style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        // ACITONS ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // 1. WhatsApp
                            IconButton.filled(
                              style: IconButton.styleFrom(backgroundColor: Colors.green[100]),
                              icon: const Icon(Icons.chat_bubble_outline, color: Colors.green),
                              tooltip: 'WhatsApp',
                              onPressed: () async {
                                final phone = member.phone?.replaceAll(RegExp(r'\D'), '') ?? '';
                                if (phone.isNotEmpty) {
                                  final url = Uri.parse('https://wa.me/$phone');
                                  if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sin teléfono registrado')));
                                }
                              },
                            ),
                            // 2. Call
                            IconButton.filled(
                              style: IconButton.styleFrom(backgroundColor: Colors.blue[100]),
                              icon: const Icon(Icons.phone_outlined, color: Colors.blue),
                              tooltip: 'Llamar',
                              onPressed: () async {
                                final phone = member.phone?.replaceAll(RegExp(r'\D'), '') ?? '';
                                if (phone.isNotEmpty) {
                                  final url = Uri.parse('tel:$phone');
                                  if (await canLaunchUrl(url)) await launchUrl(url);
                                }
                              },
                            ),
                            // 3. Mark as Contacted (Dismiss)
                            IconButton.filled(
                              style: IconButton.styleFrom(backgroundColor: Colors.grey[200]),
                              icon: const Icon(Icons.check, color: Colors.black87),
                              tooltip: 'Ya contacté / Descartar por 7 días',
                              onPressed: () async {
                                // Logic: Update lastContacted = Now
                                final updated = member.copyWith(lastContacted: DateTime.now());
                                await getIt<MemberRepository>().saveMember(updated);
                                
                                if (context.mounted) {
                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marcado como contactado. Desaparecerá por 7 días.')));
                                   // Refresh Dashboard
                                   context.read<DashboardBloc>().add(const DashboardEvent.loadDashboardData());
                                   // Remove locally
                                    setStateModal(() {
                                      currentList.removeAt(index);
                                    });
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: currentList.length,
            );
          }
        );
      },
    );
  }

  void _showHarvestModal(BuildContext context, List<Member> harvestMembers) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            final currentList = harvestMembers; 
            // Note: Since we are not re-fetching from repository in real-time, 
            // we manage the list visually via local state changes or just closing the modal.
            // But since 'currentList' comes from the parent Bloc state, we can't easily modify it locally without a new fetch.
            // Better UX: Perform action, show success, then trigger main refresh.
            
            return _buildListModal(
              context: context,
              title: 'Nuevos en la Familia',
              emptyMessage: 'Sin nuevos ingresos pendientes de revisar.',
              headerAction: currentList.isNotEmpty ? TextButton.icon(
                label: const Text('Limpiar Todo'),
                icon: const Icon(Icons.cleaning_services_rounded),
                onPressed: () async {
                  final repo = getIt<MemberRepository>();
                  int count = 0;
                  // Batch update
                  for (final m in currentList) {
                    final updated = m.copyWith(isHarvested: true);
                    final result = await repo.saveMember(updated);
                   if (result.isRight()) count++;
                  }
                  
                  if (context.mounted) {
                    Navigator.pop(context); // Close modal
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Se archivaron $count miembros de la Cosecha.')));
                    // Reload Dashboard
                    context.read<DashboardBloc>().add(const DashboardEvent.loadDashboardData());
                  }
                },
              ) : null,
              itemBuilder: (context, index) {
                final member = currentList[index];
                final dateStr = DateFormat('d MMM yyyy', 'es').format(member.createdAt);
                return ListTile(
                  leading: const Icon(Icons.spa, color: Colors.green),
                  title: Text('${member.firstName} ${member.lastName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Miembro desde: $dateStr'),
                  onTap: () => _showMemberDetail(context, member),
                  trailing: IconButton(
                    icon: const Icon(Icons.check_circle_outline),
                    tooltip: 'Archivar / Ya saludé',
                    onPressed: () async {
                      final updated = member.copyWith(isHarvested: true);
                      final result = await getIt<MemberRepository>().saveMember(updated);
                      result.fold(
                        (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${l.message}'))), 
                        (r) {
                           // Remove from local list visually? 
                           // Simplest: Refresh parent dashboard which rebuilds this list (but might not rebuild internal modal state without work).
                           // Best MPV: Close modal or just trigger refresh and let user see it disappear if they reopen.
                           // Actually, let's trigger reload.
                           context.read<DashboardBloc>().add(const DashboardEvent.loadDashboardData());
                           
                           // Remove visually from this modal instance if possible?
                           setStateModal(() {
                             currentList.removeAt(index);
                           });
                        }
                      );
                    },
                  ),
                );
              },
              itemCount: currentList.length,
            );
          }
        );
      },
    );
  }

  Widget _buildListModal({
    required BuildContext context,
    required String title,
    required String emptyMessage,
    required Widget Function(BuildContext, int) itemBuilder,
    required int itemCount,
    Widget? headerAction, // NEW
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
               if (headerAction != null) headerAction,
            ],
          ),
          const SizedBox(height: 16),
          if (itemCount == 0)
            Center(child: Padding(padding: const EdgeInsets.all(24.0), child: Text(emptyMessage, style: const TextStyle(color: Colors.grey))))
          else
            Expanded(
              child: ListView.separated(
                itemCount: itemCount,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: itemBuilder,
              ),
            ),
        ],
      ),
    );
  }

  // --- MEMBER DETAIL MODAL ---
  void _showMemberDetail(BuildContext context, Member member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height if needed
      showDragHandle: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => _MemberDetailContent(member: member, controller: controller),
      ),
    );
  }

  // --- BIBLE LAUNCHER ---
  Future<void> _launchBible(BuildContext context) async {
    const String androidPackage = 'com.sirma.mobile.bible.android';
    const String iosScheme = 'youversion://';
    const String webUrl = 'https://www.bible.com/es';

    try {
      final bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
      final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

      Uri? appUri;
      if (isAndroid) {
        appUri = Uri.parse('youversion://');
      } else if (isIOS) {
        appUri = Uri.parse(iosScheme);
      }

      if (appUri != null) {
        if (await canLaunchUrl(appUri)) {
          await launchUrl(appUri, mode: LaunchMode.externalApplication);
          return;
        }
      }

      final Uri fallback = Uri.parse(webUrl);
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    } catch (_) {
      final Uri fallback = Uri.parse(webUrl);
      await launchUrl(fallback, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // STEP 2: DEFINE SEMANTIC PALETTE
    final Color colorHeart = _isMulticolor ? Colors.redAccent : theme.colorScheme.primary;
    final Color colorShepherd = _isMulticolor ? Colors.orange : theme.colorScheme.primary;
    final Color colorHarvest = _isMulticolor ? Colors.green : theme.colorScheme.primary;
    final Color colorMembers = _isMulticolor ? Colors.purple : theme.colorScheme.primary;
    final Color colorEvents = _isMulticolor ? Colors.blue : theme.colorScheme.primary;
    final Color colorBible = _isMulticolor ? const Color(0xFF795548) : theme.colorScheme.primary; // Brown/Teal

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text('Redil Dashboard'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _showNotificationSheet(context, state),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'appearance') {
                    _showAppearanceModal(context);
                  } else if (value == 'trash') {
                    context.push('/trash').then((_) {
                      if (context.mounted) {
                        context.read<DashboardBloc>().add(const DashboardEvent.loadDashboardData());
                      }
                    });
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'appearance',
                    child: ListTile(
                      leading: Icon(Icons.palette_outlined),
                      title: Text('Personalizar'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'trash',
                    child: ListTile(
                      leading: Icon(Icons.delete_outline, color: Colors.red),
                      title: Text('Papelera', style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (activeCount, avgAttendance, lastEventAttendance, lastAttendees, harvestCount, harvestMembers, birthdayMembers, riskMembers) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER: Clean Welcome
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenido, Pastor',
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Resumen Ministerial',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // CALENDAR
                    const DashboardCalendar(),
                    const SizedBox(height: 24),

                    // MINISTERIAL GRID (3x2)
                    MinisterialGrid(
                      // DATA ROW 1
                      lastEventCount: lastEventAttendance,
                      riskCount: riskMembers.length,
                      harvestCount: harvestCount,
                      // COLORS
                      colorHeart: colorHeart,
                      colorShepherd: colorShepherd,
                      colorHarvest: colorHarvest,
                      colorMembers: colorMembers,
                      colorEvents: colorEvents,
                      colorBible: colorBible,
                      isMulticolor: _isMulticolor,
                      // ACTIONS ROW 1 (Modals)
                      onTapHeart: () => _showAttendeesModal(context, lastAttendees),
                      onTapShepherd: () => _showRiskModal(context, riskMembers),
                      onTapHarvest: () => _showHarvestModal(context, harvestMembers),
                      // ACTIONS ROW 2 (Nav)
                      onTapMembers: () => context.push('/members'),
                      onTapEvents: () => context.push('/attendance'),
                      onTapBible: () => _launchBible(context),
                    ),
                    
                    const SizedBox(height: 24),

                    // BIRTHDAYS (Still requested to keep)
                    if (birthdayMembers.isNotEmpty) ...[
                      Text('Cumpleaños Próximos', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _BirthdayCard(members: birthdayMembers),
                      const SizedBox(height: 24),
                    ],

                    const SizedBox(height: 48),
                  ],
                ),
              );
            },
            error: (msg) => Center(child: Text('Error: $msg', style: const TextStyle(color: Colors.red))),
            orElse: () => const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cambiar Tema'),
          content: SingleChildScrollView(
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 _ThemeOption(color: const Color(0xFF00897B), label: 'Teal', candidate: AppThemeCandidate.teal),
                 _ThemeOption(color: const Color(0xFF1565C0), label: 'Blue', candidate: AppThemeCandidate.blue),
                 _ThemeOption(color: const Color(0xFF6A1B9A), label: 'Purple', candidate: AppThemeCandidate.purple),
                 _ThemeOption(color: Colors.black, label: 'Dark', candidate: AppThemeCandidate.dark),
               ],
            ),
          ),
        );
      },
    );
  }
}

class _MemberDetailContent extends StatelessWidget {
  final Member member;
  final ScrollController controller;

  const _MemberDetailContent({required this.member, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        // Get Stats (Percentage)
        getIt<StatisticsService>().getMemberStats(member.id ?? ''),
        // Get History (Full)
        getIt<StatisticsService>().getMemberHistory(member.id ?? ''),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        
        final stats = snapshot.data![0] as Map<String, dynamic>;
        final history = snapshot.data![1] as List<Map<String, dynamic>>;
        
        final double percentage = stats['percentage'] as double;
        final bool isPerfect = percentage >= 100.0;
        
        // STEP 1: PREPARE DATA
        final now = DateTime.now();
        final futureEvents = history.where((e) => (e['date'] as DateTime).isAfter(now)).toList();
        final pastEvents = history.where((e) => (e['date'] as DateTime).isBefore(now) || (e['date'] as DateTime).isAtSameMomentAs(now)).toList();
        
        // Sort: Future ASC (closest first), Past DESC (newest first)
        futureEvents.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime)); 
        pastEvents.sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime)); 

        return Column(
          children: [
            const SizedBox(height: 8),
            
            // Header: Avatar + Name + Percentage
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                   CircleAvatar(
                     radius: 30,
                     backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                     child: Text((member.firstName ?? '-')[0], style: const TextStyle(fontSize: 24)),
                   ),
                   const SizedBox(width: 16),
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text('${member.firstName ?? 'Sin Nombre'} ${member.lastName ?? ''}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                         Text(member.role.name.toUpperCase(), style: Theme.of(context).textTheme.bodySmall),
                       ],
                     ),
                   ),
                   // Percentage Indicator + Badge
                   Column(
                     children: [
                       Stack(
                         alignment: Alignment.center,
                         children: [
                           CircularProgressIndicator(
                             value: percentage / 100,
                             backgroundColor: Colors.grey[200],
                             color: isPerfect ? Colors.amber : (percentage < 50 ? Colors.red : Colors.green),
                             strokeWidth: 6,
                           ),
                           Text('${percentage.toInt()}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                         ],
                       ),
                       if (isPerfect) ...[
                         const SizedBox(height: 4),
                         const Icon(Icons.local_fire_department_rounded, color: Colors.amber, size: 24),
                         Text('Persistencia', style: TextStyle(fontSize: 9, color: Colors.amber[800], fontWeight: FontWeight.bold)),
                       ]
                     ],
                   ),
                ],
              ),
            ),
            const Divider(),
            
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(16.0),
                children: [
                  // SECTION A: Próximos Eventos
                  if (futureEvents.isNotEmpty) ...[
                    Text('Próximos Eventos', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 8),
                    ...futureEvents.map((event) {
                      final dateStr = DateFormat('EEE d MMM', 'es').format(event['date'] as DateTime);
                      return ListTile(
                        leading: const Icon(Icons.access_time_rounded, color: Colors.grey),
                        title: Text('${event['description']}'),
                        subtitle: Text(dateStr),
                        trailing: const Text('Pendiente', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12)),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                    const SizedBox(height: 24),
                  ],
                  
                  // SECTION B: Historial Pasado (Reciente)
                  const Text('Historial Reciente', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  if (pastEvents.isEmpty)
                    const Padding(padding: EdgeInsets.all(16.0), child: Text('No hay historial disponible.'))
                  else
                    ...pastEvents.map((event) {
                      final dateStr = DateFormat('EEE d MMM', 'es').format(event['date'] as DateTime);
                      final attended = event['attended'] as bool;
                      return ListTile(
                        leading: attended 
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Opción de Justificar pronto...')),
                                );
                              },
                              child: const Icon(Icons.cancel, color: Colors.red),
                            ),
                        title: Text('${event['description']}'),
                        subtitle: Text(dateStr),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class MinisterialGrid extends StatelessWidget {
  final int lastEventCount;
  final int riskCount;
  final int harvestCount;
  
  final Color colorHeart;
  final Color colorShepherd;
  final Color colorHarvest;
  final Color colorMembers;
  final Color colorEvents;
  final Color colorBible;
  
  final bool isMulticolor;
  
  final VoidCallback onTapHeart;
  final VoidCallback onTapShepherd;
  final VoidCallback onTapHarvest;
  final VoidCallback onTapMembers;
  final VoidCallback onTapEvents;
  final VoidCallback onTapBible;

  const MinisterialGrid({
    super.key,
    required this.lastEventCount,
    required this.riskCount,
    required this.harvestCount,
    required this.colorHeart,
    required this.colorShepherd,
    required this.colorHarvest,
    required this.colorMembers,
    required this.colorEvents,
    required this.colorBible,
    required this.isMulticolor,
    required this.onTapHeart,
    required this.onTapShepherd,
    required this.onTapHarvest,
    required this.onTapMembers,
    required this.onTapEvents,
    required this.onTapBible,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ROW 1: Intelligence (Modals)
        Row(
          children: [
            Expanded(
              child: _PastoralCard(
                icon: Icons.favorite_rounded,
                value: lastEventCount.toString(),
                label: 'Último Encuentro',
                color: colorHeart,
                isMulticolor: isMulticolor,
                onTap: onTapHeart,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PastoralCard(
                icon: Icons.volunteer_activism,
                value: riskCount.toString(),
                label: 'Por Pastorear',
                color: colorShepherd,
                isMulticolor: isMulticolor,
                onTap: onTapShepherd,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PastoralCard(
                icon: Icons.spa_rounded,
                value: harvestCount.toString(), // Simplified logic, removed checkmark for grid cleaness
                label: 'La Cosecha',
                color: colorHarvest,
                isMulticolor: isMulticolor,
                onTap: onTapHarvest,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // ROW 2: Logistics (Navigation)
        Row(
          children: [
            Expanded(
              child: _PastoralCard(
                icon: Icons.groups_rounded,
                value: null,
                label: 'Miembros',
                color: colorMembers,
                isMulticolor: isMulticolor,
                onTap: onTapMembers,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PastoralCard(
                icon: Icons.calendar_month_rounded,
                value: null,
                label: 'Eventos',
                color: colorEvents,
                isMulticolor: isMulticolor,
                onTap: onTapEvents,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PastoralCard(
                icon: Icons.menu_book_rounded,
                value: null,
                label: 'Biblia',
                color: colorBible,
                isMulticolor: isMulticolor,
                onTap: onTapBible,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// STEP 3: REFACTOR UI CARDS
class _PastoralCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color color;
  final bool isMulticolor;
  final VoidCallback onTap;

  const _PastoralCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isMulticolor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Design: White background if multicolor, else theme surface variant
    final bgColor = isMulticolor ? Colors.white : theme.colorScheme.surfaceVariant.withOpacity(0.5);
    final borderColor = isMulticolor ? Colors.transparent : theme.colorScheme.outlineVariant.withOpacity(0.5);
    // Shadow only if white background to make it pop
    final List<BoxShadow>? shadows = isMulticolor 
       ? [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))]
       : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 110, // Fixed height for uniformity
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: shadows,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            if (value != null) ...[
              Text(
                value!,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final Color color;
  final String label;
  final AppThemeCandidate candidate;

  const _ThemeOption({required this.color, required this.label, required this.candidate});

  @override
  Widget build(BuildContext context) {
    final isSelected = context.read<ThemeCubit>().state == candidate;
    return GestureDetector(
      onTap: () {
        context.read<ThemeCubit>().changeTheme(candidate);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.orange, width: 3) : null,
            ),
            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

class _BirthdayCard extends StatelessWidget {
  final List<Member> members;

  const _BirthdayCard({required this.members});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: members.map((member) {
             final dob = member.dateOfBirth;
             final dateStr = dob != null ? DateFormat('d MMM', 'es').format(dob) : '';
             return ListTile(
               leading: CircleAvatar(
                 backgroundColor: Colors.pink[50],
                 child: const Icon(Icons.cake, color: Colors.pink, size: 20),
               ),
               title: Text('${member.firstName ?? 'Sin Nombre'} ${member.lastName ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold)),
               subtitle: Text(dateStr),
               contentPadding: EdgeInsets.zero,
               visualDensity: VisualDensity.compact,
             );
          }).toList(),
        ),
      ),
    );
  }
}

void _showNotificationSheet(BuildContext context, DashboardState state) {
  state.maybeWhen(
    loaded: (_, __, ___, ____, _____, ______, birthdayMembers, riskMembers) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notificaciones', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                if (riskMembers.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                    title: const Text('Atención Necesaria'),
                    subtitle: Text('${riskMembers.length} ovejas necesitan visita pastoral.'),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate if needed
                    },
                  ),
                if (birthdayMembers.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.cake, color: Colors.pink),
                    title: const Text('Cumpleaños'),
                    subtitle: Text('Hay ${birthdayMembers.length} cumpleaños esta semana.'),
                     onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                if (riskMembers.isEmpty && birthdayMembers.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("No hay notificaciones nuevas."),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      );
    },
    orElse: () {},
  );
}
