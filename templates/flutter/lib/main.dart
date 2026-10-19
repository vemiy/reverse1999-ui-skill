import 'package:flutter/material.dart';

import 'r99/marks.dart';
import 'r99/motion.dart';
import 'r99/textures.dart';
import 'r99/theme.dart';
import 'r99/tokens.dart';
import 'r99/widgets.dart';

void main() => runApp(const R99App());

class R99App extends StatefulWidget {
  const R99App({super.key});

  @override
  State<R99App> createState() => _R99AppState();
}

class _R99AppState extends State<R99App> {
  bool _dark = true;
  String _accent = 'rust';

  @override
  Widget build(BuildContext context) {
    final base = _dark ? R99Palette.dark : R99Palette.light;
    final palette = base.copyWith(
      accent: R99Accents.values[_accent],
      accentBright: R99Accents.bright[_accent],
    );

    return R99Scope(
      palette: palette,
      onPaper: false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 're1999-ui · Flutter',
        theme: buildR99Theme(palette),
        home: R99Showcase(
          dark: _dark,
          accent: _accent,
          onToggleTheme: () => setState(() => _dark = !_dark),
          onPickAccent: (value) => setState(() => _accent = value),
        ),
      ),
    );
  }
}

class R99Showcase extends StatelessWidget {
  const R99Showcase({
    super.key,
    required this.dark,
    required this.accent,
    required this.onToggleTheme,
    required this.onPickAccent,
  });

