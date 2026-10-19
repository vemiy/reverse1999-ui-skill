import 'package:flutter/material.dart';

import 'textures.dart';

import 'tokens.dart';
import 'theme.dart';

/// 小字眉标：前置 24px 细线 + 大写字距。
class R99Kicker extends StatelessWidget {
  const R99Kicker(this.text, {super.key, this.accent = false});
  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    final color = accent ? scope.palette.accent : scope.fgMuted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 24, height: 1, color: color),
        const SizedBox(width: 10),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            fontFamily: R99Text.display,
            fontSize: 11,
            letterSpacing: 2.4,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// 分段标题：上沿强调色线、下沿灰线，左侧大号编号。
class R99Plate extends StatelessWidget {
  const R99Plate({super.key, required this.number, required this.en, required this.title});
  final String number;
  final String en;
  final String title;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: R99Size.s2),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: scope.palette.accent, width: R99Size.hair),
          bottom: BorderSide(color: scope.line, width: R99Size.hair),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            number,
            style: TextStyle(
              fontFamily: R99Text.display,
              fontSize: 28,
              height: 1,
              color: scope.palette.accent,
            ),
          ),
          const SizedBox(width: R99Size.s3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                en.toUpperCase(),
                style: TextStyle(
                  fontFamily: R99Text.display,
                  fontSize: 11,
                  letterSpacing: 2.6,
                  color: scope.fgMuted,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: R99Text.serif,
                  fontSize: 28,
                  height: 1.3,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                  color: scope.fg,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 深色玻璃面板：右上单角 30。
class R99Panel extends StatelessWidget {
  const R99Panel({super.key, required this.child, this.padding = const EdgeInsets.all(R99Size.s4)});
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: scope.palette.surface,
        border: Border.all(color: scope.palette.accent, width: R99Size.hair),
        borderRadius: r99Radius(R99Size.rPanel),
      ),
      child: child,
    );
  }
}

/// 安静面板：只有一条细线。
class R99QuietPanel extends StatelessWidget {
  const R99QuietPanel({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Container(
      padding: const EdgeInsets.all(R99Size.s4),
      decoration: BoxDecoration(
        border: Border.all(color: scope.line, width: R99Size.hair),
        borderRadius: r99Radius(R99Size.rCard),
      ),
      child: child,
    );
  }
}

/// 米纸面板：内部切换为墨色文字。
class R99PaperPanel extends StatelessWidget {
  const R99PaperPanel({super.key, required this.builder});
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return R99Scope(
      palette: scope.palette,
      onPaper: true,
      child: Builder(
        builder: (inner) => Container(
          padding: const EdgeInsets.all(R99Size.s4),
          decoration: BoxDecoration(
            color: scope.palette.paper,
            border: Border.all(color: scope.palette.accent, width: R99Size.hair),
            borderRadius: r99Radius(R99Size.rPanel),
          ),
          child: builder(inner),
        ),
      ),
    );
  }
}

class R99Divider extends StatelessWidget {
  const R99Divider({super.key});
  @override
  Widget build(BuildContext context) => Container(height: 1, color: R99Scope.of(context).line);
}

