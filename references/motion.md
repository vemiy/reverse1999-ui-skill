# 动效

这套语言只有五种动作：**淡入、上移、下移、线展开、变暗**。没有弹跳、旋转入场、缩放与视差。

实物在 `templates/motion.html`：每格可单独重放，顶部有「全部重放」；地址加 `?play=1` 会自动依次播放。

## 实现清单

| 动作 | 类名 / 选择器 | 时长 | 缓动 | 触发 |
| --- | --- | --- | --- | --- |
| 区块入场 | `.r99-in`（由 `fx.js` 自动加） | 500ms | `cubic-bezier(.22,.61,.36,1)` | 进入视口一次 |
| 依次入场 | 同上，`--d` 每项 +60ms，最多 6 项 | 500ms | 同上 | 同上 |
| 分段标题上沿线 | `.r99-plate.r99-in::before` | 640ms | 同上 | 附加 `.r99-in` 时；**只画线，标题本身不上移**（`.r99-plate.r99-in` 已覆盖为 `animation: none`） |
| 页签下划线 | `.r99-tabs button::after` | 240ms | 同上 | 切换页签 |
| 对话框进出 | `.r99-dialog:not([hidden])` | 480ms 进 / 350ms 出 | 同上 | 打开、关闭 |
| 提示弹窗 | `.r99-notice` 内三段 | 520ms，正文 +60ms，按钮 +120ms | 同上 | 打开 |
| 底部面板 | `.r99-sheet:not([hidden])` | 480ms（上移 32px） | 同上 | 打开 |
| 提示条 | `.r99-toast` | 320ms | 同上 | 出现 |
| 遮罩 | `.r99-scrim:not([hidden])` | 320ms 淡入 | `linear` | 打开 |
| 跨页切换 | `::view-transition-old/new(root)` | 240 / 320ms | `ease` | 页面跳转（Chrome 126+） |
| 雨丝漂移 | `.r99-rain` | 90s 循环 | `linear` | 常驻 |
| 徽记慢转 | `.r99-spin` | 60s 一圈 | `linear` | 常驻 |
| 结算卡入场 | `.r99-settle__card` | 420ms | `--r99-ease-enter` | 依次 60ms，最多 3 张 |
| 结算数值浮起 | `.r99-settle__num` | 900ms | `--r99-ease-enter` | 卡牌后 240ms，末尾自行淡出 |

悬停与按下不在这张表里，因为它们是状态而不是动效：悬停 `filter: brightness(.97)`，按下 `brightness(.82)`，都是 200ms。

## 结算段（来自游戏录屏）

24.5 秒的录屏里，一段咒语结算分三步：卡牌从右侧滑入并排开 → 伤害数字自下浮起 → 数字停留后上移淡出。落地写法是 `.r99-settle[data-state="run"]`，三个时间点：卡牌 420ms、错开 60ms；数字延后 240ms、总长 900ms，其中 22% 处到位、74% 后开始上移。

不要照抄的地方：录屏里的数字有轻微放大和描边发光，那是战斗特效层的表现，页面里不做；卡牌滑入距离也从屏幕宽度收到 24px。

## 三条编排规则

1. **一组只错开 60ms，最多 6 项**。总延迟不超过 300ms；再多就整组一起出现。
2. **一个区块只入场一次**。`IntersectionObserver` 加类后即 `unobserve`，回到顶部再滚下来也不重播。
3. **退出比进入快**：对话框 480 进 / 350 出，面板同理；退出不带反向位移。

## 减少动效

- `prefers-reduced-motion: reduce`：动画压到 1ms，入场元素直接显示。
- `<html data-motion="calm">`：去掉入场与雨丝，保留悬停、变暗与浮层进出。
- 两种都要测：关掉之后页面必须完整，不能有元素停在 `opacity: 0`。

## 平台对应

| 平台 | 写法 |
| --- | --- |
| 网页 | CSS `@keyframes` + `animation-delay: var(--d)`，见 `assets/reverse1999.css` |
| Flutter | `R99Reveal`（`AnimationController` + `CurvedAnimation`），见 `templates/flutter/lib/r99/widgets.dart` |
| 小程序 | `wx.createAnimation` 或 CSS 动画；`setData` 后一帧再加类 |
| iOS | `UIView.animate(duration: 0.5, curve: .easeOut)` |
| Android | `animateFloatAsState` + `tween(500, CubicBezierEasing(...))` |

跨平台保持三个数一致：500ms、32px、先透明后位移。

## 自检

- [ ] 页面加载后 1 秒内，所有可见内容都已出现，没有停在半透明。
- [ ] 滚动一遍：每个区块只动一次，回滚不重播。
- [ ] 打开/关闭对话框、底部面板、提示条各一次，退出明显比进入快。
- [ ] 悬停与按下都是变暗，没有任何放大或提亮。
- [ ] 打开系统「减少动态效果」，整页仍完整可读。
