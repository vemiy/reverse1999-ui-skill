# r99_kit

reverse1999-ui 的 Flutter 套件，同时是一个可运行的示例应用：深底、米纸、锈红细线、宋体与 Didone。

## 运行

```sh
flutter pub get
flutter run -d chrome
flutter test
flutter analyze
```

已验证：Flutter 3.47.7 / Dart 3.13.5，`analyze` 0 issue，`test` 3 个用例全过，`build web --release` 通过。

## 结构

```text
lib/
├── main.dart          示例界面：封面、索引、记录、展厅、表格、变体切换
└── r99/
    ├── tokens.dart    调色板、四组强调色、尺寸、时长、单角圆角
    ├── theme.dart     ThemeData 与 R99Scope
    ├── textures.dart  底光、雨丝、颗粒、暗角、钟楼、卡片插画
    ├── widgets.dart   面板、按钮、chip、状态、印章、记录行、卡片、对话框
    └── marks.dart     字标、竖排英文、空心大编号
assets/fonts/          Noto Serif SC 子集（400/700）与 Bodoni Moda（400/600）
```

## 换成自己的产品

改 `main.dart` 的文案与数据，保留部件组合；强调色在 `_VariantBar` 或 `R99App` 里设置；
图片位把 `R99ArtPainter` 换成 `Image.asset`，外层保留 1px 边框与右上圆角。

中文字体换成自己已授权的宋体时，替换 `assets/fonts/` 并改 `pubspec.yaml` 的 family，同时改 `R99Text.serif`。

## 字体

`NotoSerifSC-*.ttf` 是从变量字体裁出的子集，只含示例文案的 458 个字。换文案会缺字，需要重新子集：

```sh
python -m fontTools.subset NotoSerifSC-VF.ttf --text-file=chars.txt --output-file=NotoSerifSC-Regular.ttf
```

许可为 SIL OFL 1.1，见 `assets/fonts/OFL.txt`。
