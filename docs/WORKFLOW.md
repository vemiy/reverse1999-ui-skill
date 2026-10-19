# 工作流

一份改动的完整路径：**取数值 → 落代码 → 截图验收 → 提交**。

## 1. 取数值

数值以界面实测为准：设计分辨率 1920×1080，网页按 ×0.75 折算到 1440。仓库不收录取包方法，也不打包任何游戏资源。

## 2. 落代码

- 样式只写进 `assets/`，页面放在 `templates/`。
- 全局样式改 `reverse1999.css`；单页样式单独建文件（`mail.css`、`shop.css`、`loading.css`、`board.css`），避免互相覆盖。
- 硬约束：直角、唯一强调色、1px 细线、按钮只变暗。

## 3. 验收

起预览（禁用缓存）：

```powershell
python tools/preview.py 8124
```

截图与量尺寸：

```powershell
node tools/shot.mjs http://127.0.0.1:8124/templates/shop.html out.png 1440 900 0
node tools/probe.mjs http://127.0.0.1:8124/templates/shop.html "JSON.stringify({w:innerWidth})"
```

看三件事：比例对不对、有没有横向溢出、动效是不是真的在动。动效要用 `probe` 读 `getComputedStyle` 或 `getAnimations()`，肉眼容易误判。

## 4. 提交

- 分三条左右：页面、组件、文档/工具。
- 推送前跑 `node scripts/check-css.mjs`。
- CI 会跑同样检查和 Flutter 三连。

## 委托规则

- 需要看图（截图验收、颜色比例判断）：用带视觉的模型。
- 不需要看图（改数值、写文档、搬代码）：可以用中转站的纯文本模型。
- 委托时写清允许修改的文件，避免两边改同一处。

## 常见坑

| 现象 | 原因 |
| --- | --- |
| 动画在跑但看不见 | 动画元素和静态边框落在同一像素 |
| 点击有反应但页面不动 | 浏览器跑的是旧 HTML，换禁用缓存的预览地址 |
| 固定尺寸把网格挤变形 | 把参考尺寸写成 `width`，应该用 `aspect-ratio` + `max-width` |
