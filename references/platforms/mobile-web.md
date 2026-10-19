# 手机网页（H5 / PWA）

## 起步

```html
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#0b0a09">
```

结构照 `templates/app.html`：`.r99-app`（最大 430，居中）+ `.r99-topbar` + 内容 + `.r99-tabbar`。

## 三条硬约束

1. **点击区 ≥ 44pt**：`.r99-btn` 默认 46px 高；图标按钮也加 `min-height:44px`。
2. **不横向滚动**：`body.r99` 已 `overflow-x:hidden`；横滑筛选用 `overflow-x:auto` 且 `white-space:nowrap`。
3. **底部留白**：内容容器 `padding-bottom: 88px`，避开标签栏；标签栏 `padding-bottom: env(safe-area-inset-bottom)`。

## 四类页面的手机处理

- **陈列板**：双栏在 900 塌成单列，展品居中、数据卡去掉左右错位改满宽；证件牌缩小后仍要留 44px 点击区，倾斜的容器不要加 `overflow:hidden`。
- **邮件**：列表与阅读区在 900 以下上下堆叠；切换后焦点交给阅读区标题且不强制滚动；附件条的领取按钮整行落到下方，高度保持 46px。
- **商城**：商品格两列、分区导航改横滑；购买面板从吸顶改成静态跟在网格后，数量步进按钮 44×44 不可再小。
- **加载**：门形收到 200–240 宽，引文落到进度线下方并左对齐，竖排英文隐藏；满屏容器底部留 `env(safe-area-inset-bottom)`，别让进度线被手势区压住。

## 底部面板

```html
<div class="r99-scrim" id="scrim" hidden></div>
<div class="r99-sheet" role="dialog" aria-modal="true" aria-labelledby="sheet-title" id="sheet" data-r99-scrim="scrim" hidden>
  <div class="r99-sheet__grip" aria-hidden="true"></div>
  …
</div>
```

触发按钮写 `data-r99-open="sheet"`，关闭按钮写 `data-r99-close`；`fx.js` 负责显示、Esc 关闭与焦点。

## 手机上的取舍

- 记录行隐藏日期列（CSS 已处理），编号与状态必须保留。
- 卡片网格改单列时，图从 3:4 改成 16:9，减少滚动。
- 大字标在手机上降到 26–32px，行高 1.15；不要用 `clamp` 的桌面上限。
- 首屏影像高度控制在 40vh 内，否则第一屏看不到任何可操作的东西。

## PWA

- `theme-color` 与页面底色一致，避免状态栏出现色带。
- 离线页沿用空状态写法：一句说明 + 一个「重试」。
- 图标用单色线条标记，不要带锈红底（系统会再裁一次圆角）。
