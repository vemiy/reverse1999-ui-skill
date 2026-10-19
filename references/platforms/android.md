# Android（Compose / Views）

## 颜色与主题

不要用 Material 的 `primary/secondary` 语义，直接建一套自己的：

```kotlin
object R99 {
    val Void = Color(0xFF0B0A09)
    val Paper = Color(0xFFE9DCCD)
    val Cream = Color(0xFFFFFDE9)
    val Muted = Color(0xFFC9C2B4)
    val Ink = Color(0xFF171310)
    val Ink2 = Color(0xFF5B544B)
    val Rust = Color(0xFFB55829)
    val RustHi = Color(0xFFDB6F39)
    val Ok = Color(0xFF8EC755)
    val Due = Color(0xFFF56064)
    val Settled = Color(0xFF8C8D8C)
    val Line = Cream.copy(alpha = 0.16f)
}
```

在 `MaterialTheme` 里只覆盖 `colorScheme.surface/onSurface`，其余组件用自己的封装，避免 Material 的默认高度与涟漪。

## 单角圆角

```kotlin
val PanelShape = RoundedCornerShape(topEnd = 30.dp)
val ButtonShape = RoundedCornerShape(topEnd = 10.dp)
```

```kotlin
Box(
    Modifier
        .clip(PanelShape)
        .background(Color.Black.copy(alpha = 0.82f))
        .border(1.dp, R99.Rust, PanelShape)
        .padding(24.dp)
) { … }
```

`border` 要在 `clip` 之后画，否则圆角处会被裁掉一半。

## 按钮

```kotlin
Box(
    Modifier
        .heightIn(min = 46.dp)
        .clip(ButtonShape)
        .then(if (primary) Modifier.background(R99.Rust) else Modifier.border(1.dp, R99.Line, ButtonShape))
        .clickable(
            interactionSource = remember { MutableInteractionSource() },
            indication = null
        ) { onClick() }
        .padding(horizontal = 24.dp, vertical = 12.dp)
) {
    Text("申请调阅", color = R99.Cream, fontFamily = NotoSerif, fontSize = 15.sp, letterSpacing = 1.2.sp)
}
```

- 去掉默认涟漪（`indication = null`），按下态用 `background(R99.RustHi)` 或 0.8 透明度。
- 触控目标至少 48dp；可以用 `Modifier.minimumInteractiveComponentSize()`。

## 字体

```kotlin
val NotoSerif = FontFamily(Font(R.font.noto_serif_sc_medium, FontWeight.Medium))
val Bodoni = FontFamily(Font(R.font.bodoni_moda_regular))
```

- 放在 `res/font/`，文件名小写下划线。
- 数字用 `fontFeatureSettings = "tnum"` 打开等宽数字。
- 中文没字体时回退 `FontFamily.Serif`，不要再回退到默认 sans。

## 动效

```kotlin
val shown by animateFloatAsState(
    targetValue = if (visible) 1f else 0f,
    animationSpec = tween(500, easing = CubicBezierEasing(0.22f, 0.61f, 0.36f, 1f)),
    label = "enter"
)
Modifier.alpha(shown).offset(y = (32 * (1 - shown)).dp)
```

- 退出 350ms，悬停不存在（触屏），按下态只改颜色。
- 尊重 `Settings.Global.ANIMATOR_DURATION_SCALE`：为 0 时直接显示。

## 纹理

把网页的颗粒与雨丝导出成 PNG，放 `drawable-nodpi/`，用 `Image` 平铺（`contentScale = ContentScale.Tile` 需要自定义，或用 `BitmapShader`）：

```kotlin
val grain = ImageBitmap.imageResource(R.drawable.r99_grain)
drawWithCache {
    val shader = ImageShader(grain, TileMode.Repeated, TileMode.Repeated)
    onDrawBehind { drawRect(ShaderBrush(shader), alpha = 0.055f) }
}
```

## Views（非 Compose）

- 背景：`GradientDrawable` 叠两团径向渐变，颗粒用平铺 BitmapDrawable。
- 单角圆角：`ShapeAppearanceModel` 只设 `topRightCornerSize`。
- 描边：`MaterialCardView` 的 stroke 会四角一致，改用 `ViewOutlineProvider` + 前景层画 1dp 线。