  final bool dark;
  final String accent;
  final VoidCallback onToggleTheme;
  final ValueChanged<String> onPickAccent;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Scaffold(
      body: R99Backdrop(
        palette: scope.palette,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: R99Size.maxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: R99Size.s4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Masthead(onToggleTheme: onToggleTheme),
                    const SizedBox(height: R99Size.s3),
                    _Cover(dark: dark),
                    const SizedBox(height: R99Size.s3),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: R99ReplayStrip(inline: true),
                    ),
                    _Section(
                      plate: const R99Plate(number: '01', en: 'Index', title: '三个入口'),
                      child: const _Cards(),
                    ),
                    _Section(
                      plate: const R99Plate(number: '02', en: 'Records', title: '最近入档'),
                      child: const _Records(),
                    ),
                    _Section(
                      plate: const R99Plate(number: '03', en: 'Gallery', title: '展厅'),
                      child: const _Gallery(),
                    ),
                    _Section(
                      plate: const R99Plate(number: '04', en: 'Service', title: '阅览与复制'),
                      child: const _ServiceTable(),
                    ),
                    _VariantBar(accent: accent, onPick: onPickAccent),
                    const SizedBox(height: R99Size.s6),
                    const _Footer(),
                    const SizedBox(height: R99Size.s5),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Masthead extends StatelessWidget {
  const _Masthead({required this.onToggleTheme});
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: R99Size.s3),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: scope.line, width: R99Size.hair)),
      ),
      child: Row(
        children: [
          const R99Logo(),
          const Spacer(),
          if (MediaQuery.sizeOf(context).width > 760)
            Row(
              children: [
                for (final item in ['索引', '档案', '展厅', '服务'])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontFamily: R99Text.serif,
                        fontSize: 14,
                        letterSpacing: 1.4,
                        color: scope.fgMuted,
                      ),
                    ),
                  ),
                const SizedBox(width: R99Size.s2),
              ],
            ),
          R99Button(label: '明暗', onTap: onToggleTheme),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.dark});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    final p = scope.palette;
    final narrow = MediaQuery.sizeOf(context).width < 760;

    return ClipRect(
      child: SizedBox(
        height: narrow ? 640 : 600,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: R99ScenePainter(palette: p)),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: dark
                      ? [p.bg.withValues(alpha: 0.94), p.bg.withValues(alpha: 0.18)]
                      : [p.bg.withValues(alpha: 0.97), p.bg.withValues(alpha: 0.4)],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                narrow ? R99Size.s3 : R99Size.s4,
                R99Size.s6,
                narrow ? R99Size.s3 : R99Size.s4,
                R99Size.s5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const R99Reveal(child: R99Kicker('Reverse Archive · Est. 1999', accent: true)),
                  const SizedBox(height: R99Size.s3),
                  R99Reveal(
                    delay: const Duration(milliseconds: 80),
                    child: Text(
                      '雨停之前\n把旧世界存下来',
                      style: TextStyle(
                        fontFamily: R99Text.serif,
                        fontSize: narrow ? 36 : 56,
                        height: 1.14,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w700,
                        color: scope.fg,
                      ),
                    ),
                  ),
                  const SizedBox(height: R99Size.s2),
                  R99Reveal(
                    delay: const Duration(milliseconds: 160),
                    child: Text(
                      'THE NIGHT ARCHIVE',
                      style: TextStyle(
                        fontFamily: R99Text.display,
                        fontSize: 11,
                        letterSpacing: 7,
                        color: scope.fgMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: R99Size.s4),
                  R99Reveal(
                    delay: const Duration(milliseconds: 220),
                    child: SizedBox(
                      width: narrow ? double.infinity : 430,
                      child: Text(
                        '一九九九年最后一天的记录、照片与口述，按卷宗编号归档。每一份都可以按日期、地点与经手人查回来。',
                        style: TextStyle(
                          fontFamily: R99Text.serif,
                          fontSize: 15,
                          height: 2,
                          color: scope.fgMuted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: R99Size.s5),
                  R99Reveal(
                    delay: const Duration(milliseconds: 300),
                    child: Wrap(
                      spacing: R99Size.s2,
                      runSpacing: R99Size.s2,
                      children: [
                        R99Button(
                          label: '开始检索',
                          en: 'Search',
                          primary: true,
                          onTap: () => showR99Toast(context, '检索已开始：正在比对 1,024 份卷宗。'),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            R99Button(
                              label: '信箱',
                              en: 'Inbox',
                              onTap: () => showR99Toast(context, '3 封新信息，最近一封来自钟楼管理员。'),
                            ),
                            const R99Unread(count: '3', corner: true),
                          ],
                        ),
                        R99Button(
                          label: '复制编号',
                          en: 'Copy',
                          onTap: () => showR99Sheet(
                            context,
                            kicker: 'Filter',
                            title: '筛选卷宗',
                            children: [
                              Wrap(
                                spacing: R99Size.s2,
                                runSpacing: R99Size.s2,
                                children: const [
                                  R99Chip('全部', selected: true),
                                  R99Chip('建筑'),
                                  R99Chip('电台'),
                                  R99Chip('天气'),
                                  R99Chip('待核'),
                                ],
                              ),
                              const SizedBox(height: R99Size.s3),
                              const R99Field(label: '范围', value: '1999.01 — 1999.12'),
                              const SizedBox(height: R99Size.s2),
                              const R99Field(label: '排序', value: '按编号升序'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: R99Size.s5),
                  const R99Reveal(
                    delay: Duration(milliseconds: 360),
                    child: R99Meta(['卷宗 1,024', '更新 1999.12.31', '对外开放']),
                  ),
                ],
              ),
            ),
            if (!narrow)
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    R99VerticalText('Archive of the last day', color: scope.fgMuted),
                    const SizedBox(height: R99Size.s4),
                    R99OutlinedNumber('01', size: 84, color: scope.fgMuted.withValues(alpha: 0.55)),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.plate, required this.child});
  final Widget plate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: R99Size.s6, bottom: R99Size.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [plate, const SizedBox(height: R99Size.s4), child],
      ),
    );
  }
}

class _Cards extends StatelessWidget {
  const _Cards();

  @override
  Widget build(BuildContext context) {
    const items = [
      (R99ArtKind.arch, '建筑与街景', '雨前的拱廊、剧院与钟楼，按街区编号排布。'),
      (R99ArtKind.radio, '电台与口述', '深夜频段的录音整理，附说话人、时长与频率。'),
      (R99ArtKind.clock, '时间与天气', '暴雨前后的气象记录、钟表校准与日期争议。'),
    ];
    final narrow = MediaQuery.sizeOf(context).width < 900;
    final scope = R99Scope.of(context);

    final cards = [
      for (var i = 0; i < items.length; i++)
        R99Reveal(
          delay: Duration(milliseconds: 60 * i),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              R99RecordCard(
                kind: items[i].$1,
                number: 'N-0${421 - i * 3}',
                date: '1999.12.${31 - i * 2}',
                title: items[i].$2,
                status: i == 1 ? '待核' : '已归档',
                statusKind: i == 1 ? R99StatusKind.due : R99StatusKind.ok,
              ),
              const SizedBox(height: R99Size.s2),
              Text(
                items[i].$3,
                style: TextStyle(
                  fontFamily: R99Text.serif,
                  fontSize: 13,
                  height: 1.7,
                  color: scope.fgMuted,
                ),
              ),
            ],
          ),
        ),
    ];

    if (narrow) {
      return Column(
        children: [
          for (final card in cards) ...[card, const SizedBox(height: R99Size.s4)],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i != cards.length - 1) const SizedBox(width: R99Size.s3),
        ],
      ],
    );
  }
}

