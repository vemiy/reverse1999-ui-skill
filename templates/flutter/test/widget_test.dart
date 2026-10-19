import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:r99_kit/main.dart';
import 'package:r99_kit/r99/motion.dart';
import 'package:r99_kit/r99/theme.dart';
import 'package:r99_kit/r99/tokens.dart';
import 'package:r99_kit/r99/widgets.dart';

void main() {
  void useLargeSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1440, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Widget harness(Widget Function(BuildContext) build, {bool reduce = false}) {
    return MaterialApp(
      builder: (ctx, child) => reduce
          ? MediaQuery(
              data: MediaQuery.of(ctx).copyWith(disableAnimations: true),
              child: child!,
            )
          : child!,
      home: R99Scope(
        palette: R99Palette.dark,
        onPaper: false,
        child: Scaffold(
          backgroundColor: R99Palette.dark.bg,
          body: Builder(
            builder: (ctx) => Center(child: build(ctx)),
          ),
        ),
      ),
    );
  }

  testWidgets('封面与档案行正常渲染', (tester) async {
    useLargeSurface(tester);
    await tester.pumpWidget(const R99App());
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('夜航档案室'), findsOneWidget);
    expect(find.text('雨停之前\n把旧世界存下来'), findsOneWidget);
    expect(find.text('N-0421'), findsWidgets);
    expect(find.text('已归档'), findsWidgets);
  });

  testWidgets('可以切换主题并保持内容可读', (tester) async {
    useLargeSurface(tester);
    await tester.pumpWidget(const R99App());
    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.text('明暗').first);
    await tester.pumpAndSettle();

    expect(find.text('雨停之前\n把旧世界存下来'), findsOneWidget);
    expect(find.text('未登记'), findsNothing);
  });

  testWidgets('筛选面板可以打开并关闭', (tester) async {
    useLargeSurface(tester);
    await tester.pumpWidget(
      harness((ctx) => R99Button(
            label: '筛选',
            onTap: () => showR99Sheet(
              ctx,
              kicker: 'Filter',
              title: '筛选卷宗',
              children: const [R99Chip('全部', selected: true), R99Chip('待核')],
            ),
          )),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('筛选'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('筛选卷宗'), findsOneWidget);
    expect(find.text('全部'), findsOneWidget);

    await tester.tap(find.text('取消'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('筛选卷宗'), findsNothing);
  });

  testWidgets('提示条出现后自动消失', (tester) async {
    useLargeSurface(tester);
    await tester.pumpWidget(
      harness((ctx) => R99Button(
            label: '复制',
            onTap: () => showR99Toast(ctx, '编号 N-0421 已复制'),
          )),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('复制'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('已复制'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('已复制'), findsNothing);
  });

  testWidgets('系统减弱动效时直接显示内容', (tester) async {
    tester.view.physicalSize = const Size(1440, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      harness((ctx) => const R99Enter(offset: 32, child: Text('已入档')), reduce: true),
    );
    await tester.pump();

    expect(find.text('已入档'), findsOneWidget);
    expect(
      find.ancestor(of: find.text('已入档'), matching: find.byType(Opacity)),
      findsNothing,
    );
  });

  testWidgets('复现条按规格渲染', (tester) async {
    useLargeSurface(tester);
    await tester.pumpWidget(harness((_) => const R99ReplayStrip(inline: true)));
    await tester.pumpAndSettle();

    expect(find.text('行为复现中'), findsOneWidget);
    expect(find.text('BATTLE REPLAYING'), findsOneWidget);

    final shell = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration! as BoxDecoration).borderRadius ==
              const BorderRadius.only(topRight: Radius.circular(14)),
    );
    expect(shell, findsOneWidget);

    final shellWidget = tester.widget<Container>(shell);
    expect(shellWidget.padding, const EdgeInsets.symmetric(horizontal: 20, vertical: 14));

    final dots = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.constraints == const BoxConstraints.tightFor(width: 7, height: 7),
    );
    expect(dots, findsNWidgets(3));
  });

  testWidgets('新信息方块是正方形并可带数字', (tester) async {
    useLargeSurface(tester);
    await tester.pumpWidget(harness((_) => const R99Unread()));
    expect(tester.getSize(find.byType(R99Unread)), const Size(8, 8));

    await tester.pumpWidget(
      harness(
        (_) => const Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(width: 60, height: 40),
            R99Unread(count: '3', corner: true),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('3'), findsOneWidget);
    final size = tester.getSize(find.byType(R99Unread));
    expect(size.height, 16);
    expect(size.width, greaterThanOrEqualTo(16));
  });
}
