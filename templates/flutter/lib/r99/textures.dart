import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'tokens.dart';

/// 四层背景：底光、雨丝、颗粒、暗角。
class R99Backdrop extends StatelessWidget {
  const R99Backdrop({super.key, required this.palette, required this.child});

  final R99Palette palette;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = palette.bg.computeLuminance() < 0.4;
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [palette.bg, palette.bgDeep],
              ),
            ),
          ),
        ),
        if (dark)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.6, -0.8),
                  radius: 1.2,
                  colors: [
                    const Color(0xFF2E444F).withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: R99RainPainter(dark: dark)),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: R99GrainPainter(dark: dark)),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 1.1,
                  colors: [
                    Colors.transparent,
                    (dark ? Colors.black : const Color(0xFF503720)).withValues(alpha: dark ? 0.55 : 0.16),
                  ],
                  stops: const [0.45, 1.0],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class R99RainPainter extends CustomPainter {
  const R99RainPainter({this.dark = true});
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..color = (dark ? const Color(0xFFE2ECF0) : const Color(0xFF5A4632)).withValues(alpha: dark ? 0.055 : 0.05);
    const gap = 9.0;
    for (double x = -size.height; x < size.width; x += gap) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height * 0.18, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant R99RainPainter oldDelegate) => oldDelegate.dark != dark;
}

class R99GrainPainter extends CustomPainter {
  const R99GrainPainter({this.dark = true});
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(1999);
    final paint = Paint();
    final count = (size.width * size.height / 900).clamp(200, 2200).toInt();
    for (var i = 0; i < count; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final a = 0.02 + rnd.nextDouble() * 0.035;
      paint.color = (dark ? Colors.white : Colors.black).withValues(alpha: a);
      canvas.drawCircle(Offset(x, y), 0.7, paint);
    }
  }

  @override
  bool shouldRepaint(covariant R99GrainPainter oldDelegate) => oldDelegate.dark != dark;
}

/// 封面用的雨夜钟楼。
class R99ScenePainter extends CustomPainter {
  const R99ScenePainter({required this.palette});
  final R99Palette palette;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final sky = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF24343D), Color(0xFF16212A), Color(0xFF0A0D10)],
        stops: [0, 0.55, 1],
      ).createShader(rect);
    canvas.drawRect(rect, sky);

    final glowCenter = Offset(size.width * 0.72, size.height * 0.62);
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFC97A2B).withValues(alpha: 0.55),
          const Color(0xFF8A4A1F).withValues(alpha: 0.18),
          Colors.transparent,
        ],
        stops: const [0, 0.45, 1],
      ).createShader(Rect.fromCircle(center: glowCenter, radius: size.width * 0.42));
    canvas.drawRect(rect, glow);

    final black = Paint()..color = const Color(0xFF080B0D);
    final buildings = <Rect>[
      Rect.fromLTWH(0, size.height * 0.69, size.width * 0.08, size.height * 0.31),
      Rect.fromLTWH(size.width * 0.07, size.height * 0.73, size.width * 0.06, size.height * 0.27),
      Rect.fromLTWH(size.width * 0.55, size.height * 0.71, size.width * 0.09, size.height * 0.29),
      Rect.fromLTWH(size.width * 0.63, size.height * 0.67, size.width * 0.05, size.height * 0.33),
      Rect.fromLTWH(size.width * 0.9, size.height * 0.71, size.width * 0.1, size.height * 0.29),
    ];
    for (final b in buildings) {
      canvas.drawRect(b, black);
    }

    // 钟楼：塔身、钟室、尖顶。
    final cx = size.width * 0.47;
    final ink = Paint()..color = const Color(0xFF0B0F12);
    final shaftW = size.width * 0.026;
    final clockTop = size.height * 0.285;
    final clockH = size.height * 0.075;
    final spireTop = size.height * 0.20;

    canvas.drawRect(
      Rect.fromLTWH(cx - shaftW / 2, clockTop + clockH, shaftW, size.height - clockTop - clockH),
      ink,
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - shaftW * 1.55, clockTop, shaftW * 3.1, clockH),
      ink,
    );
    final spire = Path()
      ..moveTo(cx - shaftW * 1.55, clockTop)
      ..lineTo(cx, spireTop)
      ..lineTo(cx + shaftW * 1.55, clockTop)
      ..close();
    canvas.drawPath(spire, ink);
    canvas.drawRect(
      Rect.fromLTWH(cx - shaftW * 1.9, clockTop + clockH - 2, shaftW * 3.8, size.height * 0.012),
      ink,
    );

    final clockCenter = Offset(cx, clockTop + clockH * 0.52);
    final clockR = size.width * 0.0125;
    canvas.drawCircle(clockCenter, clockR, Paint()..color = const Color(0xFFD9C9A8).withValues(alpha: 0.5));
    canvas.drawCircle(
      clockCenter,
      clockR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = const Color(0xFFC97A2B).withValues(alpha: 0.55),
    );
    canvas.drawLine(
      clockCenter,
      clockCenter + Offset(0, -clockR * 0.6),
      Paint()
        ..strokeWidth = 1
        ..color = const Color(0xFF2A1C14),
    );
    canvas.drawLine(
      clockCenter,
      clockCenter + Offset(clockR * 0.45, clockR * 0.2),
      Paint()
        ..strokeWidth = 1
        ..color = const Color(0xFF2A1C14),
    );

    final slit = Paint()..color = const Color(0xFFC97A2B).withValues(alpha: 0.35);
    for (var i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          cx - 1.5,
          clockTop + clockH + size.height * (0.12 + i * 0.075),
          3,
          8,
        ),
        slit,
      );
    }

    final rnd = math.Random(42);
    final rain = Paint()
      ..strokeWidth = 1
      ..color = const Color(0xFFE7F1F3).withValues(alpha: 0.08);
    for (var i = 0; i < 90; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final len = 14 + rnd.nextDouble() * 46;
      canvas.drawLine(Offset(x, y), Offset(x + len * 0.16, y + len), rain);
    }

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, palette.bg],
          stops: const [0.42, 1.0],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant R99ScenePainter oldDelegate) => oldDelegate.palette != palette;
}

