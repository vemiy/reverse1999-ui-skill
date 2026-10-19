# 小程序

## 起步

小程序没有 CSS 变量继承的完整支持（基础库 2.0+ 支持 `var()`，但组件内隔离），建议把 token 直接写成 SCSS 变量或 `rpx` 常量。

```scss
$bg: #0b0a09;
$paper: #e9dccd;
$text: #fffde9;
$muted: #c9c2b4;
$accent: #b55829;
$line: rgba(233, 220, 205, 0.16);
$radius-lg: 60rpx; // 30px × 2
```

换算：CSS px × 2 = rpx（750 设计稿）。间距 4/8/16/24/40/64 对应 8/16/32/48/80/128 rpx。

## 对应关系

| 网页 | 小程序 |
| --- | --- |
| `.r99-panel` 的 `backdrop-filter` | 不支持，改用 `rgba(0,0,0,.9)` 纯色 |
| `.r99-grain` 的 SVG 噪声 | 改用一张 160×160 PNG 平铺，`background-repeat: repeat` |
| `writing-mode: vertical-rl` | 支持，但用绝对定位更稳；或用 4 个单字竖排 |
| `position: sticky` | 支持 `position: sticky`（基础库 2.7+）；否则用 `position: fixed` + 占位 |
| `:focus-visible` | 不支持，用 `hover-class` 或自定义 `data-active` |
| `IntersectionObserver` | 用 `wx.createIntersectionObserver` |
| `prefers-reduced-motion` | 读不到，改为设置项里的「减少动效」开关 |

## 组件写法

- 圆角仍然只圆一个角：`border-radius: 0 60rpx 0 0`。
- 按钮用 `button` 时记得清掉默认样式：`button::after { border: none }`，并设 `background: transparent`。
- 底部标签栏用自定义 `tabBar`（`custom: true`），否则系统栏会盖住锈红短线。
- 输入框 `placeholder-class` 单独定义颜色，保证对比度。

## 注意

小程序里 **不要** 用大面积模糊与多层固定背景，低端机掉帧明显。背景层保留「底光 + 颗粒」两层即可，雨丝可以去掉。
