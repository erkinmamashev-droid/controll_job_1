import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/spell.dart';
import '../theme/hogwarts_colors.dart';

class SpellEffectDialog extends StatefulWidget {
  const SpellEffectDialog({super.key, required this.spell});

  final Spell spell;

  @override
  State<SpellEffectDialog> createState() => _SpellEffectDialogState();
}

class _SpellEffectDialogState extends State<SpellEffectDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _SpellVisualStyle.forSpell(widget.spell);
    return Dialog(
      backgroundColor: HogwartsColors.surfaceFor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Закрыть',
                icon: const Icon(Icons.close),
              ),
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => SizedBox(
                width: 210,
                height: 150,
                child: CustomPaint(
                  painter: _SpellEffectPainter(
                    progress: _controller.value,
                    color: style.color,
                    kind: style.kind,
                  ),
                  child: Center(
                    child: Icon(
                      style.icon,
                      size: 46,
                      color: style.color,
                      shadows: [
                        Shadow(
                          color: style.color.withValues(alpha: 0.4),
                          blurRadius: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.spell.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: HogwartsColors.textFor(context),
                fontFamily: 'Georgia',
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              widget.spell.use,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HogwartsColors.secondaryTextFor(context),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              style.caption,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: style.color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF315847),
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: const Text('Великолепно'),
            ),
          ],
        ),
      ),
    );
  }
}

enum _SpellVisualKind { light, fire, water, patronus, levitation, sparkle }

class _SpellVisualStyle {
  const _SpellVisualStyle({
    required this.kind,
    required this.color,
    required this.icon,
    required this.caption,
  });

  final _SpellVisualKind kind;
  final Color color;
  final IconData icon;
  final String caption;

  static _SpellVisualStyle forSpell(Spell spell) {
    final name = spell.name.toLowerCase();
    final use = spell.use.toLowerCase();
    if (name.contains('lumos')) {
      return const _SpellVisualStyle(
        kind: _SpellVisualKind.light,
        color: Color(0xFFFFD66E),
        icon: Icons.lightbulb,
        caption: 'Свет озаряет кончик волшебной палочки',
      );
    }
    if (name.contains('incendio') || use.contains('fire')) {
      return const _SpellVisualStyle(
        kind: _SpellVisualKind.fire,
        color: Color(0xFFFF874A),
        icon: Icons.local_fire_department,
        caption: 'Вспыхивает магическое пламя',
      );
    }
    if (name.contains('aguamenti') || use.contains('water')) {
      return const _SpellVisualStyle(
        kind: _SpellVisualKind.water,
        color: Color(0xFF68CFF5),
        icon: Icons.water_drop,
        caption: 'В воздухе кружатся капли воды',
      );
    }
    if (name.contains('expecto patronum') || use.contains('patronus')) {
      return const _SpellVisualStyle(
        kind: _SpellVisualKind.patronus,
        color: Color(0xFFB7F1EA),
        icon: Icons.auto_awesome,
        caption: 'Появляется сияющее защитное облако',
      );
    }
    if (name.contains('levi') || use.contains('levitat')) {
      return const _SpellVisualStyle(
        kind: _SpellVisualKind.levitation,
        color: Color(0xFFC9A7FF),
        icon: Icons.air,
        caption: 'Предмет легко поднимается в воздух',
      );
    }
    return const _SpellVisualStyle(
      kind: _SpellVisualKind.sparkle,
      color: Color(0xFFE7C77A),
      icon: Icons.auto_awesome,
      caption: 'Искры волшебства кружатся вокруг палочки',
    );
  }
}

class _SpellEffectPainter extends CustomPainter {
  const _SpellEffectPainter({
    required this.progress,
    required this.color,
    required this.kind,
  });

  final double progress;
  final Color color;
  final _SpellVisualKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final pulse = 0.5 + math.sin(progress * math.pi * 2) * 0.12;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [color.withValues(alpha: 0.27), color.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(center: center, radius: 48 + pulse * 18));
    canvas.drawCircle(center, 48 + pulse * 18, glowPaint);

    final particleCount = kind == _SpellVisualKind.patronus ? 30 : 22;
    for (var index = 0; index < particleCount; index++) {
      final seed = index * 71 + 29;
      final angle = _randomValue(seed) * math.pi * 2 + progress * math.pi * 2;
      final orbit = 22 + _randomValue(seed + 13) * 63;
      final wave = math.sin(progress * math.pi * 2 + index) * 7;
      final distance = orbit + wave;
      final point = center.translate(
        math.cos(angle) * distance,
        math.sin(angle) * distance * 0.62,
      );
      final particleColor = kind == _SpellVisualKind.fire && index.isEven
          ? const Color(0xFFFFC45E)
          : color;
      final paint = Paint()
        ..color = particleColor.withValues(
          alpha: 0.38 + _randomValue(seed + 19) * 0.55,
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

      switch (kind) {
        case _SpellVisualKind.water:
          canvas.drawOval(
            Rect.fromCenter(
              center: point,
              width: 3 + _randomValue(seed + 23) * 3,
              height: 5 + _randomValue(seed + 31) * 5,
            ),
            paint,
          );
        case _SpellVisualKind.fire:
          final rise = (progress + _randomValue(seed + 37)) % 1;
          canvas.drawCircle(
            point.translate(0, -rise * 13),
            1.5 + _randomValue(seed + 43) * 2.4,
            paint,
          );
        case _SpellVisualKind.levitation:
          final float = math.sin(progress * math.pi * 2 + index) * 8;
          canvas.drawCircle(
            point.translate(0, float),
            1.5 + _randomValue(seed + 43) * 2,
            paint,
          );
        case _SpellVisualKind.light:
        case _SpellVisualKind.patronus:
        case _SpellVisualKind.sparkle:
          final radius = 1.1 + _randomValue(seed + 43) * 2.2;
          canvas.drawCircle(point, radius, paint);
          if (index % 4 == 0) {
            canvas.drawLine(
              point.translate(-radius * 1.8, 0),
              point.translate(radius * 1.8, 0),
              paint..strokeWidth = 0.8,
            );
            canvas.drawLine(
              point.translate(0, -radius * 1.8),
              point.translate(0, radius * 1.8),
              paint,
            );
          }
      }
    }
  }

  double _randomValue(int seed) {
    final value = math.sin(seed * 127.1 + 311.7) * 43758.5453;
    return value - value.floorToDouble();
  }

  @override
  bool shouldRepaint(_SpellEffectPainter oldDelegate) =>
      progress != oldDelegate.progress ||
      color != oldDelegate.color ||
      kind != oldDelegate.kind;
}
