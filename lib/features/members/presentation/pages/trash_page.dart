import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/member.dart';
import '../bloc/members_bloc.dart';
import '../bloc/members_event.dart';
import '../bloc/members_state.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  @override
  void initState() {
    super.initState();
    context.read<MembersBloc>().add(const MembersEvent.loadTrash());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Papelera de Reciclaje'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<MembersBloc, MembersState>(
        listener: (context, state) {
          state.whenOrNull(
            actionSuccess: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: Colors.green),
              );
            },
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: Colors.red),
              );
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (members) {
              if (members.isEmpty) {
                return const Center(child: Text('La papelera está vacía'));
              }
              return ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return _TrashMemberTile(member: member);
                },
              );
            },
            orElse: () => const SizedBox(),
          );
        },
      ),
    );
  }
}

class _TrashMemberTile extends StatelessWidget {
  final Member member;

  const _TrashMemberTile({required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.person_off, color: Colors.grey),
        title: Text(
          '${member.firstName} ${member.lastName}',
          style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
        ),
        subtitle: Text('Eliminado el: ${member.updatedAt}'), // Logic update needed if we track deletedAt
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.restore_from_trash, color: Colors.green),
              tooltip: 'Restaurar',
              onPressed: () {
                context.read<MembersBloc>().add(MembersEvent.restoreMember(member.id!));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              tooltip: 'Eliminar definitivamente',
              onPressed: () => _confirmHardDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmHardDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar permanentemente?'),
        content: const Text('Esta acción NO se puede deshacer. Se borrarán todos los datos del miembro.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<MembersBloc>().add(MembersEvent.hardDeleteMember(member.id!));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );
  }
}
