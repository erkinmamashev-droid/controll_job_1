import 'package:flutter/material.dart';

import '../models/spell.dart';
import '../theme/hogwarts_colors.dart';
import 'spell_effect_dialog.dart';

class SpellsSection extends StatelessWidget {
  const SpellsSection({
    super.key,
    required this.spells,
    required this.query,
    required this.onQueryChanged,
  });

  final List<Spell> spells;
  final String query;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();
    final filteredSpells = spells.where((spell) {
      return spell.name.toLowerCase().contains(normalizedQuery) ||
          spell.use.toLowerCase().contains(normalizedQuery);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF17382D), Color(0xFF42674D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(26),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'СЛОВАРЬ ЗАКЛИНАНИЙ',
                style: TextStyle(
                  color: Color(0xFFF4D990),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Слова, меняющие мир',
                style: TextStyle(
                  color: Color(0xFFFFF8E9),
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Georgia',
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Найдите заклинание и узнайте, что оно делает.',
                style: TextStyle(
                  color: Color(0xFFD8E1D6),
                  height: 1.4,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: onQueryChanged,
          decoration: InputDecoration(
            hintText: 'Поиск заклинания или эффекта',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: HogwartsColors.inputFor(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: HogwartsColors.borderFor(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: HogwartsColors.borderFor(context)),
            ),
          ),
        ),
        const SizedBox(height: 14),
        for (final spell in filteredSpells)
          Card(
            margin: const EdgeInsets.only(bottom: 9),
            color: HogwartsColors.surfaceFor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
              side: BorderSide(color: HogwartsColors.borderFor(context)),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(17),
              onTap: () => showDialog<void>(
                context: context,
                builder: (context) => SpellEffectDialog(spell: spell),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                leading: CircleAvatar(
                  backgroundColor: HogwartsColors.iconBackgroundFor(context),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Theme.of(context).colorScheme.primary,
                    size: 19,
                  ),
                ),
                title: Text(
                  spell.name,
                  style: TextStyle(
                    color: HogwartsColors.textFor(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  spell.use,
                  style: TextStyle(
                    color: HogwartsColors.secondaryTextFor(context),
                    height: 1.35,
                  ),
                ),
                trailing: Icon(
                  Icons.play_circle_outline,
                  color: HogwartsColors.mutedTextFor(context),
                ),
              ),
            ),
          ),
        if (filteredSpells.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Заклинания не найдены', textAlign: TextAlign.center),
          ),
      ],
    );
  }
}
