---
name: godot-ui-rich-text
description: "Expert blueprint for RichTextLabel with BBCode formatting (bold, italic, colors, images, clickable links) and custom effects. Covers meta tags, RichTextEffect shaders, and dynamic content. Use when implementing dialogue systems OR formatted text. Keywords RichTextLabel, BBCode, [b], [color], [url], meta_clicked, RichTextEffect, dialogue."
---

# Rich Text & BBCode

BBCode tags, meta clickable links, and RichTextEffect shaders define formatted text systems.

## Available Scripts

### [rich_text_rainbow_effect.gd](scripts/rich_text_rainbow_effect.gd)
Expert custom `RichTextEffect` that rotates colors over time.

### [rich_text_glitch_effect.gd](scripts/rich_text_glitch_effect.gd)
Professional horror-style glitch effects with spatial jitter and alpha flickering.

### [rich_text_typewriter_controller.gd](scripts/rich_text_typewriter_controller.gd)
Dialogue manager that parses sequential event tags (`[pause]`, `[speed]`) during animations.

### [rich_text_meta_dispatch.gd](scripts/rich_text_meta_dispatch.gd)
Advanced handling for multi-prefix URLs in meta-clicks (items, quests, NPCs).

### [rich_text_image_scaler.gd](scripts/rich_text_image_scaler.gd)
Utility to dynamically scale `[img]` tags to match runtime font sizes.

### [rich_text_hover_reactive.gd](scripts/rich_text_hover_reactive.gd)
Signals and logic for making text spans reactive to mouse hover (SFX/Cursors).

### [rich_text_bbcode_sanitizer.gd](scripts/rich_text_bbcode_sanitizer.gd)
Security utility to prevent BBCode injection in public chat interfaces.

### [rich_text_gradient_generator.gd](scripts/rich_text_gradient_generator.gd)
Generator for multi-stop linear gradients using granular character-level tagging.

### [rich_text_auto_scroller.gd](scripts/rich_text_auto_scroller.gd)
Smooth vertical auto-scrolling logic for credits, news feeds, and logs.

### [rich_text_syntax_highlighter.gd](scripts/rich_text_syntax_highlighter.gd)
Simple regex-based syntax highlighting pattern for code blocks in UI.

## NEVER Do (Expert UI Rules)

### Formatting & Rendering
- **NEVER use complex BBCode in tight loops** — Parsing a 10,000 character string with 500 tags every frame will tank performance. Cache your formatted strings.
- **NEVER forget to register Custom Effects** — Writing the script isn't enough. You MUST add the instance to `RichTextLabel.custom_effects` list via Inspector or `install_effect()`.
- **NEVER use absolute pixel sizes in [img]** — `[img width=128]` fails on higher resolutions. Use `rich_text_image_scaler.gd` to sync with line height.

### Click & Hover UX
- **NEVER use [url] without visual feedback** — If the text doesn't change color on hover or the cursor doesn't change, players won't know it's clickable. Use `rich_text_hover_reactive.gd`.
- NEVER hardcode layout logic into strings; strictly use **BBCode Tables** and **Alignment Tags** to ensure text structures remain flexible.
- NEVER animate text typewriter effects by modifying the `text` or `bbcode` string frame-by-frame; strictly use **`visible_ratio`** or **`visible_characters`** to avoid expensive parsing overhead and flickering.
- NEVER use standard bitmap fonts for large titles or dynamic UI; strictly use **MSDF (Multichannel Signed Distance Field)** fonts to ensure perfectly crisp outlines and scaling at any resolution.
- **NEVER perform heavy logic inside `meta_clicked`** — This signal is on the Main Thread. Use it to emit a command and handle processing asynchronously if needed.

### Dialogue & Narrative
- **NEVER use `visible_ratio` for pausing typewriter** — `visible_ratio` is unreliable for per-character logic. Use `visible_characters` and explicit character indexing (`rich_text_typewriter_controller.gd`).
- **NEVER allow unfiltered user input in Chat Labels** — A user could type `[img]huge_image_path[/img]` or `[color=transparent]` to break your UI. **MANDATORY**: pipe every user-generated string through [rich_text_bbcode_sanitizer.gd](scripts/rich_text_bbcode_sanitizer.gd) before assigning `text`.

---

```gdscript
$RichTextLabel.bbcode_enabled = true
$RichTextLabel.text = "[b]Bold[/b] and [i]italic[/i] text"
```

## Godot 4.7: RichTextLabel ImageUnit

- `width_in_percent` / `height_in_percent` **removed** — use `width_unit` / `height_unit` with `RichTextLabel.ImageUnit` enum.
- `ImageUpdateMask.UPDATE_WIDTH_IN_PERCENT` renamed to `UPDATE_WIDTH_UNIT`.
- `add_image` / `update_image` width and height are now **float**, not int.
- **NEVER** pass `true`/`false` for percent flags — use `RichTextLabel.ImageUnit` values (default changed from `false` to `0`).

## Reveal API Decision

| Need | API | **MANDATORY** |
|------|-----|---------------|
| Simple fade / whole-line reveal | `visible_ratio` + Tween | Inline ok (see pattern below) |
| Pause / speed / event tags (`[pause]`, `[speed]`) | `visible_characters` + indexer | [rich_text_typewriter_controller.gd](scripts/rich_text_typewriter_controller.gd) |

> **NEVER** use `visible_ratio` when you need per-character pause/speed tags.

## Non-Obvious Tags & Effects

Skip cataloging `[b]` / `[i]` / `[u]` / `[color]` — see docs. Prefer these when non-obvious:

