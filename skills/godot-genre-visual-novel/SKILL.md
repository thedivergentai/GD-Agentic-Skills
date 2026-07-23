---
name: godot-genre-visual-novel
description: "Expert blueprint for visual novels (Doki Doki Literature Club, Phoenix Wright, Steins;Gate) focusing on branching narratives, dialogue systems, choice consequences, rollback mechanics, and persistent flags. Use when building story-driven, choice-based, or dating sim games. Keywords visual novel, dialogue system, branching narrative, typewriter effect, rollback, bbcode, RichTextLabel."
---

# Genre: Visual Novel

Branching narratives, meaningful choices, and quality-of-life features define visual novels.

## Core Loop
1. **Read** → dialogue / narration
2. **Decide** → choice moment
3. **Branch** → flag or path change
4. **Consequence** → immediate line variation and/or lasting flag
5. **Conclude** → one of multiple endings

## NEVER Do (Expert Anti-Patterns)

### Narrative & Flow
- NEVER create the "Illusion of Choice" exclusively; strictly provide **Immediate Dialogue Variations** or **Flag Changes** even if the plot converges later.
- NEVER skip mandatory QoL features; strictly implement **Auto-Play**, **Fast-Forward**, and **Backlog/History** for replayability.
- NEVER display "Walls of Text"; strictly limit dialogue boxes to **3-4 Lines** max to avoid intimidating the reader.
- NEVER hardcode dialogue text inside GDScripts; strictly store narrative scripts in **External Files** (JSON, CSV, or custom Resources) for iteration.
- NEVER ignore the **Rollback** mechanic; strictly maintain a history stack so players can undo miss-clicks or reread missed lines.

### Technical & UI
- NEVER use plain text for emotional beats; strictly use **RichTextLabel BBCode** (e.g., `[shake]`, `[wave]`) to add visual weight.
- NEVER parse massive narrative files on the main thread; strictly use **`ResourceLoader.load_threaded_request()`** to prevent transition stutters.
- NEVER use standard Strings for frequently accessed game flags; strictly use **`StringName`** (&"met_alice") for faster dictionary lookups.
- NEVER use `_process` for letter-by-letter animation; strictly use a **Tween on `visible_ratio`** for smooth, frame-independent reveals.
- NEVER neglect character **Z-ordering**; strictly ensure the active speaker is brought to the front for visual clarity.
- NEVER use `z_index` for `Control` node priority if input handling is required; strictly use `move_to_front()` to ensure draw order and input propagation match.
- NEVER use absolute pixel positioning for character sprites; strictly rely on **Anchors & Percent-based Offsets** for responsive scaling.
- NEVER allow text animations to continue when the player skips; strictly set **`visible_ratio` to 1.0** instantly on input.
- NEVER leave orphaned character sprites; strictly use **`queue_free()`** when actors exit the stage to prevent memory leaks.
- NEVER mutate flags before snapshotting rollback state — always push history, then apply the choice.

---

## Godot 4.7: Visual Novel UI

- Migrate RichTextLabel images to `ImageUnit` API — `width_in_percent` removed in 4.7.

## 🛠 Expert Components (scripts/)

> **MANDATORY** before implementing undo / branching / presentation:
> 1. [vn_rollback_manager.gd](scripts/vn_rollback_manager.gd) — history stack (flags/backgrounds/index)
> 2. [story_manager.gd](scripts/story_manager.gd) — flag-aware dialog orchestration
> 3. [dialogue_ui.gd](scripts/dialogue_ui.gd) — typewriter + choice UI
> 4. [visual_novel_patterns.gd](scripts/visual_novel_patterns.gd) — BBCode, choice filtering, sprite layering

### Catalog (deduped)
- [story_manager.gd](scripts/story_manager.gd) - Flag-aware dialog orchestrator with branching logic and character state persistence.
- [dialogue_ui.gd](scripts/dialogue_ui.gd) - Presentation layer: typewriter tweens (`visible_ratio`) and choice-window generation.
- [vn_rollback_manager.gd](scripts/vn_rollback_manager.gd) - History stack for state rollback (flags/backgrounds/index).
- [visual_novel_patterns.gd](scripts/visual_novel_patterns.gd) - Reusable BBCode effects, choice filtering by flags, sprite layering.

---

## Decision Tree: Script Storage vs Plugin

| Approach | When to choose | Notes |
|----------|----------------|-------|
| **JSON / CSV scripts** | Writers edit outside Godot; rapid iteration | Load via FileAccess or threaded ResourceLoader; validate schema in StoryManager |
| **Custom `Resource` dialogue trees** | Designer Inspector editing, typed fields | Peer [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md); **MANDATORY** [story_manager.gd](scripts/story_manager.gd) |
| **Dialogic (plugin)** | Full VN suite (timelines, characters, themes) with editor tooling | Prefer when shipping a large route graph fast; still keep rollback + flag discipline. Skip building a second StoryManager if Dialogic already owns timelines |
| **Build lightweight custom** | Tiny kinetic novel / learning project | Use scripts in this skill; do not re-stub StoryManager inline |

