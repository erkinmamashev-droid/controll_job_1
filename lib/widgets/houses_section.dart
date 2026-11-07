import 'package:flutter/material.dart';

import '../models/house.dart';
import '../theme/hogwarts_colors.dart';

class HousesSection extends StatelessWidget {
  const HousesSection({super.key, required this.houses});

  final List<House> houses;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        SectionBanner(
          eyebrow: 'ЧЕТЫРЕ ДОМА · ОДНА ШКОЛА',
          title: 'Факультеты Хогвартса',
          subtitle: 'Узнайте историю и символы каждого факультета.',
          icon: Icons.shield_moon_outlined,
        ),
        const SizedBox(height: 16),
        for (final house in houses) _HouseCard(house: house),
      ],
    );
  }
}

class _HouseCard extends StatelessWidget {
  const _HouseCard({required this.house});

  final House house;

  @override
  Widget build(BuildContext context) {
    final color = _houseColor(house.name);
    return Card(
      margin: const EdgeInsets.only(bottom: 13),
      color: HogwartsColors.surfaceFor(context),
      elevation: 2,
      shadowColor: const Color(0x20301E13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: HogwartsColors.borderFor(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 58,
              height: 58,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(house.emoji, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    house.name,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: color, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  _HouseDetail(
                    icon: Icons.person_outline,
                    label: 'Основатель',
                    value: house.founder,
                  ),
                  _HouseDetail(
                    icon: Icons.pets_outlined,
                    label: 'Животное',
                    value: house.animal,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 7,
                    runSpacing: 6,
                    children: [
                      for (final houseColor in house.colors)
                        Chip(
                          label: Text(houseColor),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: color.withValues(alpha: 0.08),
                          side: BorderSide.none,
                          labelStyle: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HouseDetail extends StatelessWidget {
  const _HouseDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Icon(icon, size: 15, color: HogwartsColors.mutedTextFor(context)),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              color: HogwartsColors.mutedTextFor(context),
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: HogwartsColors.secondaryTextFor(context),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _houseColor(String house) {
  return switch (house) {
    'Gryffindor' => const Color(0xFF9A3834),
    'Slytherin' => const Color(0xFF38664C),
    'Ravenclaw' => const Color(0xFF365C85),
    'Hufflepuff' => const Color(0xFF9A762B),
    _ => const Color(0xFF53665A),
  };
}

class SectionBanner extends StatelessWidget {
  const SectionBanner({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF17382D), Color(0xFF42674D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: const TextStyle(
                    color: Color(0xFFF4D990),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFFFF8E9),
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFD8E1D6),
                    height: 1.4,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Icon(icon, color: const Color(0x44F4D990), size: 48),
        ],
      ),
    );
  }
}
