# 跨平台（React Native / Electron / Tauri）

## React Native

```ts
export const r99 = {
  void: "#0B0A09",
  paper: "#E9DCCD",
  cream: "#FFFDE9",
  muted: "#C9C2B4",
  ink: "#171310",
  rust: "#B55829",
  line: "rgba(255,253,233,0.16)",
  radius: { btn: 10, card: 20, panel: 30 },
};
```

- **单角圆角**：RN 支持 `borderTopRightRadius`，其它三角写 0。Android 上写 0 的角仍可能有一像素圆边，加 `overflow: "hidden"` 解决。
- **字体**：`fontFamily: Platform.select({ ios: "NotoSerifSC-Medium", android: "noto_serif_sc_medium" })`；两次引用同一个字体文件，文件名按各平台命名规则放。
- **阴影**：不要用 `shadowOpacity`；面板靠 1px 描边与半透明底，阴影只在模态层用一层大半径黑色。
- **动效**：`Animated.timing(value, { toValue: 1, duration: 500, easing: Easing.out(Easing.cubic), useNativeDriver: true })`，位移 `translateY: value.interpolate({ inputRange: [0,1], outputRange: [32, 0] })`。
- **竖排英文**：RN 不支持 `writing-mode`，用 `transform: [{ rotate: "-90deg" }]` 的 Text，或逐字渲染一列。
- **纹理**：用一张可平铺 PNG（`resizeMode="repeat"`）铺满全屏，`pointerEvents="none"`。

## Electron / Tauri

直接复用网页套件：

```html
<link rel="stylesheet" href="assets/reverse1999.css">
<div class="r99-atmos"></div>
<div class="r99-rain"></div>
<div class="r99-grain"></div>
<div class="r99-vignette"></div>
```

- 桌面窗口没有滚动条时，`body.r99` 的 `overflow-x: hidden` 仍然需要，防止窗口缩小时出现横向抖动。
- 用系统标题栏时，窗口背景设成 `#0B0A09`，避免加载瞬间白闪。
- Tauri 的 `transparent: true` 与 `backdrop-filter` 一起用会掉帧，二选一。

## 与网页的差异清单

| 网页 | 原生 | 处理 |
| --- | --- | --- |
| `backdrop-filter` | 部分平台不支持 | 退化为 90% 不透明纯色 |
| `feTurbulence` | 不支持 | 预渲染 PNG 平铺 |
| `writing-mode` | RN 不支持 | 旋转容器 |
| `:focus-visible` | 无 | 键盘导航平台另做焦点框 |
| `prefers-reduced-motion` | 有对应系统设置 | 读系统开关 |
| `tabular-nums` | 有的平台默认不开 | iOS `.monospacedDigit()`，Android `"tnum"` |

## 一致性验收

同一屏在三个平台并排看，必须满足：

1. 强调色只在线与编号上，三端位置一致；
2. 只圆一个角，且是同一个角（默认右上）；
3. 中文是宋体，英文是 Didone 大写，字距一致；
4. 编号与日期等宽对齐；
5. 进入动画同为 500ms、32px、先透明后位移。