/// 卡片用的三种抽象图：拱门、电波、罗盘。
enum R99ArtKind { arch, radio, clock }

class R99ArtPainter extends CustomPainter {
  const R99ArtPainter({required this.kind});
  final R99ArtKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2329), Color(0xFF0B0D0F)],
        ).createShader(rect),
    );
    final center = Offset(size.width / 2, size.height * 0.46);

    switch (kind) {
      case R99ArtKind.arch:
        final line = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = const Color(0xFFC9A768).withValues(alpha: 0.75);
        for (var i = 0; i < 3; i++) {
          final r = size.width * (0.24 + i * 0.062);
          canvas.drawArc(
            Rect.fromCircle(center: Offset(center.dx, size.height * 0.58), radius: r),
            math.pi,
            math.pi,
            false,
            line,
          );
          canvas.drawLine(
            Offset(center.dx - r, size.height * 0.58),
            Offset(center.dx - r, size.height * 0.82),
            line,
          );
          canvas.drawLine(
            Offset(center.dx + r, size.height * 0.58),
            Offset(center.dx + r, size.height * 0.82),
            line,
          );
        }
        final plate = Rect.fromCenter(center: center, width: size.width * 0.16, height: size.width * 0.22);
        canvas.drawRect(plate, Paint()..color = const Color(0xFF0B0D0F));
        canvas.drawRect(
          plate,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1
            ..color = const Color(0xFFB55829),
        );
        break;
      case R99ArtKind.radio:
        final ring = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color(0xFF8EC7B0).withValues(alpha: 0.45);
        for (var i = 1; i <= 5; i++) {
          canvas.drawCircle(center, size.width * 0.07 * i, ring);
        }
        canvas.drawCircle(center, 4, Paint()..color = const Color(0xFFE9DCCD));
        break;
      case R99ArtKind.clock:
        final ring = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color(0xFFD9C9A8).withValues(alpha: 0.5);
        canvas.drawCircle(center, size.width * 0.30, ring);
        canvas.drawCircle(center, size.width * 0.23, ring..color = const Color(0xFFD9C9A8).withValues(alpha: 0.25));
        final needle = Path()
          ..moveTo(center.dx, center.dy - size.width * 0.10)
          ..lineTo(center.dx + size.width * 0.018, center.dy)
          ..lineTo(center.dx, center.dy + size.width * 0.13)
          ..lineTo(center.dx - size.width * 0.018, center.dy)
          ..close();
        canvas.drawPath(needle, Paint()..color = const Color(0xFFB55829));
        canvas.drawCircle(center, 4, Paint()..color = const Color(0xFFE9DCCD));
        break;
    }

    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
          stops: const [0.55, 1],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant R99ArtPainter oldDelegate) => oldDelegate.kind != kind;
}