class R99Rule extends StatelessWidget {
  const R99Rule({super.key});
  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Row(
      children: [
        Container(width: 6, height: 6, color: scope.palette.accent),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [scope.palette.accent, scope.line],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class R99Button extends StatefulWidget {
  const R99Button({
    super.key,
    required this.label,
    this.en,
    this.primary = false,
    this.onTap,
    this.expand = false,
  });

  final String label;
  final String? en;
  final bool primary;
  final VoidCallback? onTap;
  final bool expand;

  @override
  State<R99Button> createState() => _R99ButtonState();
}

class _R99ButtonState extends State<R99Button> {
  bool _hover = false;
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    final p = scope.palette;
    final Color bg;
    final Color border;
    final Color fg;
    final darken = _down ? 0.2 : (_hover ? 0.035 : 0.0);
    if (widget.primary) {
      bg = Color.lerp(p.accent, Colors.black, darken)!;
      border = bg;
      fg = p.onAccent;
    } else {
      bg = Color.lerp(Colors.transparent, Colors.black, darken) ?? Colors.transparent;
      border = scope.line;
      fg = scope.fg;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _down = true),
        onTapUp: (_) => setState(() => _down = false),
        onTapCancel: () => setState(() => _down = false),
        child: AnimatedContainer(
          duration: R99Motion.hover,
          width: widget.expand ? double.infinity : null,
          constraints: const BoxConstraints(minHeight: R99Size.tapTarget),
          padding: const EdgeInsets.symmetric(horizontal: R99Size.s4, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border, width: R99Size.hair),
            borderRadius: r99Radius(R99Size.rBtn),
          ),
          child: Row(
            mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: R99Text.serif,
                  fontSize: 15,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                  color: fg,
                ),
              ),
              if (widget.en != null) ...[
                const SizedBox(width: R99Size.s2),
                Text(
                  widget.en!.toUpperCase(),
                  style: TextStyle(
                    fontFamily: R99Text.display,
                    fontSize: 10,
                    letterSpacing: 2.4,
                    color: fg.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class R99Chip extends StatelessWidget {
  const R99Chip(this.label, {super.key, this.selected = false, this.onTap});
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    final p = scope.palette;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? p.accent : Colors.transparent,
          border: Border.all(color: selected ? p.accent : scope.line, width: R99Size.hair),
          borderRadius: r99Radius(R99Size.rBtn),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: R99Text.serif,
            fontSize: 13,
            color: selected ? p.onAccent : scope.fg,
          ),
        ),
      ),
    );
  }
}

class R99Tag extends StatelessWidget {
  const R99Tag(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(border: Border.all(color: scope.line, width: R99Size.hair)),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: R99Text.display,
          fontSize: 10,
          letterSpacing: 1.8,
          color: scope.fgMuted,
        ),
      ),
    );
  }
}

enum R99StatusKind { ok, due, settled }

class R99Status extends StatelessWidget {
  const R99Status(this.text, {super.key, this.kind = R99StatusKind.settled});
  final String text;
  final R99StatusKind kind;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    final p = scope.palette;
    final color = switch (kind) {
      R99StatusKind.ok => p.ok,
      R99StatusKind.due => p.due,
      R99StatusKind.settled => p.settled,
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontFamily: R99Text.serif, fontSize: 12, color: color)),
      ],
    );
  }
}

class R99Stamp extends StatelessWidget {
  const R99Stamp(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Transform.rotate(
      angle: -5 * 3.1415926 / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: scope.palette.accent, width: R99Size.strong),
        ),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontFamily: R99Text.display,
            fontSize: 10,
            letterSpacing: 2,
            color: scope.palette.accent,
          ),
        ),
      ),
    );
  }
}

/// 元数据：条目之间用竖线分隔。
class R99Meta extends StatelessWidget {
  const R99Meta(this.items, {super.key});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    final children = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        children.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: R99Size.s2),
          child: Text('│', style: TextStyle(color: scope.palette.accent, fontSize: 12)),
        ));
      }
      children.add(Text(
        items[i],
        style: TextStyle(
          fontFamily: R99Text.display,
          fontSize: 12,
          letterSpacing: 1.4,
          color: scope.fgMuted,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ));
    }
    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: children);
  }
}

class R99Field extends StatelessWidget {
  const R99Field({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: R99Text.display,
            fontSize: 10,
            letterSpacing: 2,
            color: scope.fgMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: R99Text.serif,
            fontSize: 16,
            color: scope.fg,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

/// 记录行：编号 / 日期 / 名称 / 状态。
class R99Row extends StatefulWidget {
  const R99Row({
    super.key,
    required this.number,
    required this.date,
    required this.name,
    required this.status,
    this.kind = R99StatusKind.ok,
    this.onTap,
  });

  final String number;
  final String date;
  final String name;
  final String status;
  final R99StatusKind kind;
  final VoidCallback? onTap;

  @override
  State<R99Row> createState() => _R99RowState();
}

class _R99RowState extends State<R99Row> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: scope.line, width: R99Size.hair),
              left: BorderSide(
                color: _hover ? scope.palette.accent : Colors.transparent,
                width: R99Size.strong,
              ),
            ),
            color: _hover ? Colors.white.withValues(alpha: 0.035) : Colors.transparent,
          ),
          padding: const EdgeInsets.symmetric(vertical: R99Size.s3, horizontal: R99Size.s2),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  widget.number,
                  style: TextStyle(
                    fontFamily: R99Text.display,
                    fontSize: 13,
                    letterSpacing: 1.4,
                    color: scope.palette.accent,
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: Text(
                  widget.date,
                  style: TextStyle(
                    fontFamily: R99Text.display,
                    fontSize: 12,
                    letterSpacing: 1.2,
                    color: scope.fgMuted,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.name,
                  style: TextStyle(fontFamily: R99Text.serif, fontSize: 16, color: scope.fg),
                ),
              ),
              R99Status(widget.status, kind: widget.kind),
            ],
          ),
        ),
      ),
    );
  }
}

