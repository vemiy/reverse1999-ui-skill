import 'package:flutter/material.dart';

import 'tokens.dart';

/// 字标：中文粗体 + 小字距英文。
class R99Logo extends StatelessWidget {
  const R99Logo({super.key, this.zh = '夜航档案室', this.en = 'Night Archive', this.compact = false});
  final String zh;
  final String en;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          zh,
          style: TextStyle(
            fontFamily: R99Text.serif,
            fontSize: compact ? 18 : 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
            color: color,
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 10),
          Text(
            en.toUpperCase(),
            style: TextStyle(
              fontFamily: R99Text.display,
              fontSize: 9,
              letterSpacing: 3.8,
              color: Theme.of(context).textTheme.labelSmall?.color,
            ),
          ),
        ],
      ],
    );
  }
}

/// 侧边竖排英文，从下往上读。
class R99VerticalText extends StatelessWidget {
  const R99VerticalText(this.text, {super.key, this.color});
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: R99Text.display,
          fontSize: 10,
          letterSpacing: 3.2,
          color: color ?? Theme.of(context).textTheme.labelSmall?.color,
        ),
      ),
    );
  }
}

/// 空心大编号。
class R99OutlinedNumber extends StatelessWidget {
  const R99OutlinedNumber(this.number, {super.key, this.size = 92, this.color});
  final String number;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final stroke = color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35);
    return Text(
      number,
      style: TextStyle(
        fontFamily: R99Text.display,
        fontSize: size,
        height: 0.8,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.1
          ..color = stroke,
      ),
    );
  }
}
