import 'package:flutter/material.dart';

import '../models/character.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    final children = character.children.isEmpty
        ? 'Нет данных'
        : character.children.join(', ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 96,
                height: 128,
                child: character.image.isEmpty
                    ? const ColoredBox(
                        color: Color(0xFFE2DDCF),
                        child: Icon(Icons.person, size: 40),
                      )
                    : Image.network(
                        character.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const ColoredBox(
                              color: Color(0xFFE2DDCF),
                              child: Icon(Icons.person, size: 40),
                            ),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.fullName,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (character.nickname.isNotEmpty)
                    Text('Прозвище: ${character.nickname}'),
                  if (character.house.isNotEmpty)
                    Text('Факультет: ${character.house}'),
                  Text(
                    'Актёр: ${character.actor.isEmpty ? 'не указан' : character.actor}',
                  ),
                  if (character.birthdate.isNotEmpty)
                    Text('Дата рождения: ${character.birthdate}'),
                  Text('Дети: $children'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
