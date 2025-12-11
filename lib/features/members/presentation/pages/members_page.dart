import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
            icon: const Icon(Icons.recycling),
            tooltip: 'Papelera',
            onPressed: () => context.push('/trash'),
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
              return ListView.separated(
                itemCount: members.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final member = members[index];
                  return MemberTile(member: member);
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
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
