import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/domain/entities/member_risk.dart'; // NEW
import '../../../members/presentation/widgets/whatsapp_message_dialog.dart';
import '../widgets/dashboard_calendar.dart'; // NEW

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

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // 1. Scaffold Background: Off-white
      appBar: AppBar(
        title: const Text('Redil Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notificaciones',
            onPressed: () {
              final state = context.read<DashboardBloc>().state;
              state.maybeWhen(
                loaded: (_, __, birthdays, ___) {
                  if (birthdays.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🔔 Tienes ${birthdays.length} cumpleaños esta semana. ¡Revisa el radar!'),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sin notificaciones nuevas')),
                    );
                  }
                },
                orElse: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sin notificaciones nuevas')),
                  );
                },
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'theme') {
                _showThemeDialog(context);
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
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (activeCount, avgAttendance, birthdays, riskMembers) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 0. Calendar (NEW)
                    const DashboardCalendar(),
                    const SizedBox(height: 24),

                    // 1. Resumen Operativo (KPIS)
                    _buildSummaryGrid(context, activeCount, avgAttendance),
                    const SizedBox(height: 24),

                    // 2. Accesos Rápidos
                    const Text('Accesos Rápidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),

                    // 3. Cumpleaños
                    if (birthdays.isNotEmpty) ...[
                      const Text('Cumpleaños próximos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _buildBirthdayRadar(context, birthdays),
                      const SizedBox(height: 24),
                    ],

                    // 4. Alerta de Riesgo (Atención Necesaria)
                    if (riskMembers.isNotEmpty) ...[
                      _buildAttritionList(context, riskMembers),
                    ],

                    if (birthdays.isEmpty && riskMembers.isEmpty)
                      const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Todo tranquilo por aquí.", style: TextStyle(color: Colors.grey)),
                      )),
                  ],
                ),
              );
            },
            error: (msg) => Center(child: Text('Error: $msg', style: const TextStyle(color: Colors.red))),
            orElse: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Widget _buildSummaryGrid(BuildContext context, int activeCount, double avgAttendance) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Miembros Activos',
            value: activeCount.toString(),
            icon: Icons.people,
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Asistencia Prom.',
            value: avgAttendance.toStringAsFixed(1),
            icon: Icons.analytics,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickActionButton(
          label: 'Miembros',
          icon: Icons.people_alt_outlined,
          onTap: () => context.push('/members'),
        ),
        _QuickActionButton(
          label: 'Asistencia',
          icon: Icons.calendar_month_outlined,
          onTap: () => context.push('/attendance'),
        ),
        _QuickActionButton(
          label: 'Biblia',
          icon: Icons.menu_book,
          onTap: () async {
            final Uri url = Uri.parse('https://www.biblegateway.com/');
            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
              if (context.mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('No se pudo abrir $url')),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildBirthdayRadar(BuildContext context, List<Member> members) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          final dob = member.dateOfBirth!;
          final dateStr = DateFormat('d MMM', 'es').format(dob);

          return Card(
            margin: const EdgeInsets.only(right: 12),
            elevation: 0, // Flat style for radar? Or keep elevation. User said "horizontal cards". Default Card is fine.
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Icon(Icons.cake, color: Colors.pink[400], size: 20), // 4. Icons in Pink
                       const SizedBox(width: 8),
                       Text(dateStr, style: const TextStyle(fontWeight: FontWeight.bold)),
                     ],
                   ),
                   const SizedBox(height: 4),
                   Text(
                     '${member.firstName} ${member.lastName}',
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                     textAlign: TextAlign.center,
                   ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttritionList(BuildContext context, List<MemberRisk> riskItems) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800),
                const SizedBox(width: 8),
                Text(
                  'Atención necesaria (${riskItems.length})', 
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: riskItems.length,
            itemBuilder: (context, index) {
              final item = riskItems[index];
              final member = item.member;
              final absences = item.consecutiveAbsences;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    member.firstName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text('${member.firstName} ${member.lastName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Ausente ($absences)', style: const TextStyle(color: Colors.grey)),
                trailing: IconButton(
                  icon: const Icon(Icons.message_rounded, color: Colors.green), // 5. Modern Message Icon
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => WhatsAppMessageDialog(member: member),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
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
                  label: 'Teal',
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
                  label: 'Violeta',
                  isSelected: context.read<ThemeCubit>().state == AppThemeCandidate.purple,
                  onTap: () {
                    context.read<ThemeCubit>().changeTheme(AppThemeCandidate.purple);
                    Navigator.pop(context);
                  },
                ),
                _ThemeCircle(
                  color: Colors.black,
                  label: 'Dark',
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
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Soft shadow
      color: Colors.white,
      shadowColor: Colors.black12, // Softer shadow color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100, // Slightly wider for better touch area
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
             BoxShadow(
               color: Colors.grey.withOpacity(0.1),
               blurRadius: 5,
               offset: const Offset(0, 2),
             )
           ], 
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
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
