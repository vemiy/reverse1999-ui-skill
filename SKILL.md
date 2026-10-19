---
name: reverse1999-ui
description: Build interfaces in the visual language of Reverse: 1999 (重返未来 1999 风格 / 1999 风格 / 复古英伦 / 装饰艺术 / 档案册 / 雨夜). Use when a screen should read like a printed archive rather than a product dashboard: dark photographic ground, cream paper panels, one rust hairline accent, square corners whose shape comes from cut corners, Chinese serif with Didone Latin labels, real record numbers and dates, fades instead of bounces, controls that darken on hover and press. Covers web, mobile web, H5, mini programs, Flutter, iOS and Android. Ships tokens, a CSS kit, a build-verified Flutter kit, page templates, in-game parts, platform guides and screenshots. Uses no game assets and no official fonts.
license: MIT
---

# 1999 风味 UI

一套可执行的界面语言：**深底照片质感、米纸面板、一根锈红细线、宋体配 Didone、编号与日期都是真数据、全部直角靠切角做形状**。
本文件是入口，只放判断与约束；细节在 `references/`，按需打开。

## 30 秒上手

```html
<link rel="stylesheet" href="assets/reverse1999.css">
<script src="assets/fx.js" defer></script>

<body class="r99">
  <div class="r99-atmos" aria-hidden="true"></div>
  <div class="r99-rain" aria-hidden="true"></div>
  <div class="r99-grain" aria-hidden="true"></div>
  <div class="r99-vignette" aria-hidden="true"></div>

  <main class="r99-shell">
    <span class="r99-kicker r99-kicker--accent">Records</span>
    <h1 class="r99-title">记录</h1>
    <div class="r99-panel">内容放在黑玻璃面板里。</div>
  </main>
</body>
```

三条前提：类名一律 `r99-` 前缀；数值从 `assets/tokens.json` 取，不临时发明；四层背景必须在内容之前，内容容器要有 `position: relative; z-index: 3`（`.r99-shell` 已带）。

## 什么时候用，什么时候不用

**用**：资料库、档案、活动页、个人站、内部工具的详情与总览；需要有“印刷品/旧时代”气质、而不是“现代 SaaS”气质的产品。

**不用**：高密度数据表（这套的留白会拖慢扫读）、实时监控大屏（需要更强的色彩编码）、儿童或轻快产品（宋体的重量会压住语气）、需要极高对比主题的政务站点（纸面主题只能做到 5:1 上下）。

## 开工前的四个判断

| 判断 | 取值 | 落在哪 |
| --- | --- | --- |
| 这是给人读、给人找、还是给人盯？ | 卷宗 / 档案库·列表 / 档案库·看板 | 见 `references/patterns.md` |
| 用哪种表面？ | 深色 `void`、深褐 `deep`、米纸 `paper` | `data-theme` |
| 强调色用哪一种？ | 赭红 `rust`（默认）、琥珀、铜绿、暗金 | `data-accent` |
| 图从哪来？ | 自己的照片、自己的插画、或抽象图形 | 没有图就画，不用灰色占位 |

四个判断定完，写一张三行的变体卡放在交付说明最前面。完整维度与预设见 `references/variation.md`。

## 十条硬约束

违反任何一条，这套语言就不成立。

1. 面板、按钮、卡片、输入框、图片框**全部直角**；形状只靠切角（`.r99-cut`）与角花，不用圆角、不用胶囊。全局只有两处例外：提示条的红圈「!」徽记，和战斗复现条右上角 14px。新信息、未读、状态点一律用方块，不用圆点。
2. 一屏只有**一种**强调色，只出现在线、编号、当前项、印章上；不做大面积填充。唯一例外是入场券这类实物道具，整块填色但不超过 420×160。
3. 锈红在深底 4.1:1、在米纸 3.5:1：**不当正文色**，只做线、大字号与图标。
4. 红色只给时间语义（告急、过期、中断）；删除用锈红加二次确认。
5. 中文全部宋体；英文用 Didone 大写宽字距；正文不用黑体、楷体、等宽。
6. 编号、日期、页数、计数一律来自真实数据，用等宽数字；不编造技术感文字。
7. 1px 细线是通用边界；线色为字色的 16%；当前项加粗到 2px 并换强调色。
8. 动效只有淡入与位移：进入 500ms、退出 350ms；悬停变暗 3%、按下变暗 18%，不变亮。
9. 一屏内：网点 ≤ 1 处、竖排英文 ≤ 1 处、锈红标记 ≤ 4 处。
10. 不使用游戏素材、官方字体、标志与立绘；示例数据必须虚构。

## 页面类型与部件

