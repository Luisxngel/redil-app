import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redil/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:redil/features/settings/presentation/bloc/settings_event.dart';
import 'package:redil/features/settings/presentation/bloc/settings_state.dart';
import '../widgets/daily_verse_card.dart';

class AlfoliPage extends StatelessWidget {
  const AlfoliPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alfolí de Versículos"),
        actions: [
          Row(
            children: [
              const Text("En Inicio", style: TextStyle(fontSize: 12)),
              BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return Switch(
                    value: state.showDailyVerse,
                    onChanged: (_) {
                      context.read<SettingsBloc>().add(const SettingsEvent.toggleDailyVerse());
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              children: const [
                 Chip(label: Text("Fe"), backgroundColor: Colors.blueAccent),
                 SizedBox(width: 8),
                 Chip(label: Text("Liderazgo")),
                 SizedBox(width: 8),
                 Chip(label: Text("Consuelo")),
                 SizedBox(width: 8),
                 Chip(label: Text("Evangelismo")),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) => const DailyVerseCard(),
            ),
          ),
        ],
      ),
    );
  }
}
