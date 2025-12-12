import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../../members/domain/entities/member.dart';
import '../../../members/presentation/widgets/whatsapp_message_dialog.dart';

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
      appBar: AppBar(
        title: const Text('Redil Dashboard'),
        centerTitle: true, 
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
                    // 1. Resumen Operativo
                    _buildSummaryGrid(context, activeCount, avgAttendance),
                    const SizedBox(height: 24),

                    // 2. Accesos Rápidos
                    const Text('Accesos Rápidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildQuickActions(context),
                    const SizedBox(height: 24),

                    // 3. Cumpleaños
                    if (birthdays.isNotEmpty) ...[
                      const Text('🎉 Cumpleaños (Próx. 7 días)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _buildBirthdayRadar(context, birthdays),
                      const SizedBox(height: 24),
                    ],

                    // 4. Alerta de Riesgo
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
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Miembros Activos',
            value: activeCount.toString(),
            icon: Icons.people,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Asistencia Prom.',
            value: avgAttendance.toStringAsFixed(1),
            icon: Icons.analytics,
            color: Colors.green,
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
          icon: Icons.list_alt,
          onTap: () => context.push('/members'),
        ),
        _QuickActionButton(
          label: 'Asistencia',
          icon: Icons.event_note,
          onTap: () => context.push('/attendance'),
        ),
        _QuickActionButton(
          label: 'Papelera',
          icon: Icons.recycling,
          onTap: () => context.push('/trash'),
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
          // format: 12 Oct
          final dateStr = DateFormat('d MMM', 'es').format(dob); 
          
          return Card(
            margin: const EdgeInsets.only(right: 12),
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       const Icon(Icons.cake, color: Colors.pink, size: 20),
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

  Widget _buildAttritionList(BuildContext context, List<Member> members) {
    return Card(
      elevation: 2,
      color: Colors.orange.shade50,
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
                  'Atención Requerida (3 faltas)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    member.firstName.substring(0, 1).toUpperCase(),
                    style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text('${member.firstName} ${member.lastName}'),
                subtitle: const Text('Ausente en últimos eventos'),
                trailing: IconButton(
                  icon: const Icon(Icons.chat, color: Colors.green),
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
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
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
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
