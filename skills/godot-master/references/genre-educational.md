---
name: godot-genre-educational
description: "Expert blueprint for educational games including gamification loops (learn/apply/feedback/adapt), progress tracking (student profiles, mastery %), adaptive difficulty (target 70% success rate), spaced repetition, curriculum trees (prerequisite system), and visual feedback (confetti, XP bars). Use for learning apps, training simulations, or edutainment. Trigger keywords: educational_game, gamification, adaptive_difficulty, spaced_repetition, student_profile, curriculum_tree, mastery_tracking."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Genre: Educational / Gamification

Expert blueprint for educational games that make learning engaging through game mechanics.

## NEVER Do (Expert Anti-Patterns)

### Pedagogy & Flow
- NEVER punish failure with a "Game Over"; strictly use **"Try Again"** or **Contextual Hints** to ensure a safe, encouraging learning environment.
- NEVER separate learning from gameplay ("Chocolate-covered broccoli"); strictly ensure the **mechanic IS the learning** (e.g., math-based trajectory calc).
- NEVER use walls of text for instructions; strictly use **Show, Don't Tell** methods: interactive diagrams, non-verbal tutorials, or 3-second looping GIFs.
- NEVER skip **Spaced Repetition** logic; strictly ensure successfully answered questions reappear at increasing intervals to verify long-term retention.
- NEVER focus on failure; strictly prominently display **Mastery %**, **XP Bars**, and **Skill Trees** to motivate through visible progress.
- NEVER assume a fixed difficulty; strictly implement **Dynamic Scaffolding** that adjusts challenge based on the student's mastery level to keep them in the "Zone of Proximal Development".
- NEVER hardcode student stats in UI components; strictly use **`Resource` scripts (`StudentProfile`)** to decouple student data from the presentation layer for persistence and scalability.
- NEVER build custom debug dashboards for performance tracking during development; strictly use **`Performance.add_custom_monitor()`** to inject live student metrics into the Godot Editor Debugger.

### Technical & Accessibility
- NEVER hardcode text into UI; strictly use **Translation Keys (PO files)** for internationalization and classroom localized support.
- NEVER force TTS without user consent; strictly provide an in-game toggle and respect OS-level screen reader settings.
- NEVER use absolute pixel positioning; strictly use the **Anchoring & Container** system for responsive scaling across tablets and classroom laptops.
- NEVER perform heavy data grading on the main thread; strictly use **WorkerThreadPool** to prevent UI freezes during automated assessments.
- NEVER forget to handle **IME updates**; strictly monitor `NOTIFICATION_OS_IME_UPDATE` for complex character input support (e.g., East Asian).
- NEVER ignore `mouse_filter` on overlays; strictly set to `PASS` to prevent invisible containers from silently consuming clicks.
- NEVER update static strings in `_process()`; strictly update labels ONLY on state change events to save mobile/tablet battery.
- NEVER embed sensitive database credentials in exports; strictly use **Environment Variables** or proxy APIs for student data security.

---

## Available Scripts

> **MANDATORY**: Read the script matching the scenario before implementing. Do not paste quiz/profile tutorials inline.

### Pedagogy / Adaptivity
- [adaptive_difficulty_adjuster.gd](../scripts/genre_educational_adaptive_difficulty_adjuster.gd) — **MANDATORY** when targeting ~70% flow / progressive hints.
- [spaced_repetition_scheduler.gd](../scripts/genre_educational_spaced_repetition_scheduler.gd) — **MANDATORY** when scheduling question reappearance (intervals after success/fail).
- [student_progress_config.gd](../scripts/genre_educational_student_progress_config.gd) — **MANDATORY** before persisting mastery/XP (ConfigFile profile).
- [threaded_scoring_engine.gd](../scripts/genre_educational_threaded_scoring_engine.gd) — **MANDATORY** before heavy assessment/grading on school hardware.

### Accessibility / Classroom UI
- [tts_manager.gd](../scripts/genre_educational_tts_manager.gd) — **MANDATORY** before DisplayServer TTS (consent toggle first).
- [dynamic_localization.gd](../scripts/genre_educational_dynamic_localization.gd) — Runtime locale switch / pluralization.
- [adaptive_ui_anchors.gd](../scripts/genre_educational_adaptive_ui_anchors.gd) — Responsive tablet/laptop lesson layouts.
- [focus_navigation_manager.gd](../scripts/genre_educational_focus_navigation_manager.gd) — Keyboard/controller focus for classroom navigation.
- [interactive_rich_text.gd](../scripts/genre_educational_interactive_rich_text.gd) — Meta-click glossaries / formula prompts.
- [text_reveal_effect.gd](../scripts/genre_educational_text_reveal_effect.gd) — Progressive text reveal without walls of text.

### Assessment UX
- [assessment_pause_handler.gd](../scripts/genre_educational_assessment_pause_handler.gd) — Pause world logic while quiz UI stays interactive.
- [low_processor_optimizer.gd](../scripts/genre_educational_low_processor_optimizer.gd) — Battery-friendly idle for ed apps on school devices.

---

## Core Loop
1. **Learn** → 2. **Apply** → 3. **Feedback** → 4. **Adapt** → 5. **Master**

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. UI | `godot-ui-rich-text`, `godot-ui-theming` | Readable text, drag-and-drop answers |
| 2. Data | `godot-save-load-systems` | Student profiles, progress tracking |
| 3. Logic | `godot-state-machine-advanced` | Quiz flow (Question → Answer → Result) |
| 4. Juice | `godot-particles`, `godot-tweening` | Making learning feel rewarding |
| 5. Meta | `godot-scene-management` | Navigating between lessons and map |
| 6. Balance | `godot-monte-carlo-balancer` | Override bands to ~70% flow / mastery |