class _Records extends StatelessWidget {
  const _Records();

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 900;

    const list = Column(
      children: [
        R99Row(number: 'N-0421', date: '1999.12.31', name: '钟楼最后一次报时', status: '已归档'),
        R99Row(number: 'N-0418', date: '1999.12.30', name: '东区积水深度记录', status: '已归档'),
        R99Row(number: 'N-0417', date: '1999.12.29', name: '电台深夜频段中断', status: '待核', kind: R99StatusKind.due),
        R99Row(number: 'N-0409', date: '1999.12.24', name: '剧院散场口述（三人）', status: '已归档'),
        R99Row(number: 'N-0402', date: '1999.12.17', name: '雨具借用登记簿', status: '已封存', kind: R99StatusKind.settled),
      ],
    );

    final panel = R99PaperPanel(
      builder: (inner) {
        final paper = R99Scope.of(inner);
        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const R99Kicker('Reading room', accent: true),
          const SizedBox(height: 8),
          Text(
            '预约阅览室',
            style: TextStyle(
              fontFamily: R99Text.serif,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: paper.fg,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '纸质原件只在工作日下午开放。留下邮箱，我们会把可预约的时段发给你。',
            style: TextStyle(
              fontFamily: R99Text.serif,
              fontSize: 13,
              height: 1.8,
              color: paper.fgMuted,
            ),
          ),
          const SizedBox(height: R99Size.s4),
          TextField(
            decoration: InputDecoration(
              hintText: 'name@example.com',
              hintStyle: TextStyle(
                fontFamily: R99Text.serif,
                fontSize: 14,
                color: paper.fgMuted.withValues(alpha: 0.7),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: paper.line, width: R99Size.hair),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: paper.palette.accent, width: R99Size.hair),
              ),
            ),
            style: TextStyle(fontFamily: R99Text.serif, fontSize: 14, color: paper.fg),
          ),
          const SizedBox(height: R99Size.s4),
          R99Button(
            label: '登记',
            en: 'Register',
            primary: true,
            expand: true,
            onTap: () => showR99Dialog(
              context,
              kicker: 'Register',
              title: '已登记',
              body: '确认邮件会在一个工作日内寄出。原件只在工作日下午调阅，请带好证件。',
              confirm: '好',
            ),
          ),
          const SizedBox(height: R99Size.s4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const R99Stamp('Admit one'),
              const Spacer(),
              Text(
                '1999',
                style: TextStyle(
                  fontFamily: R99Text.display,
                  fontSize: 34,
                  color: paper.palette.accent,
                ),
              ),
            ],
          ),
        ],
      );
      },
    );

    if (narrow) {
      return Column(children: [list, const SizedBox(height: R99Size.s4), panel]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: list),
        const SizedBox(width: R99Size.s5),
        Expanded(flex: 3, child: panel),
      ],
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery();

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    final narrow = MediaQuery.sizeOf(context).width < 900;

    final figure = Container(
      height: 260,
      decoration: BoxDecoration(
        border: Border.all(color: scope.line, width: R99Size.hair),
        borderRadius: r99Radius(R99Size.rCard),
      ),
      child: ClipRRect(
        borderRadius: r99Radius(R99Size.rCard),
        child: CustomPaint(painter: R99ScenePainter(palette: scope.palette)),
      ),
    );

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '一场雨的分寸',
          style: TextStyle(
            fontFamily: R99Text.serif,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: scope.fg,
          ),
        ),
        const SizedBox(height: R99Size.s3),
        Text(
          '档案室收藏的不是灾难，是灾难前后人们仍在过日子的证据。一张借伞登记、一段报时、一次散场，比任何宏大叙述都更接近那个夜晚。',
          style: TextStyle(
            fontFamily: R99Text.serif,
            fontSize: 15,
            height: 2,
            color: scope.fgMuted,
          ),
        ),
        const SizedBox(height: R99Size.s4),
        Container(
          padding: const EdgeInsets.only(left: R99Size.s3),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: scope.palette.accent, width: R99Size.strong)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '雨落在窗上，城市就变成一张底片。',
                style: TextStyle(fontFamily: R99Text.serif, fontSize: 17, height: 1.8, color: scope.fg),
              ),
              const SizedBox(height: 4),
              Text(
                '—— 馆员手记，第 4 卷',
                style: TextStyle(
                  fontFamily: R99Text.display,
                  fontSize: 11,
                  letterSpacing: 1.6,
                  color: scope.fgMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (narrow) {
      return Column(children: [figure, const SizedBox(height: R99Size.s4), text]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: figure),
        const SizedBox(width: R99Size.s5),
        Expanded(flex: 4, child: text),
      ],
    );
  }
}

