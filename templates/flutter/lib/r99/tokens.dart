import 'package:flutter/material.dart';

/// 平台无关的设计变量。
@immutable
class R99Palette {
  const R99Palette({
    required this.bg,
    required this.bgDeep,
    required this.surface,
    required this.surfaceSolid,
    required this.paper,
    required this.text,
    required this.textMuted,
    required this.ink,
    required this.inkMuted,
    required this.line,
    required this.lineStrong,
    required this.accent,
    required this.accentBright,
    required this.ok,
    required this.due,
    required this.settled,
  });

  final Color bg;
  final Color bgDeep;
  final Color surface;
  final Color surfaceSolid;
  final Color paper;
  final Color text;
  final Color textMuted;
  final Color ink;
  final Color inkMuted;
  final Color line;
  final Color lineStrong;
  final Color accent;
  final Color accentBright;
  final Color ok;
  final Color due;
  final Color settled;

  static const R99Palette dark = R99Palette(
    bg: Color(0xFF0B0A09),
    bgDeep: Color(0xFF070606),
    surface: Color(0xD0000000),
    surfaceSolid: Color(0xFF141210),
    paper: Color(0xFFE9DCCD),
    text: Color(0xFFFFFDE9),
    textMuted: Color(0xFFC9C2B4),
    ink: Color(0xFF171310),
    inkMuted: Color(0xFF5B544B),
    line: Color(0x29E9DCCD),
    lineStrong: Color(0x52E9DCCD),
    accent: Color(0xFFB55829),
    accentBright: Color(0xFFDB6F39),
    ok: Color(0xFF8EC755),
    due: Color(0xFFF56064),
    settled: Color(0xFF8C8D8C),
  );

  static const R99Palette light = R99Palette(
    bg: Color(0xFFE4D6C3),
    bgDeep: Color(0xFFD8C8B3),
    surface: Color(0xE0F7F1E6),
    surfaceSolid: Color(0xFFF7F1E6),
    paper: Color(0xFFE9DCCD),
    text: Color(0xFF171310),
    textMuted: Color(0xFF5B544B),
    ink: Color(0xFF171310),
    inkMuted: Color(0xFF5B544B),
    line: Color(0x29171310),
    lineStrong: Color(0x52171310),
    accent: Color(0xFF9A4620),
    accentBright: Color(0xFFB55829),
    ok: Color(0xFF345D1B),
    due: Color(0xFFA32B30),
    settled: Color(0xFF5B544B),
  );

  /// 强调色填充上的文字色：亮强调色用墨色，暗强调色用奶白。
  Color get onAccent => accent.computeLuminance() > 0.33 ? ink : const Color(0xFFFFFDE9);

  R99Palette copyWith({Color? accent, Color? accentBright, Color? ok, Color? due}) {
    return R99Palette(
      bg: bg,
      bgDeep: bgDeep,
      surface: surface,
      surfaceSolid: surfaceSolid,
      paper: paper,
      text: text,
      textMuted: textMuted,
      ink: ink,
      inkMuted: inkMuted,
      line: line,
      lineStrong: lineStrong,
      accent: accent ?? this.accent,
      accentBright: accentBright ?? this.accentBright,
      ok: ok ?? this.ok,
      due: due ?? this.due,
      settled: settled,
    );
  }
}

/// 四组预设的强调色。
class R99Accents {
  static const Map<String, Color> values = {
    'rust': Color(0xFFB55829),
    'amber': Color(0xFFC97A2B),
    'verdigris': Color(0xFF4F7D6A),
    'gold': Color(0xFFB08D4F),
  };

  static const Map<String, Color> bright = {
    'rust': Color(0xFFDB6F39),
    'amber': Color(0xFFE08F3D),
    'verdigris': Color(0xFF6A9B86),
    'gold': Color(0xFFC9A768),
  };
}

class R99Size {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 16;
  static const double s4 = 24;
  static const double s5 = 40;
  static const double s6 = 64;
  static const double s7 = 96;

  static const double rBtn = 0;
  static const double rChip = 0;
  static const double rCard = 0;
  static const double rPanel = 0;
  static const double rDialog = 0;
  static const double rItem = 0;

  static const double hair = 1;
  static const double strong = 2;
  static const double active = 4;

  static const double maxWidth = 1180;
  static const double tapTarget = 46;
}

class R99Motion {
  static const Duration enter = Duration(milliseconds: 500);
  static const Duration exit = Duration(milliseconds: 350);
  static const Duration hover = Duration(milliseconds: 200);
  static const Curve enterCurve = Cubic(0.22, 0.61, 0.36, 1);
  static const Curve exitCurve = Cubic(0.33, 0, 0.2, 1);
  static const double shift = 32;
  static const Duration stagger = Duration(milliseconds: 60);
}

class R99Text {
  static const String serif = 'NotoSerifSC';
  static const String display = 'BodoniModa';
}

/// 统一圆角：面板与卡片为直角，按钮与小组件用 5–6px。
BorderRadius r99Radius(double radius) => BorderRadius.circular(radius);
