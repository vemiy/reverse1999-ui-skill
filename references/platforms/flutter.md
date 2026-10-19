# Flutter

`templates/flutter/` 是可运行、已编译验证的套件。这一篇讲怎么把它用进真实产品。

## 起步

```sh
cp -r templates/flutter/lib/r99 <你的项目>/lib/
cp -r templates/flutter/assets/fonts <你的项目>/assets/
```

`pubspec.yaml` 里登记字体（family 名必须与 `R99Text.serif / display` 一致）：

```yaml
flutter:
  fonts:
    - family: NotoSerifSC
      fonts:
        - asset: assets/fonts/NotoSerifSC-Regular.ttf
        - asset: assets/fonts/NotoSerifSC-Bold.ttf
          weight: 700
    - family: BodoniModa
      fonts:
        - asset: assets/fonts/BodoniModa-400.ttf
        - asset: assets/fonts/BodoniModa-600.ttf
          weight: 600
```

## 接管主题

```dart
final palette = R99Palette.dark.copyWith(
  accent: R99Accents.values['rust']!,
  accentBright: R99Accents.bright['rust']!,
);

MaterialApp(
  theme: buildR99Theme(palette),
  home: R99Scope(
    palette: palette,
    onPaper: false,
    child: const YourHomePage(),
  ),
);
```

`R99Scope` 是必须的：所有部件都从它读颜色。只包在 `MaterialApp` 外面会导致 `Theme.of` 与 scope 不一致。

## 纸面

```dart
R99PaperPanel(
  builder: (inner) {
    final paper = R99Scope.of(inner);   // 这里拿到的是墨色系
    return Column(children: [Text('预约阅览室', style: TextStyle(color: paper.fg))]);
  },
)
```

## 动效

```dart
R99Reveal(
  delay: const Duration(milliseconds: 60),
  child: YourCard(),
)
```

- 进入 500ms / 32px；退出用 `AnimatedOpacity` 350ms。
- 系统「减少动态效果」时 `R99Reveal` 直接渲染，不要自己再判断一次。
- 列表错开 60ms，超过 6 个就整组一起出现。

## 纹理

`R99Backdrop` 画三层：径向底光、雨丝（`CustomPainter` 逐线）、颗粒（约 2000 个 0.7px 点）。
低端机可以把颗粒关掉：`R99Backdrop(showGrain: false)`（在 `textures.dart` 里加一个开关），只保留底光与雨丝。

封面与卡片插画都是 `CustomPainter`，不依赖图片资源；换成真实图片时，外层保留 1px 边框与右上圆角即可。

## 常见偏差

| 现象 | 原因 | 处理 |
| --- | --- | --- |
| 中文变黑体 | 字体没登记或 family 名不一致 | 检查 `pubspec.yaml` 的 family 与 `R99Text.serif` |
| 纸面板文字发白 | 内容没用 `builder` 里的 `paper` 取色 | 用 `R99Scope.of(inner)` |
| 圆角四角都圆 | 用了 `BorderRadius.circular` | 改 `BorderRadius.only(topRight: …)` |
| 拖动时出现灰色水波纹 | Material 默认 splash | `ThemeData(splashFactory: NoSplash.splashFactory)` |
| 文本被截断 | 行高与固定高度冲突 | 用 `IntrinsicHeight` 或去掉固定高度 |
