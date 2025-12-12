import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../domain/entities/member.dart';
import '../../../../core/utils/enum_extensions.dart';
import '../../../../core/theme/app_theme.dart';
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
        title: const Text('Miembros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_note),
            tooltip: 'Asistencia',
            onPressed: () {
              context.push('/attendance');
            },
          ),
          IconButton(
            icon: const Icon(Icons.recycling),
            tooltip: 'Papelera',
            onPressed: () {
              context.push('/trash').then((_) {
                if (context.mounted) {
                  context.read<MembersBloc>().add(const MembersEvent.loadMembers());
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              // Implement sorting or filtering dialog
            },
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
                            color: Theme.of(context).primaryColor,
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
}
