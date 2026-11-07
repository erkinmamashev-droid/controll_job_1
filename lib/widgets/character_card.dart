import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/character.dart';
import '../theme/hogwarts_colors.dart';

class CharacterCard extends StatefulWidget {
  const CharacterCard({
    super.key,
    required this.character,
    required this.onDisintegrated,
  });

  final Character character;
  final VoidCallback onDisintegrated;

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey _cardKey = GlobalKey();
  late final AnimationController _animationController;
  ui.Image? _capturedCard;
  bool _isDisintegrating = false;

  Character get character => widget.character;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1050),
    )..addStatusListener(_handleAnimationStatus);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onDisintegrated();
    }
  }

  Future<void> _disintegrate() async {
    if (_isDisintegrating) return;

    final renderObject =
        _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (renderObject == null || !renderObject.hasSize) return;

    setState(() {
      _isDisintegrating = true;
    });

    final image = await renderObject.toImage(
      pixelRatio: MediaQuery.devicePixelRatioOf(context),
    );
    if (!mounted) {
      image.dispose();
      return;
    }

    setState(() {
      _capturedCard = image;
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    _capturedCard?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      hint: 'Нажмите, чтобы рассыпать карточку на осколки',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _disintegrate,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final progress = _animationController.value;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Opacity(opacity: _isDisintegrating ? 0 : 1, child: child),
                if (_capturedCard case final image?)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _DisintegrationPainter(
                          image: image,
                          progress: progress,
                          fade: Curves.easeIn.transform(progress),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
          child: RepaintBoundary(key: _cardKey, child: _buildCard(context)),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final children = character.children.isEmpty
        ? 'Нет данных'
        : character.children.join(', ');
    final houseColor = _houseColor(character.house);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shadowColor: HogwartsColors.isDark(context)
          ? const Color(0x80000000)
          : const Color(0x26301E13),
      color: HogwartsColors.surfaceFor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: HogwartsColors.borderFor(context)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'character-${character.fullName}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 96,
                  height: 132,
                  child: character.image.isEmpty
                      ? _portraitPlaceholder()
                      : Image.network(
                          character.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _portraitPlaceholder(),
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: HogwartsColors.textFor(context),
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  if (character.nickname.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '"${character.nickname}"',
                      style: TextStyle(
                        color: HogwartsColors.mutedTextFor(context),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: houseColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        character.house.isEmpty
                            ? 'Неизвестный факультет'
                            : character.house,
                        style: TextStyle(
                          color: houseColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _detailLine(
                    Icons.theater_comedy_outlined,
                    character.actor.isEmpty
                        ? 'Актёр не указан'
                        : character.actor,
                  ),
                  if (character.birthdate.isNotEmpty)
                    _detailLine(Icons.cake_outlined, character.birthdate),
                  _detailLine(Icons.family_restroom, children),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailLine(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: HogwartsColors.mutedTextFor(context)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: HogwartsColors.secondaryTextFor(context),
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _portraitPlaceholder() {
    return ColoredBox(
      color: HogwartsColors.iconBackgroundFor(context),
      child: Center(
        child: Icon(
          Icons.person,
          size: 42,
          color: HogwartsColors.mutedTextFor(context),
        ),
      ),
    );
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
}

class _DisintegrationPainter extends CustomPainter {
  const _DisintegrationPainter({
    required this.image,
    required this.progress,
    required this.fade,
  });

  final ui.Image image;
  final double progress;
  final double fade;

  static const int _columns = 12;
  static const int _rows = 14;

  @override
  void paint(Canvas canvas, Size size) {
    final pixelScaleX = image.width / size.width;
    final pixelScaleY = image.height / size.height;
    final easedProgress = Curves.easeOutCubic.transform(progress);
    final center = Offset(size.width / 2, size.height / 2);

    for (var row = 0; row < _rows; row++) {
      for (var column = 0; column < _columns; column++) {
        final left = size.width * column / _columns;
        final top = size.height * row / _rows;
        final right = size.width * (column + 1) / _columns;
        final bottom = size.height * (row + 1) / _rows;
        final width = right - left;
        final height = bottom - top;
        final pieceCenter = Offset(left + width / 2, top + height / 2);
        final direction = pieceCenter - center;
        final distance = math.sqrt(
          direction.dx * direction.dx + direction.dy * direction.dy,
        );
        final normalizedDirection = distance == 0
            ? const Offset(0, -1)
            : direction / distance;
        final seed = row * 37 + column * 71 + 19;
        final jitterX = _randomValue(seed) - 0.5;
        final jitterY = _randomValue(seed + 11) - 0.5;
        final flight = 30 + _randomValue(seed + 23) * 70;
        final offset = Offset(
          normalizedDirection.dx * flight * easedProgress +
              jitterX * 28 * easedProgress,
          normalizedDirection.dy * flight * easedProgress +
              68 * easedProgress * easedProgress +
              jitterY * 26 * easedProgress,
        );
        final rotation =
            jitterX * 2.8 * easedProgress +
            normalizedDirection.dx * 0.4 * easedProgress;
        final shrink = 1 - Curves.easeIn.transform(progress) * 0.42;
        final source = Rect.fromLTRB(
          left * pixelScaleX,
          top * pixelScaleY,
          right * pixelScaleX,
          bottom * pixelScaleY,
        );
        final destination = Rect.fromCenter(
          center: Offset(width / 2, height / 2),
          width: width + 1,
          height: height + 1,
        );

        canvas.save();
        canvas.translate(
          pieceCenter.dx + offset.dx,
          pieceCenter.dy + offset.dy,
        );
        canvas.rotate(rotation);
        canvas.scale(shrink);
        final piecePaint = Paint()
          ..filterQuality = FilterQuality.medium
          ..colorFilter = ColorFilter.mode(
            Colors.white.withValues(alpha: 1 - fade),
            BlendMode.modulate,
          );
        canvas.drawImageRect(image, source, destination, piecePaint);
        canvas.restore();
      }
    }

    _paintSparkles(canvas, size, easedProgress);
  }

  void _paintSparkles(Canvas canvas, Size size, double easedProgress) {
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    for (var index = 0; index < 18; index++) {
      final seed = index * 97 + 31;
      final x = size.width * _randomValue(seed);
      final y = size.height * _randomValue(seed + 7);
      final fall = easedProgress * (25 + _randomValue(seed + 13) * 55);
      paint.color =
          (index.isEven ? const Color(0xFFFFD477) : const Color(0xFF91C9AE))
              .withValues(alpha: (1 - progress) * 0.9);
      canvas.drawCircle(
        Offset(x + (x - size.width / 2) * easedProgress * 0.5, y + fall),
        1.3 + _randomValue(seed + 19) * 2.2,
        paint,
      );
    }
  }

  double _randomValue(int seed) {
    final value = math.sin(seed * 127.1 + 311.7) * 43758.5453;
    return value - value.floorToDouble();
  }

  @override
  bool shouldRepaint(_DisintegrationPainter oldDelegate) =>
      image != oldDelegate.image ||
      progress != oldDelegate.progress ||
      fade != oldDelegate.fade;
}
