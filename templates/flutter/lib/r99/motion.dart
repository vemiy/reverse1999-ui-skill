import 'dart:async';

import 'package:flutter/material.dart';

import 'theme.dart';
import 'tokens.dart';
import 'widgets.dart';

/// 入场：淡入 + 位移，尊重系统减弱动效设置。
class R99Enter extends StatelessWidget {
  const R99Enter({
    super.key,
    required this.child,
    this.offset = 10,
    this.duration = R99Motion.enter,
    this.curve = R99Motion.enterCurve,
  });

  final Widget child;
  final double offset;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: curve,
      builder: (context, t, inner) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.translate(offset: Offset(0, offset * (1 - t)), child: inner),
      ),
      child: child,
    );
  }
}

/// 底部面板：自下而上 32px + 淡入。
Future<void> showR99Sheet(
  BuildContext context, {
  required String kicker,
  required String title,
  required List<Widget> children,
  String confirm = '应用',
  VoidCallback? onConfirm,
}) {
  final palette = R99Scope.of(context).palette;
  final reduce = MediaQuery.of(context).disableAnimations;
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: '关闭面板',
    barrierColor: Colors.black.withValues(alpha: 0.72),
    transitionDuration: reduce ? Duration.zero : R99Motion.enter,
    pageBuilder: (ctx, _, _) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: R99Motion.enterCurve,
        reverseCurve: R99Motion.exitCurve,
      );
      return Align(
        alignment: Alignment.bottomCenter,
        child: FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.18), end: Offset.zero).animate(curved),
            child: R99Scope(
              palette: palette,
              onPaper: true,
              child: _R99SheetBody(
                kicker: kicker,
                title: title,
                confirm: confirm,
                onConfirm: onConfirm,
                children: children,
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _R99SheetBody extends StatelessWidget {
  const _R99SheetBody({
    required this.kicker,
    required this.title,
    required this.children,
    required this.confirm,
    this.onConfirm,
  });

  final String kicker;
  final String title;
  final List<Widget> children;
  final String confirm;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 620),
      padding: EdgeInsets.fromLTRB(
        R99Size.s4,
        R99Size.s3,
        R99Size.s4,
        R99Size.s4 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: scope.palette.paper,
        border: Border(top: BorderSide(color: scope.palette.accent, width: R99Size.strong)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 2,
              color: scope.lineStrong,
            ),
          ),
          const SizedBox(height: R99Size.s3),
          R99Kicker(kicker, accent: true),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontFamily: R99Text.serif,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: scope.fg,
            ),
          ),
          const SizedBox(height: R99Size.s3),
          ...children,
          const SizedBox(height: R99Size.s4),
          Row(
            children: [
              R99Button(
                label: confirm,
                primary: true,
                onTap: () {
                  Navigator.of(context).pop();
                  onConfirm?.call();
                },
              ),
              const SizedBox(width: R99Size.s2),
              R99Button(label: '取消', onTap: () => Navigator.of(context).pop()),
            ],
          ),
        ],
      ),
    );
  }
}

/// 提示条：淡入 + 上移 12px，2.4 秒后自动消失。
void showR99Toast(BuildContext context, String message) {
  final palette = R99Scope.of(context).palette;
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (ctx) => R99Scope(
      palette: palette,
      onPaper: false,
      child: _R99Toast(
        message: message,
        onDone: () => entry.remove(),
      ),
    ),
  );
  overlay.insert(entry);
}

class _R99Toast extends StatefulWidget {
  const _R99Toast({required this.message, required this.onDone});

  final String message;
  final VoidCallback onDone;

  @override
  State<_R99Toast> createState() => _R99ToastState();
}

class _R99ToastState extends State<_R99Toast> {
  double _opacity = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _opacity = 1);
    });
    _timer = Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      setState(() => _opacity = 0);
      Timer(const Duration(milliseconds: 320), widget.onDone);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    const iconColor = Color(0xFFB0472F);
    return Positioned(
      top: MediaQuery.of(context).padding.top + R99Size.s4,
      right: R99Size.s4,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: reduce ? Duration.zero : const Duration(milliseconds: 320),
          curve: R99Motion.enterCurve,
          child: AnimatedSlide(
            offset: _opacity == 0 ? const Offset(0, -0.2) : Offset.zero,
            duration: reduce ? Duration.zero : const Duration(milliseconds: 320),
            curve: R99Motion.enterCurve,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.symmetric(
                horizontal: R99Size.s3,
                vertical: R99Size.s3,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF2ECE6), Color(0xFFE9DCD2)],
                ),
                borderRadius: BorderRadius.zero,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: iconColor, width: 2),
                    ),
                    child: const Text(
                      '!',
                      style: TextStyle(
                        fontFamily: R99Text.display,
                        fontSize: 24,
                        height: 1,
                        fontWeight: FontWeight.w700,
                        color: iconColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        fontFamily: R99Text.serif,
                        fontSize: 19,
                        height: 1.55,
                        letterSpacing: 0.5,
                        color: Color(0xFF2A2320),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