| 类型 | 骨架 | 必用部件 | 参照模板 |
| --- | --- | --- | --- |
| 封面 | 满屏影像 + 竖排英文 + 大字标 + 编号 | 眉标、空心大编号、主次按钮、元数据行 | `templates/showcase.html` |
| 卷宗 | 单栏 40 字宽 + 右栏目录 | 元数据字段对、页签、目录、脚注、上下篇 | `templates/reading.html` |
| 档案库·列表 | 检索 + 筛选 + 网格 | chip、物品卡或记录行、分页 | `templates/library.html` |
| 陈列板 | 档案箱拼贴 + 数据卡 | 证件牌、纸质档案、数据卡、徽章、切角 | `templates/console.html` |
| 手机 | 顶栏 + 主卡 + 列表 + 标签栏 | 主卡片、横滑 chip、底部标签栏、底部面板 | `templates/app.html` |
| 二次确认 | 标题在面板外 + 通栏正文 | 提示弹窗、双宽板按钮 | `templates/specimen.html` |
| 邮件 | 左列表 + 右阅读 | 未读方块、附件条、领取按钮 | `templates/mail.html` |
| 商城 | 货币条 + 商品格 + 购买面板 | 稀有度物品格、数量步进、确认 | `templates/shop.html` |
| 加载 | 满屏门形徽记 + 进度线 | 眉标、进度线、引文、编号 | `templates/loading.html` |

物品卡、角色卡、菱形图标按钮、分段血条、键帽、`SPECIAL` 通栏的写法见 `references/components.md`。

## 最容易做错的六件事

| 现象 | 后果 | 正确做法 |
| --- | --- | --- |
| 给卡片加 8–12px 圆角，觉得“更现代” | 立刻变成普通后台 | 直角；要形状就切角 |
| 悬停把按钮提亮 | 与游戏里的“压下去”相反，界面显得轻浮 | 变暗 3%，按下 18% |
| 锈红做成大色块或渐变横幅 | 4.1:1 撑不住正文，且变成促销页 | 锈红只做线与标记 |
| 英文写口号（ARCHIVE OF SOULS） | 眉标是标签，不是标语 | 写中文标题的直译，或只写编号 |
| 编号随手编 `N-0001` 撑版式 | 用户会当真；删掉也不影响信息 | 用真实编号，没有就不放 |
| 加投影、发光、玻璃拟态 | 与纸张质感打架 | 只有模态层允许大半径阴影 |

## 自检

- [ ] 全部直角，切角只切一个角；没有胶囊与圆角卡片。
- [ ] 只有一种强调色，且只在线、编号、当前项、印章上。
- [ ] 中文宋体、英文 Didone 大写；数字等宽。
- [ ] 编号、日期、计数都能在数据里对上。
- [ ] 深色与纸面两套都看过；360–430 宽无横向滚动。
- [ ] 悬停与按下都是变暗；滚动一次每个区块只入场一次；减少动效后页面完整。
- [ ] 键盘焦点可见，触控区 ≥ 44pt，读屏能读出当前项。
- [ ] 没有任何游戏素材与官方字体。

## 参考地图

| 文件 | 什么时候读 |
| --- | --- |
| `assets/tokens.json` | 取任何数值之前 |
| `assets/reverse1999.css` | 直接用套件时；想知道某个类的默认值 |
| `references/research.md` | 需要知道某个数值的依据，或要判断什么能借什么不能 |
| `references/tokens.md` | 调色、调对比度、加稀有度、跨平台换算 |
| `references/components.md` | 写具体部件、拿不准某个部件的含义与禁忌 |
| `references/patterns.md` | 排一屏之前；手机端与空/错状态 |
| `references/motion.md` | 加动效、做过渡、处理减少动效 |
| `references/variation.md` | 定变体、做变体卡、推新部件 |
| `references/rules.md` | 想为某个例外找理由时；先看这里能不能被说服 |
| `references/glossary.md` | 写界面文案前，避免把内部术语写进产品 |
| `references/platforms/` | 落地到 Flutter、iOS、Android、小程序、跨端 |
| `docs/WORKFLOW.md` | 动手前看流程：取数值、落代码、截图验收、提交 |
| `tools/` | 预览服务、截图、页面探针、资源导出脚本 |
| `templates/` | 需要一份能跑的组合参考 |
| `examples/` | 交付前对照，看“应该长成什么样” |

## 来源与授权

- 非官方风格研究，与权利方无隶属或授权关系；名称仅用于指代参考对象。
- 不含游戏素材：无贴图、立绘、截图、音频或官方字体；示例图由本项目渲染，插画自绘。
- 尺寸、色值与切边来自对界面本身的测量，只用于实现一致风格。
- 字体为 SIL OFL 的 Noto Serif SC 与 Bodoni Moda。
- 代码与规则以 MIT 发布；再分发请保留本节。
