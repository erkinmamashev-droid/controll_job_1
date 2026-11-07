import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class MagicEffects extends StatefulWidget {
  const MagicEffects({super.key});

  @override
  State<MagicEffects> createState() => _MagicEffectsState();
}

class _MagicEffectsState extends State<MagicEffects>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final math.Random _random = math.Random();
  Timer? _timer;
  int _effectSeed = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..addStatusListener(_handleAnimationStatus);
    _scheduleEffect();
  }

  void _scheduleEffect() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: 3 + _random.nextInt(5)), () {
      if (mounted) {
        _effectSeed++;
        _controller.forward(from: 0);
      }
    });
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) _scheduleEffect();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => CustomPaint(
        painter: _MagicSparklePainter(
          progress: _controller.value,
          seed: _effectSeed,
        ),
      ),
    );
  }
}

class _MagicSparklePainter extends CustomPainter {
  const _MagicSparklePainter({required this.progress, required this.seed});

  final double progress;
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final fade = progress < 0.18 ? progress / 0.18 : (1 - progress) / 0.82;
    for (var index = 0; index < 24; index++) {
      final particleSeed = index * 83 + 17 + seed * 101;
      final x = size.width * _randomValue(particleSeed);
      final y = size.height * (0.08 + _randomValue(particleSeed + 13) * 0.84);
      final drift = (progress - 0.5) * 22;
      final rise = progress * (15 + _randomValue(particleSeed + 29) * 34);
      final radius = 1.4 + _randomValue(particleSeed + 41) * 2.7;
      final alpha = (fade * (0.36 + _randomValue(particleSeed + 53) * 0.38))
          .clamp(0.0, 0.62);
      final paint = Paint()
        ..color =
            (index.isEven ? const Color(0xFFFFD98A) : const Color(0xFFBDE6C6))
                .withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 1.2);
      final center = Offset(x + drift, y - rise);

      canvas.drawCircle(center, radius, paint);
      if (index % 3 == 0) {
        final linePaint = Paint()
          ..color = paint.color
          ..strokeWidth = 0.8
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          center.translate(-radius * 1.6, 0),
          center.translate(radius * 1.6, 0),
          linePaint,
        );
        canvas.drawLine(
          center.translate(0, -radius * 1.6),
          center.translate(0, radius * 1.6),
          linePaint,
        );
      }
    }
  }

  double _randomValue(int seed) {
    final value = math.sin(seed * 127.1 + 311.7) * 43758.5453;
    return value - value.floorToDouble();
  }

  @override
  bool shouldRepaint(_MagicSparklePainter oldDelegate) =>
      progress != oldDelegate.progress || seed != oldDelegate.seed;
}
