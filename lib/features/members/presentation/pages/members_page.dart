import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../domain/entities/member.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../../core/services/statistics_service.dart';
import '../../../../core/utils/enum_extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../bloc/members_bloc.dart';
import '../bloc/members_event.dart';
import '../bloc/members_state.dart';
import '../widgets/member_tile.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  @override
  void initState() {
    super.initState();
    context.read<MembersBloc>().add(const MembersEvent.loadMembers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discípulos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotificationSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Imprimir Reporte General',
            onPressed: () => _onPrintBattalionReport(context),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'theme') {
                _showThemeDialog(context);
              } else if (value == 'trash') {
                context.push('/trash').then((_) {
                  if (context.mounted) {
                    context.read<MembersBloc>().add(const MembersEvent.loadMembers());
                  }
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'theme',
                child: ListTile(
                  leading: Icon(Icons.palette_outlined),
                  title: Text('Cambiar Tema'),
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
      body: BlocConsumer<MembersBloc, MembersState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red),
              );
            },
            actionSuccess: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.green),
              );
              // Refresh or Reset state logic if needed, but the Stream in Bloc should auto-refresh list
              // Since ActionSuccess replaces Loaded state in the Bloc logic we used, 
              // we need to re-trigger Load or let the stream listener eventually win.
              // However, since we manually emitted, the stream subscription is still active inside on<LoadMembers>.
              // The issue is: Does the UI stay on ActionSuccess? Yes.
              // So we must reload.
               context.read<MembersBloc>().add(const MembersEvent.loadMembers());
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (members) {
              if (members.isEmpty) {
                return const Center(child: Text('No hay miembros registrados'));
              }
              // Group members by Role
              final Map<MemberRole, List<Member>> groupedMembers = {};
              for (var member in members) {
                if (!groupedMembers.containsKey(member.role)) {
                  groupedMembers[member.role] = [];
                }
                groupedMembers[member.role]!.add(member);
              }

              // Sort roles by priority (Enum index: Leader=0 > Assistant=1 > Member=2 > Guest=3)
              final sortedRoles = groupedMembers.keys.toList()
                ..sort((a, b) => a.index.compareTo(b.index));

              return ListView.builder(
                itemCount: sortedRoles.length,
                itemBuilder: (context, index) {
                  final role = sortedRoles[index];
                  final roleMembers = groupedMembers[role]!;
                  
                  // Sort members alphabetically within the role
                  roleMembers.sort((a, b) => a.firstName.compareTo(b.firstName));
                  
                  final count = roleMembers.length;
                  final isExpandedByDefault = role == MemberRole.leader || role == MemberRole.assistant;

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.1)),
                    ),
                    child: Theme(
                       // Remove divider lines from ExpansionTile
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: isExpandedByDefault,
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.02),
                        collapsedBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        title: Text(
                          '${role.labelPlural.toUpperCase()} ($count)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? const Color(0xFFEEEEEE) 
                                : Colors.grey[800],
                          ),
                        ),
                        children: roleMembers.map((member) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: MemberTile(member: member),
                        )).toList(),
                      ),
                    ),
                  );
                },
              );
            },
            actionSuccess: (_) => const Center(child: CircularProgressIndicator()), // Transient state
            error: (message) => Center(child: Text('Error: $message')),
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add', extra: null).then((_) {
            if (context.mounted) {
              context.read<MembersBloc>().add(const MembersEvent.loadMembers());
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  Future<void> _onPrintBattalionReport(BuildContext context) async {
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Generando Estado de Fuerza...')),
     );

     try {
       // 1. Get Members from Bloc State (or Repo)
       final state = context.read<MembersBloc>().state;
       final members = state.maybeWhen(
         loaded: (m) => m,
         orElse: () => <Member>[],
       );

       if (members.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No hay miembros para reportar')),
          );
          return;
       }

       // 2. Fetch Stats for ALL members
       final statsService = getIt<StatisticsService>();
       final Map<String, Map<String, dynamic>> allStats = {};

       // We could do this in parallel, but for safety in sequence or Future.wait
       // Future.wait might be too heavy if many members, but for < 100 it's fine.
       final futures = members.map((m) async {
          final stats = await statsService.getMemberStats(m.id!);
          return MapEntry(m.id!, stats);
       });
       
       final results = await Future.wait(futures);
       for (var entry in results) {
         allStats[entry.key] = entry.value;
       }

       // 3. Generate PDF
       final pdfService = getIt<PdfService>();
       final file = await pdfService.generateBattalionReport(members, allStats);

       // 4. Share
       if (context.mounted) {
         Share.shareXFiles([XFile(file.path)], text: 'Estado de Fuerza - REDIL');
       }

     } catch (e) {
       if (context.mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
         );
       }
     }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Elige un Tema'),
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ThemeCircle(
                  color: const Color(0xFF00897B),
                  label: 'Turquesa',
                  isSelected: context.read<ThemeCubit>().state == AppThemeCandidate.teal,
                  onTap: () {
                    context.read<ThemeCubit>().changeTheme(AppThemeCandidate.teal);
                    Navigator.pop(context);
                  },
                ),
                _ThemeCircle(
                  color: const Color(0xFF1565C0),
                  label: 'Azul',
                  isSelected: context.read<ThemeCubit>().state == AppThemeCandidate.blue,
                  onTap: () {
                    context.read<ThemeCubit>().changeTheme(AppThemeCandidate.blue);
                    Navigator.pop(context);
                  },
                ),
                _ThemeCircle(
                  color: const Color(0xFF6A1B9A),
                  label: 'Púrpura',
                  isSelected: context.read<ThemeCubit>().state == AppThemeCandidate.purple,
                  onTap: () {
                    context.read<ThemeCubit>().changeTheme(AppThemeCandidate.purple);
                    Navigator.pop(context);
                  },
                ),
                _ThemeCircle(
                  color: Colors.black,
                  label: 'Oscuro',
                  isSelected: context.read<ThemeCubit>().state == AppThemeCandidate.dark,
                  onTap: () {
                    context.read<ThemeCubit>().changeTheme(AppThemeCandidate.dark);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 250, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Notificaciones", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              // The Birthday Item
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.pink[50], shape: BoxShape.circle),
                  child: const Icon(Icons.cake, color: Colors.pink),
                ),
                title: const Text("Cumpleaños", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Hay cumpleaños pendientes esta semana."),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () async {
                  // WHATSAPP LAUNCHER LOGIC
                  final Uri whatsappUrl = Uri.parse("https://wa.me/");
                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No se pudo abrir WhatsApp")),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeCircle extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCircle({
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.orange, width: 3) : null,
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
              ],
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