- `[url=payload]…[/url]` + `meta_clicked` — prefer [rich_text_meta_dispatch.gd](scripts/rich_text_meta_dispatch.gd)
- `[img]` sizing — **Godot 4.7**: use `width_unit` / `height_unit` + `RichTextLabel.ImageUnit` (see section above); scale with [rich_text_image_scaler.gd](scripts/rich_text_image_scaler.gd)
- Custom effects — register via `custom_effects` / `install_effect()`; examples: [rich_text_rainbow_effect.gd](scripts/rich_text_rainbow_effect.gd), [rich_text_glitch_effect.gd](scripts/rich_text_glitch_effect.gd)

## User-Generated Rich Text

**MANDATORY**: [rich_text_bbcode_sanitizer.gd](scripts/rich_text_bbcode_sanitizer.gd) on any chat, lobby, or player-typed path before `RichTextLabel.text = …`.

## Handle Link Clicks

Prefer [rich_text_meta_dispatch.gd](scripts/rich_text_meta_dispatch.gd). Minimal hook:

```gdscript
func _ready() -> void:
    $RichTextLabel.meta_clicked.connect(_on_meta_clicked)

func _on_meta_clicked(meta: Variant) -> void:
    # Emit a command; do not run heavy game logic here
    pass
```

## Expert Text Patterns


### 1. Rich-Text-MSDF-Outline (SDF)
Enable crisp, high-resolution outlines and scaling by enabling MSDF on font resources and using theme overrides.

```gdscript
# msdf_styler.gd
func _ready():
    # Crisp outlines regardless of screen scale
    label.add_theme_color_override("font_outline_color", Color.BLACK)
    label.add_theme_constant_override("outline_size", 4)
```

### 2. Animated-Text-Reveal
**Simple fade** — tween `visible_ratio` (keeps BBCode effects; no string rewrite):

```gdscript
func reveal_fade(label: RichTextLabel, new_text: String, duration: float) -> void:
    label.text = new_text
    label.visible_ratio = 0.0
    create_tween().tween_property(label, "visible_ratio", 1.0, duration)
```

**Pause/speed tags** — **MANDATORY** [rich_text_typewriter_controller.gd](scripts/rich_text_typewriter_controller.gd) using `visible_characters` (not `visible_ratio`).

### 3. Custom-BBCode-Effect (RichTextEffect)
Define custom visual tags (like `[relic]`) by extending RichTextEffect for unique gameplay-themed text animations.

```gdscript
# relic_effect.gd
@tool
extends RichTextEffect
var bbcode = "relic"

func _process_custom_fx(char_fx: CharFXTransform):
    # Retrieve param: [relic color=#ff00ff]
    var color = char_fx.env.get("color", Color.GOLD)
    # Apply sinusoidal floating
    char_fx.offset.y += sin(char_fx.elapsed_time * 5.0) * 2.0
    char_fx.color = color
    return true
```

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [BBCode in RichTextLabel](https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html) — tag syntax, built-in effects, images, and `[url]` meta for dialogue and formatted UI copy.
- [RichTextLabel](https://docs.godotengine.org/en/stable/classes/class_richtextlabel.html) — `bbcode_enabled`, `visible_characters` / `visible_ratio`, `meta_clicked`, and `custom_effects` / `install_effect()`.
- [RichTextEffect](https://docs.godotengine.org/en/stable/classes/class_richtexteffect.html) — subclass contract for custom BBCode effects (`bbcode` id + `_process_custom_fx`).
- [CharFXTransform](https://docs.godotengine.org/en/stable/classes/class_charfxtransform.html) — per-glyph color, offset, and `env` params used by rainbow/glitch/custom effects.
- [Using fonts](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_fonts.html) — MSDF / dynamic fonts so titles and BBCode scale crisply across resolutions.
- [GUI skinning](https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html) — theme color/constant overrides (outline, fonts) without baking styles into BBCode strings.
- [Size and anchors](https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html) — responsive dialogue boxes and log panels so rich text layouts survive resolution changes.
- [GUI containers](https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html) — keep buttons/icons in containers; use RichTextLabel for body text only.
- [Custom mouse cursor](https://docs.godotengine.org/en/stable/tutorials/inputs/custom_mouse_cursor.html) — pointer feedback when hovering `[url]` / meta spans.
- [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) — `tr()` / CSV keys so BBCode templates stay localization-ready.
- [Signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — wire `meta_clicked` / hover signals without stuffing game logic into the label.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — tween `visible_ratio` / `visible_characters` for typewriter reveals without re-parsing BBCode every frame.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, Control basics, and resource imports before wiring RichTextLabel dialogue chrome.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — responsive VBox/HBox/Scroll shells so rich text stays body copy, not a layout engine.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — typed meta/hover command signals so click handlers stay thin on the main thread.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — RegEx, `@tool`, and RefCounted helpers used by sanitizers, highlighters, and effect scripts.

#### Complements
- [godot-ui-theming](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md) — theme type variations and font/outline overrides that BBCode should reference, not hardcode.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — lifecycle-safe tweens for typewriter `visible_ratio` and auto-scroll polish.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — skip/advance and cursor changes that pair with meta hover without fighting Control focus.
- [godot-dialogue-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md) — line runners and event tags that feed RichTextLabel typewriter controllers.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — when CharFX alone is not enough and you need canvas-item shaders around text panels.

#### Downstream / consumers
- [godot-genre-visual-novel](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-visual-novel/SKILL.md) — VN dialogue boxes that depend on BBCode, `visible_characters`, and meta choice links.
- [godot-genre-educational](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-educational/SKILL.md) — lesson/copy UIs and interactive rich text that reuse sanitizers and highlighters.
- [godot-genre-romance](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-romance/SKILL.md) — affinity dialogue presentation that reuses typewriter and meta dispatch patterns.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