class _ServiceTable extends StatelessWidget {
  const _ServiceTable();

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    const rows = [
      ('普通阅览', 'SV-01', '90 分钟', '免费', '开放', R99StatusKind.ok),
      ('原件调阅', 'SV-02', '60 分钟', '预约制', '开放', R99StatusKind.ok),
      ('影像复制', 'SV-03', '3 个工作日', '按页计', '排队 6 人', R99StatusKind.due),
      ('口述采访', 'SV-04', '120 分钟', '面议', '暂停', R99StatusKind.settled),
    ];

    Widget cell(String text, {bool head = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: head
            ? Text(
                text.toUpperCase(),
                style: TextStyle(
                  fontFamily: R99Text.display,
                  fontSize: 10,
                  letterSpacing: 2,
                  color: scope.fgMuted,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontFamily: R99Text.serif,
                  fontSize: 14,
                  color: scope.fg,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
      );
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: scope.palette.accent, width: R99Size.hair)),
          ),
          child: Row(
            children: [
              Expanded(flex: 3, child: cell('项目', head: true)),
              Expanded(flex: 2, child: cell('编号', head: true)),
              Expanded(flex: 2, child: cell('时长', head: true)),
              Expanded(flex: 2, child: cell('费用', head: true)),
              Expanded(flex: 2, child: cell('状态', head: true)),
            ],
          ),
        ),
        for (final row in rows)
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: scope.line, width: R99Size.hair)),
            ),
            child: Row(
              children: [
                Expanded(flex: 3, child: cell(row.$1)),
                Expanded(flex: 2, child: cell(row.$2)),
                Expanded(flex: 2, child: cell(row.$3)),
                Expanded(flex: 2, child: cell(row.$4)),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: R99Status(row.$5, kind: row.$6),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _VariantBar extends StatelessWidget {
  const _VariantBar({required this.accent, required this.onPick});
  final String accent;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Container(
      padding: const EdgeInsets.all(R99Size.s4),
      decoration: BoxDecoration(
        border: Border.all(color: scope.line, width: R99Size.hair),
        borderRadius: r99Radius(R99Size.rPanel),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const R99Kicker('Variant'),
          const SizedBox(height: R99Size.s3),
          Wrap(
            spacing: R99Size.s2,
            runSpacing: R99Size.s2,
            children: [
              for (final entry in R99Accents.values.entries)
                R99Chip(
                  entry.key,
                  selected: entry.key == accent,
                  onTap: () => onPick(entry.key),
                ),
            ],
          ),
          const SizedBox(height: R99Size.s3),
          Text(
            '强调色只做线、编号、当前项与印章；换色时先按 4.5:1 复核上面的文字。',
            style: TextStyle(fontFamily: R99Text.serif, fontSize: 13, height: 1.8, color: scope.fgMuted),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final scope = R99Scope.of(context);
    return Container(
      padding: const EdgeInsets.only(top: R99Size.s5),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: scope.line, width: R99Size.hair)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: R99Size.s4,
        runSpacing: R99Size.s2,
        children: [
          Text('夜航档案室 · 雨幕路 1999 号', style: TextStyle(fontFamily: R99Text.serif, fontSize: 12, color: scope.fgMuted)),
          Text('1999 — 2026', style: TextStyle(fontFamily: R99Text.display, fontSize: 12, letterSpacing: 1.6, color: scope.fgMuted)),
          Text('示例数据，仅用于展示这套界面风格。', style: TextStyle(fontFamily: R99Text.serif, fontSize: 12, color: scope.fgMuted)),
        ],
      ),
    );
  }
}