Do not paste incomplete JSON StoryManager demos — implement from **MANDATORY** [story_manager.gd](scripts/story_manager.gd).

---

## Golden Path (order matters)

1. **Snapshot before mutate** — On every advance/choice, **MANDATORY** [vn_rollback_manager.gd](scripts/vn_rollback_manager.gd) pushes `{line_index, flags, background, music}` *before* flag writes.
2. **Typewriter + skip** — [dialogue_ui.gd](scripts/dialogue_ui.gd): Tween `visible_ratio` 0→1; on skip/advance input set `visible_ratio = 1.0` and kill the tween.
3. **Choice filter by flags** — Present only options whose `requires` StringName flags pass; apply choice → mutate flags → jump label ([visual_novel_patterns.gd](scripts/visual_novel_patterns.gd) + [story_manager.gd](scripts/story_manager.gd)).
4. **Speaker focus** — `move_to_front()` on Control actors (not `z_index` alone) + dim inactive.
5. **Heavy CG/BG** — `ResourceLoader.load_threaded_request` for backgrounds; never sync-parse huge scripts on the main thread.

```gdscript
# Choice handler shape (flags after snapshot)
func make_choice(choice_id: StringName) -> void:
    rollback_manager.push_snapshot()  # BEFORE mutate
    match choice_id:
        &"be_nice":
            flags[&"relationship_alice"] = int(flags.get(&"relationship_alice", 0)) + 1
            story_manager.jump_to_label(&"alice_happy")
        &"be_mean":
            flags[&"relationship_alice"] = int(flags.get(&"relationship_alice", 0)) - 1
            story_manager.jump_to_label(&"alice_sad")
```

---

## Common Pitfalls

1. **Walls of text** — Cap dialogue to 3–4 lines.
2. **Illusion of choice** — Always vary lines or flags even on converging plots.
3. **Missing QoL** — Auto / Skip / Backlog / Save are mandatory genre features.
4. **Broken rollback** — Mutating flags before snapshot makes undo lie.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [BBCode in RichTextLabel](https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html) — shake/wave BBCode and append_text for emotional dialogue without plain Label walls.
- [Size and anchors](https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html) — percent offsets and anchors so character sprites and dialogue boxes scale across resolutions.
- [GUI containers](https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html) — VBox/HBox choice rows and dialogue chrome instead of absolute pixel layouts.
- [Background loading](https://docs.godotengine.org/en/stable/tutorials/io/background_loading.html) — ResourceLoader.load_threaded_request so heavy CG/background swaps never hitch the typewriter.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — FileAccess patterns for flags, history stacks, and multi-slot VN saves.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — typed dialogue/choice Resources as an alternative to brittle hardcoded JSON strings.
- [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) — tr() / CSV keys so script lines stay localization-ready.
- [Audio streams](https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html) — BGM crossfades and optional voice lines tied to line advances.
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — skip/advance/ui_accept handling that finishes visible_ratio instantly.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — persistent flag/history owners across chapter scene changes.
- [Signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html) — line_advanced / options_presented wiring between StoryManager and DialogueUI.
- [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html) — tween_property on RichTextLabel.visible_ratio for frame-independent typewriter reveals.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — scene tree, autoloads, and import basics before wiring a StoryManager driver.
- [godot-ui-rich-text](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md) — RichTextLabel BBCode, visible_ratio, and append_text performance for dialogue boxes.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — responsive choice panels and dialogue chrome without absolute pixel placement.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — typed signals so UI presentation stays decoupled from branching logic.

#### Complements
- [godot-dialogue-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md) — reusable dialogue runners and line data shapes that genre VNs specialize.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — typewriter tweens, sprite fades, and background crossfades without AnimationPlayer spam.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Resource-based dialogue trees and duplicate(true) for mutable flag state.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — skip, auto-advance, and backlog input actions without fighting Control focus.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — BGM buses and voice ducking synced to line/choice beats.
- [godot-ui-theming](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md) — theme type variations for nameplates, choice buttons, and backlog chrome.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — simulate affinity thresholds and ending distribution before shipping branch weights.

#### Downstream / consumers
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — multi-slot, threaded saves for flags/history beyond ConfigFile demos.
- [godot-genre-romance](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-romance/SKILL.md) — dating-sim affinity loops that reuse VN flags, rollback, and choice filtering.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
