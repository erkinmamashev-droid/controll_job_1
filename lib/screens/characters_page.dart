import 'package:flutter/material.dart';

import '../models/character.dart';
import '../services/character_api.dart';
import '../widgets/character_card.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({
    super.key,
    this.characterLoader = CharacterApi.fetchCharacters,
  });

  final Future<List<Character>> Function() characterLoader;

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  late Future<List<Character>> _characters;

  @override
  void initState() {
    super.initState();
    _characters = widget.characterLoader();
  }

  void _reload() {
    setState(() {
      _characters = widget.characterLoader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Персонажи Гарри Поттера'),
        actions: [
          IconButton(
            onPressed: _reload,
            tooltip: 'Обновить',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<Character>>(
        future: _characters,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Не удалось загрузить персонажей',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          }

          final characters = snapshot.data ?? const <Character>[];
          if (characters.isEmpty) {
            return const Center(child: Text('Персонажи не найдены'));
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Найдено персонажей: ${characters.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              for (final character in characters)
                CharacterCard(character: character),
            ],
          );
        },
      ),
    );
  }
}
