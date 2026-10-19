# 网页（桌面）

## 起步

```html
<html lang="zh-CN" data-theme="dark" data-accent="rust" data-density="standard">
<link rel="stylesheet" href="assets/reverse1999.css">
<script src="assets/fx.js" defer></script>
```

页面结构照 `templates/`：`.r99-shell` 包住每节，正文用 `.r99-prose` 限制宽度。

## 背景层

```html
<div class="r99-atmos" aria-hidden="true"></div>
<div class="r99-rain" aria-hidden="true"></div>
<div class="r99-grain" aria-hidden="true"></div>
<div class="r99-vignette" aria-hidden="true"></div>
```

四层必须在内容之前；内容容器要 `position: relative; z-index: 3`（`.r99-shell` 已带）。
如果不用 `.r99-shell`（例如整页自定义布局），给最外层内容容器加 `position:relative;z-index:3`，否则会被背景层盖住。

## 字体

模板通过 Google Fonts 加载 Bodoni Moda 与 Noto Serif SC。生产环境建议自托管：

```html
<link rel="stylesheet" href="/fonts/fonts.css">
```

`fonts.css` 里用 `@font-face` 指向本地 woff2，`font-display: swap`，只保留实际用到的字重。
中文字体文件大，按需子集化（只保留产品实际出现的字符），否则首屏会明显延迟。

## 主题切换

`fx.js` 会读 `localStorage` 的 `r99-theme`，没有记录时跟随系统。按钮加 `data-r99-theme-toggle`。
要避免闪烁，在 `<head>` 里先同步设置一次 `data-theme`：

```html
<script>
  try {
    var t = localStorage.getItem("r99-theme");
    if (t) document.documentElement.setAttribute("data-theme", t);
  } catch (e) {}
</script>
```

## 四类页面的桌面处理

- **陈列板**：倾斜与叠压都靠 `transform` 做，容器不要改成 `overflow:auto`，否则证件牌与数据卡的越界部分会被裁掉；1240 以下直接隐藏竖排英文与展品注记，不要挤成两行。
- **邮件**：两栏写 `minmax(0,344px) minmax(0,1fr)`，切换只改 `hidden` 与 `aria-current` 并把 `#编号` 写回地址栏，不整页跳转。
- **商城**：购买面板用 `position:sticky` 吸顶，改列数只动 `grid-template-columns`；步进按钮保留原生 `button` 与 `disabled`，键盘和读屏都能用。
- **加载**：满屏容器用 `100svh` 兜底 `100vh`，进度条给 `role="progressbar"` 与 `aria-valuenow`；引文固定右下，窗口变窄时整块落到进度线下方而不是压住门形。

## 常见问题

- **面板半透明看不清**：面板叠在复杂影像上时，把 `--r99-surface` 的不透明度提到 0.9，或给面板加一层 8px 模糊（已经在 `backdrop-filter` 里）。
- **锈红字太细**：锈红只做线；需要强调的文字改成奶白加粗，线保留。
- **打印**：`@media print` 已去掉背景层与页眉；需要页码时在页脚加 `.r99-num`。
- **超长标题**：`text-wrap: balance` 会让两行长度接近，但中文慎用（可能断开词组）；优先手动断行。
