# reverse1999-ui

English · [简体中文](README.zh-CN.md)

An agent skill for building UI with a *Reverse: 1999*-flavoured editorial look: a dark photographic ground, cream Chinese serif type, a single rust accent used only as hairlines and small marks, square corners whose shape comes from cut corners and corner ornaments, Didone Latin with wide tracking, real record numbers and dates, and motion limited to fades and short shifts. It covers the web, mobile web, H5, mini programs, Flutter, iOS and Android.

It ships no game assets and uses no official fonts. Everything here is code, measured numbers, and our own drawings.

![Cover](examples/web/showcase-1440.jpg)

## Install

The repository follows the Agent Skills layout: `SKILL.md` sits at the root and no single vendor is assumed. Pick whichever install path matches your setup.

**Any agent, via the skills CLI**

```sh
npx skills add vemiy/reverse1999-ui-skill
npx skills add vemiy/reverse1999-ui-skill -g -y   # install globally without prompts
npx skills add vemiy/reverse1999-ui-skill -a codex   # install for one agent only
```

**DeepSeek Harness**

```sh
git clone https://github.com/vemiy/reverse1999-ui-skill ~/.dsh/skills/reverse1999-ui
# or per project: <project>/.dsh/skills/reverse1999-ui/
```

**Claude Code**

```sh
git clone https://github.com/vemiy/reverse1999-ui-skill ~/.claude/skills/reverse1999-ui
# or per project: <project>/.claude/skills/reverse1999-ui/
```

**OpenAI Codex** (command line, IDE extension, desktop app)

```sh
git clone https://github.com/vemiy/reverse1999-ui-skill ~/.agents/skills/reverse1999-ui
# or per project: <project>/.agents/skills/reverse1999-ui/
```

Codex needs a restart before it picks the skill up. Afterwards, ask for "1999 style" in plain words, or call `$reverse1999-ui` directly. The name, summary and colour Codex shows in its UI come from `agents/openai.yaml`.

**Agents that cannot load skills** (they read only a rules file such as `AGENTS.md` or `.cursorrules`): copy the repository somewhere inside the project and point the rules file at `SKILL.md`.

```md
When building UI, read vendor/reverse1999-ui/SKILL.md first and follow its steps and rules; the files it needs are in the same directory.
```

**ChatGPT web / desktop**: there is no install directory. Upload `SKILL.md` together with the templates you need (`templates/*.html`) and ask it to follow them.

## Layout

Nothing here is loaded until the skill triggers, and even then only `SKILL.md`. Reference files are opened one at a time as the task needs them.

```text
reverse1999-ui-skill/
├── SKILL.md                  Entry: character, page types, variants, platforms, parts, rules, checklist, file map
├── agents/openai.yaml        Name, summary and colour for the Codex UI (ignored by other agents)
├── assets/
│   ├── tokens.json           Platform-neutral values: colour, type, spacing, line widths, motion, rarity, variant presets
│   ├── reverse1999.css            Web kit: every variable and part, classes prefixed r99-, no framework
│   ├── fx.js                 Theme memory, scroll reveals, tabs, dialogs, toasts, indicators
│   ├── variant.js            Applies one of four presets from ?variant= or data-variant
│   └── art/                  Abstract illustrations used by the examples
├── templates/
│   ├── showcase.html         Page type one: cover
│   ├── reading.html          Page type two: dossier (article, tabs, contents, footnotes)
│   ├── library.html          Page type three: library as a list (search, filters, cards, pagination)
│   ├── console.html          Page type three: library as a console (rail, four metrics, bars, queue, table)
│   ├── mail.html             Mail (list, square unread marks, reader, attachment row)
│   ├── shop.html             Store (currency bar, item grid, purchase panel)
│   ├── loading.html          Loading screen (door mark, progress line, archive quote)
│   ├── app.html              Mobile web (H5 / PWA): top bar, hero card, filter row, records, tab bar, sheet
│   ├── motion.html           Motion sheet: one tile per motion, replayable, ?play=1 plays them in order
│   ├── specimen.html         Every web and in-game part on one page
│   ├── antipatterns.html     Do and do-not pairs
│   └── flutter/              Flutter kit and sample screens (lib/r99/ plus font subsets; analyze, test and build verified)
├── references/
│   ├── research.md           What was measured from the official site, the wiki and unpacked assets
│   ├── tokens.md             Colour and contrast, type, radii, rarity, texture layers, platform mapping
│   ├── components.md         Every part: markup, meaning, misuse
│   ├── patterns.md           Four page types and the mobile patterns
│   ├── motion.md             Principles, curves, choreography, checklist, per-platform notes
│   ├── variation.md          Fixed rules, six dimensions, four presets, deriving new parts
│   ├── rules.md              Do and do-not, each with a reason
│   ├── glossary.md           Internal terms and how to say them to people
│   └── platforms/            web, mobile-web, flutter, ios, android, miniprogram, cross-platform
└── examples/                 Screenshots; no need to run anything
    ├── web/                  Page templates, light theme, four presets, specimen, antipatterns
    ├── app/                  Mobile screens
    └── flutter/              Flutter sample screens
```

## Preview

The templates are static files. Serve the directory:

```sh
cd reverse1999-ui-skill
python -m http.server 8080
```

Then open `templates/showcase.html`. The motion sheet is `templates/motion.html`; any template accepts `?variant=nightrain|salon|dossier`.

Flutter kit:

```sh
cd templates/flutter
flutter pub get
flutter run -d chrome
```

## Sources and licence

- This is an unofficial study of an interface style. It is not affiliated with, sponsored by, or licensed by the rights holder of *Reverse: 1999*; the name is used only to identify the reference.
- The repository ships no game material: no textures, character art, screenshots, audio, or official fonts. Every image under `examples/` is rendered from these templates, and all artwork is drawn in SVG.
- Sizes, colours, corner cuts and type steps come from measuring the interface itself, and are used only to build a consistent style. See `references/tokens.md` and `references/research.md`.
- Type is Noto Serif SC and Bodoni Moda, both under the SIL Open Font License. The Flutter kit bundles a 458-glyph subset of the former; web templates load fonts from Google Fonts, so self-host them in production.
- Every archive, record number and figure in the examples is invented.
- Code, templates, tokens and rules are MIT. If the rights holder wants something changed, open an issue and it will be handled.
