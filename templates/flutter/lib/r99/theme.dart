import 'package:flutter/material.dart';

import 'tokens.dart';

/// 由调色板生成 ThemeData。
ThemeData buildR99Theme(R99Palette p) {
  final brightness = p.bg.computeLuminance() > 0.4 ? Brightness.light : Brightness.dark;
  final scheme = ColorScheme.fromSeed(seedColor: p.accent, brightness: brightness).copyWith(
    primary: p.accent,
    surface: p.bg,
    onSurface: p.text,
    outline: p.lineStrong,
  );

  TextStyle t(double size, {double height = 1.5, double tracking = 0.4, FontWeight weight = FontWeight.w400, Color? color}) {
    return TextStyle(
      fontFamily: R99Text.serif,
      fontSize: size,
      height: height,
      letterSpacing: tracking,
      fontWeight: weight,
      color: color ?? p.text,
    );
  }

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: p.bg,
    colorScheme: scheme,
    fontFamily: R99Text.serif,
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: R99Text.display,
        fontSize: 64,
        height: 1.04,
        letterSpacing: 1.2,
        color: p.text,
      ),
      displayMedium: TextStyle(
        fontFamily: R99Text.display,
        fontSize: 44,
        height: 1.08,
        letterSpacing: 1.0,
        color: p.text,
      ),
      headlineLarge: t(40, height: 1.24, tracking: 1.6, weight: FontWeight.w700),
      headlineMedium: t(28, height: 1.35, tracking: 1.1, weight: FontWeight.w700),
      titleLarge: t(20, height: 1.45, tracking: 0.8, weight: FontWeight.w700),
      bodyLarge: t(16, height: 1.9, tracking: 0.16),
      bodyMedium: t(14, height: 1.8, tracking: 0.12),
      labelSmall: TextStyle(
        fontFamily: R99Text.display,
        fontSize: 11,
        height: 1.4,
        letterSpacing: 2.4,
        color: p.textMuted,
      ),
    ),
    dividerColor: p.line,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );
}

/// 向下传递调色板与「是否在纸面上」。
class R99Scope extends InheritedWidget {
  const R99Scope({super.key, required this.palette, required this.onPaper, required super.child});

  final R99Palette palette;
  final bool onPaper;

  Color get fg => onPaper ? palette.ink : palette.text;
  Color get fgMuted => onPaper ? palette.inkMuted : palette.textMuted;
  Color get line => onPaper ? palette.lineStrong : palette.line;
  Color get lineStrong => palette.lineStrong;

  static R99Scope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<R99Scope>();
    assert(scope != null, 'R99Scope 缺失：请把界面包在 R99Scope 里');
    return scope!;
  }

  @override
  bool updateShouldNotify(R99Scope oldWidget) =>
      palette != oldWidget.palette || onPaper != oldWidget.onPaper;
}