## Architecture Decision Tree

Pick the owner script; keep SKILL free of duplicate `StudentProfile` / quiz_manager paste-ups.

| Need | Decision | MANDATORY script |
|------|----------|------------------|
| Track mastery / XP / badges | One `StudentProfile` Resource + ConfigFile I/O | [student_progress_config.gd](../scripts/genre_educational_student_progress_config.gd) |
| Keep learners in flow (~70%) | Windowed success ratio + hint branch | [adaptive_difficulty_adjuster.gd](../scripts/genre_educational_adaptive_difficulty_adjuster.gd) |
| Long-term retention | Interval queue (success → longer delay; fail → sooner) | [spaced_repetition_scheduler.gd](../scripts/genre_educational_spaced_repetition_scheduler.gd) |
| Prerequisite lesson map | Curriculum Resource graph (id + required_topics) — data only, no UI | Peer `godot-resource-data-patterns` |
| Grade without hitching | Offload scoring | [threaded_scoring_engine.gd](../scripts/genre_educational_threaded_scoring_engine.gd) |
| Classroom a11y | TTS + locale + focus + anchors | `tts_manager` / `dynamic_localization` / `focus_navigation_manager` / `adaptive_ui_anchors` |
| Live debugger metrics | `Performance.add_custom_monitor("edu/...")` — no custom dashboards | (inline one-liner OK) |

**StudentProfile (single shape):** `@export` mastery Dictionary + XP; emit change signals; persist via `student_progress_config.gd`. Do not redefine the class twice in this skill.

**Quiz curtain:** state machine owns Question → Answer → Result → Adapt; spaced-repetition + adaptive-difficulty scripts decide *what* is next — do not inline a full `quiz_manager.gd` tutorial here.

## Juice (Duolingo Effect)
Learning is hard — reward effort: satisfying SFX, particles on correct, Tweened XP bars. Pedagogue first; juice never substitutes for spaced repetition / ZPD scaffolding.

## Common Pitfalls

1. **Chocolate-Covered Broccoli** — mechanic must *be* the learning.
2. **Punishing Failure** — Try Again / hint, never Game Over for wrong answers.
3. **Wall of Text** — show/interact first; use `text_reveal_effect` / rich-text meta.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Internationalizing games](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) — `tr()` / locale workflow for classroom multi-language UI without hardcoding strings.
- [Localization using gettext](https://docs.godotengine.org/en/stable/tutorials/i18n/localization_using_gettext.html) — PO/CSV pipeline and plural forms used by runtime locale switching.
- [Text-to-speech](https://docs.godotengine.org/en/stable/tutorials/audio/text_to_speech.html) — DisplayServer TTS voices, speak/stop, and consent-friendly accessibility read-aloud.
- [BBCode in RichTextLabel](https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html) — Colored keywords, formulas, meta links, and custom RichTextEffect reveals for lessons.
- [Using Containers](https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html) — Responsive quiz/layout composition for tablets and classroom laptops.
- [Size and anchors](https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html) — Anchor/offset rules that replace absolute pixel placement across orientations.
- [Keyboard/Controller Navigation and Focus](https://docs.godotengine.org/en/stable/tutorials/ui/gui_navigation.html) — Focus neighbors and grab_focus patterns for keyboard-only classroom navigation.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — StudentProfile / curriculum node Resources decoupled from presentation.
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Persist mastery, XP, and progress without baking credentials into exports.
- [Using multiple threads](https://docs.godotengine.org/en/stable/tutorials/performance/using_multiple_threads.html) — WorkerThreadPool grading so heavy assessment never freezes the quiz UI.
- [Pausing games](https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html) — Tree pause + `process_mode` so assessments freeze world logic while UI stays interactive.
- [Performance](https://docs.godotengine.org/en/stable/tutorials/performance/index.html) — Custom monitors, low-processor mode, and battery-friendly idle screens for ed apps.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Project locale, display, and input map defaults must exist before classroom UI and TTS toggles.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Resources, signals, and await patterns underpin student profiles and quiz flow.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — Anchors/containers are the non-negotiable layout base for multi-device lesson screens.

#### Complements
- [godot-ui-rich-text](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md) — BBCode, meta clicks, and custom effects for glossaries and formula-heavy prompts.
- [godot-ui-theming](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md) — Readable theme scales and contrast for mixed tablet/laptop classrooms.
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Durable StudentProfile / mastery persistence beyond ad-hoc ConfigFile snippets.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — XP bars, confetti timing, and overlay fades that sell the “Duolingo effect.”
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Mastery-up, hint-revealed, and difficulty-changed events without UI↔logic hardwiring.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Focus actions, drag-and-drop answers, and IME-safe text entry for assessments.

#### Downstream / consumers
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate override bands so adaptive difficulty actually lands near ~70% flow/mastery success.
- [godot-state-machine-advanced](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-state-machine-advanced/SKILL.md) — Question → Answer → Result → Adapt quiz FSMs once the curtain grows beyond one script.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — Lesson map ↔ quiz ↔ results transitions without leaking paused tree state.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Escalate when scoring threads, TTS, or rich-text effects still show profiler cost on school hardware.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — Confetti/reward bursts wired to correct-answer juice without blocking pedagogy.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns a cross-cutting educational concern.