/// 档案卡：3:4 图 + 编号 + 标题 + 状态。
class R99RecordCard extends StatefulWidget {
  const R99RecordCard({
    super.key,
    required this.kind,
    required this.number,
    required this.date,
    required this.title,
    this.status = '已归档',
    this.statusKind = R99StatusKind.ok,
  });

  final R99ArtKind kind;
  final String number;
  final String date;
  final String title;
  final String status;
  final R99StatusKind statusKind;

  @override
  State<R99RecordCard> createState() => _R99RecordCardState();
}

class _R99RecordCardState extends State<R99RecordCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: R99Motion.hover,
        decoration: BoxDecoration(
          border: Border.all(color: _hover ? scope.palette.accent : scope.line, width: R99Size.hair),
          borderRadius: r99Radius(R99Size.rCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: r99Radius(R99Size.rCard),
                child: CustomPaint(painter: R99ArtPainter(kind: widget.kind)),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(R99Size.s3),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: scope.line, width: R99Size.hair)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  R99Meta([widget.number, widget.date]),
                  const SizedBox(height: 6),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: R99Text.serif,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: scope.fg,
                    ),
                  ),
                  const SizedBox(height: 6),
                  R99Status(widget.status, kind: widget.statusKind),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class R99Meter extends StatelessWidget {
  const R99Meter({super.key, required this.label, required this.value, required this.ratio});
  final String label;
  final String value;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: R99Text.display,
                fontSize: 10,
                letterSpacing: 1.8,
                color: scope.fgMuted,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: R99Text.display,
                fontSize: 10,
                letterSpacing: 1.8,
                color: scope.fgMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(height: 3, color: scope.line),
            FractionallySizedBox(
              widthFactor: ratio.clamp(0.0, 1.0),
              child: Container(height: 3, color: scope.palette.accent),
            ),
          ],
        ),
      ],
    );
  }
}

class R99Indicators extends StatelessWidget {
  const R99Indicators({super.key, required this.count, this.index = 0});
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Row(
      children: List.generate(count, (i) {
        final on = i == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i == count - 1 ? 0 : 1),
            child: Container(
              height: on ? R99Size.active : 2,
              color: on ? scope.palette.accentBright : scope.palette.lineStrong,
            ),
          ),
        );
      }),
    );
  }
}

class R99Empty extends StatelessWidget {
  const R99Empty(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: R99Size.s6, horizontal: R99Size.s4),
      decoration: BoxDecoration(
        border: Border.all(color: scope.line, width: R99Size.hair),
        borderRadius: r99Radius(R99Size.rCard),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: R99Text.serif, fontSize: 14, height: 1.8, color: scope.fgMuted),
      ),
    );
  }
}

/// 进入动效：淡入并上移 32。
class R99Reveal extends StatefulWidget {
  const R99Reveal({super.key, required this.child, this.delay = Duration.zero});
  final Widget child;
  final Duration delay;

  @override
  State<R99Reveal> createState() => _R99RevealState();
}

class _R99RevealState extends State<R99Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: R99Motion.enter,
  );
  late final Animation<double> _curve = CurvedAnimation(parent: _controller, curve: R99Motion.enterCurve);

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    if (reduce) return widget.child;
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) {
        return Opacity(
          opacity: _curve.value,
          child: Transform.translate(
            offset: Offset(0, R99Motion.shift * (1 - _curve.value)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// 战斗复现条：常驻状态条。
class R99ReplayStrip extends StatelessWidget {
  const R99ReplayStrip({
    super.key,
    this.label = '行为复现中',
    this.en = 'Battle replaying',
    this.inline = false,
  });

  final String label;
  final String en;

  /// inline 为 true 时参与布局，否则输出 Positioned。
  final bool inline;

  static const Color _shell = Color(0xD6222626);
  static const Color _edge = Color(0x8CFFFFFF);
  static const Color _ink = Color(0xFFF4F2EC);

  @override
  Widget build(BuildContext context) {
    final dots = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: 5),
          Container(width: 7, height: 7, color: _ink.withValues(alpha: 0.85)),
        ],
      ],
    );

    final strip = Semantics(
      container: true,
      label: label,
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: _shell,
            border: Border.all(color: _edge, width: R99Size.hair),
            borderRadius: const BorderRadius.only(topRight: Radius.circular(14)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              dots,
              const SizedBox(width: R99Size.s3),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: R99Text.serif,
                      fontSize: 22,
                      height: 1.2,
                      letterSpacing: 1.2,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    en.toUpperCase(),
                    style: TextStyle(
                      fontFamily: R99Text.display,
                      fontSize: 10,
                      letterSpacing: 3.4,
                      color: _ink.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (inline) return strip;
    return Positioned(top: R99Size.s4, right: R99Size.s4, child: strip);
  }
}

/// 新信息标记：正方形色块，可带数字，可贴到父容器右上角。
class R99Unread extends StatelessWidget {
  const R99Unread({super.key, this.count, this.corner = false});

  final String? count;

  /// corner 为 true 时输出 Positioned，需要 Stack。
  final bool corner;

  static const Color _mark = Color(0xFFD8462F);
  static const Color _ink = Color(0xFFFFFDF6);

  @override
  Widget build(BuildContext context) {
    final label = count?.trim() ?? '';
    final isCount = label.isNotEmpty;

    final mark = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: isCount ? 16 : 8,
        minHeight: isCount ? 16 : 8,
        maxWidth: isCount ? double.infinity : 8,
        maxHeight: isCount ? double.infinity : 8,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: isCount ? 3 : 0),
        alignment: isCount ? Alignment.center : null,
        decoration: const BoxDecoration(color: _mark),
        child: isCount
            ? Text(
                label,
                style: const TextStyle(
                  fontFamily: R99Text.display,
                  fontSize: 10,
                  height: 1,
                  color: _ink,
                ),
              )
            : null,
      ),
    );

    if (!corner) return mark;
    return Positioned(top: -4, right: -6, child: mark);
  }
}

/// 对话框：与面板同一套圆角与描边。
Future<void> showR99Dialog(
  BuildContext context, {
  required String kicker,
  required String title,
  required String body,
  required String confirm,
  String cancel = '取消',
  VoidCallback? onConfirm,
}) async {
  final scope = R99Scope.of(context);
  final p = scope.palette;
  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '关闭对话框',
    barrierColor: Colors.black.withValues(alpha: 0.72),
    transitionDuration: MediaQuery.of(context).disableAnimations ? Duration.zero : R99Motion.enter,
    pageBuilder: (ctx, _, _) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: R99Motion.enterCurve,
        reverseCurve: R99Motion.exitCurve,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.02), end: Offset.zero).animate(curved),
          child: Center(
            child: R99Scope(
              palette: p,
              onPaper: false,
              child: Dialog(
                backgroundColor: p.surfaceSolid,
                insetPadding: const EdgeInsets.all(R99Size.s3),
                shape: RoundedRectangleBorder(
                  borderRadius: r99Radius(R99Size.rPanel),
                  side: BorderSide(color: p.accent, width: R99Size.hair),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(R99Size.s5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      R99Kicker(kicker, accent: true),
                      const SizedBox(height: 8),
                      Text(title, style: TextStyle(fontFamily: R99Text.serif, fontSize: 28, fontWeight: FontWeight.w700, color: p.text)),
                      const SizedBox(height: 12),
                      Text(body, style: TextStyle(fontFamily: R99Text.serif, fontSize: 14, height: 1.8, color: p.textMuted)),
                      const SizedBox(height: R99Size.s4),
                      Row(
                        children: [
                          R99Button(label: confirm, primary: true, onTap: () {
                            Navigator.of(ctx).pop();
                            onConfirm?.call();
                          }),
                          const SizedBox(width: R99Size.s2),
                          R99Button(label: cancel, onTap: () => Navigator.of(ctx).pop()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
