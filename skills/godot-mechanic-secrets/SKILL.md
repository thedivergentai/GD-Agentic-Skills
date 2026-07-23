---
name: godot-mechanic-secrets
description: "Implement cheat codes, hidden interactions, and unlockable meta-content via time-windowed input sequence buffers, spam thresholds, look-at (dot-product) detectors, progress-% unlocks, and meta persistence in user://secrets.cfg. Use when adding Konami-style codes, curiosity spam eggs, glimmer cues, lockout anti-brute-force, or gallery flags that must survive slot deletes. Keywords: Konami, sequence buffer, meta secrets.cfg, visibility detector, lockout, glimmer, spam threshold, progress unlock."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# Secrets & Easter Eggs (Mechanics)

## Decision Tree — Which Secret Trigger?

| Player action / design goal | Choose | MANDATORY script |
|----------------------------|--------|------------------|
| Exact button combo / Konami | Time-windowed **input sequence** | [secret_sequence_combo_matcher.gd](scripts/secret_sequence_combo_matcher.gd) (+ [secret_konami_legacy_code.gd](scripts/secret_konami_legacy_code.gd) for classic mapping) |
| Mash / click N times on a prop | **Spam threshold** | [secret_interaction_spam_tracker.gd](scripts/secret_interaction_spam_tracker.gd) |
| Face a wall / look at a spot | **Dot-product look-at** (not ray spam) | [secret_visibility_detector.gd](scripts/secret_visibility_detector.gd) |
| Clear X% of content / true ending | **Progress % unlock** | [secret_progress_threshold_unlocker.gd](scripts/secret_progress_threshold_unlocker.gd) |
| Rare vendor / ghost encounter | Weighted **random encounter** | [secret_random_encounter_spawner.gd](scripts/secret_random_encounter_spawner.gd) |
| Persist unlock across save slots | **Meta secrets.cfg** | [secret_meta_persistence.gd](scripts/secret_meta_persistence.gd) |
| Stop macro brute-force | **Lockout guard** | [secret_lockout_cheat_guard.gd](scripts/secret_lockout_cheat_guard.gd) |
| Secret grants stats/items in P2P | **Server/peer validation** | [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — validate unlock before applying combat/economy advantages |

Do **NOT** invent a fourth custom detector until the table above fails.

## Core Components

### [secret_meta_persistence.gd](scripts/secret_meta_persistence.gd)
Expert logic for saving global unlocks and discovery flags across all save profiles.

### [secret_visibility_detector.gd](scripts/secret_visibility_detector.gd)
View-dependent hidden wall detection using optimized Dot Product calculations.

### [secret_sequence_combo_matcher.gd](scripts/secret_sequence_combo_matcher.gd)
**MANDATORY for combos** — Time-sensitive input buffer with suffix/window match (not full-buffer equality).

### [secret_interaction_spam_tracker.gd](scripts/secret_interaction_spam_tracker.gd)
Logic for tracking repetitive player actions to trigger curiosity-based Easter Eggs.

### [secret_audio_environment_occluder.gd](scripts/secret_audio_environment_occluder.gd)
Spatial logic for dynamically adjusting AudioBus effects in sealed or hidden areas.

### [secret_progress_threshold_unlocker.gd](scripts/secret_progress_threshold_unlocker.gd)
Percentage-based unlocker for meta-content and 'True Ending' triggers.

### [secret_random_encounter_spawner.gd](scripts/secret_random_encounter_spawner.gd)
Weighted random system for rarest-tier entities and secret vendor encounters.

### [secret_lockout_cheat_guard.gd](scripts/secret_lockout_cheat_guard.gd)
Anti-brute-force lockout manager to protect secret integrity.

### [secret_vfx_discovery_glimmer.gd](scripts/secret_vfx_discovery_glimmer.gd)
Subtle procedural visual cues for hinting at hidden interactables.

### [secret_konami_legacy_code.gd](scripts/secret_konami_legacy_code.gd)
Specialized implementation of the iconic Konami code using the buffer matcher.

### [secret_persistence_handler.gd](scripts/secret_persistence_handler.gd) / [input_sequence_watcher.gd](scripts/input_sequence_watcher.gd) / [interaction_threshold_trigger.gd](scripts/interaction_threshold_trigger.gd)
**DEPRECATED** — legacy helpers superseded by `secret_*` scripts. Do not wire new scenes here; migrate to [secret_sequence_combo_matcher.gd](scripts/secret_sequence_combo_matcher.gd), [secret_interaction_spam_tracker.gd](scripts/secret_interaction_spam_tracker.gd), and [secret_meta_persistence.gd](scripts/secret_meta_persistence.gd).

## Usage Example (Cheat Code)

```gdscript
# Attach SecretSequenceComboMatcher (class_name) as a child of GameManager / Player
@onready var combo: SecretSequenceComboMatcher = $SecretSequenceComboMatcher

func _ready() -> void:
    # Default sequences Dictionary already includes "Konami"; override or add:
    combo.sequences = {
        "GodMode": ["ui_up", "ui_up", "ui_down", "ui_down", "ui_left", "ui_right", "ui_left", "ui_right"]
    }
    combo.combo_achieved.connect(_on_cheat_unlocked)

func _on_cheat_unlocked(combo_name: String) -> void:
    print("Unlocked: ", combo_name)
    # Meta flag — NOT the per-slot SaveManager payload
    SecretMetaPersistence.unlock_secret("god_mode")  # via secret_meta_persistence.gd API
```

## NEVER Do (Expert Secret Rules)

### Discovery & Triggers
- **NEVER hardcode input checks in `_process`** — Frame-dependent polling is unreliable for fast combos. Always use an event-based buffer like `secret_sequence_combo_matcher.gd`.
- **NEVER use complex Raycasts for 'LookingAt' secrets** — Physics raycasts are expensive if every wall is checking. Use the Dot Product method in `secret_visibility_detector.gd` for overhead efficiency.
- **NEVER make 'Hidden Walls' identical to real walls** — Players need a subtle "Glimmer" or texture discrepancy. Total invisibility isn't a secret; it's a bug to the player.

### Persistence & Meta
- **NEVER save "Secrets Found" in the main Save Slot** — If the player deletes their save to try a different build, their meta-progress (Gallery, Achievement flags) should persist. Use `secret_meta_persistence.gd`.
- **NEVER trust client-side cheat validation in Peer-to-Peer** — If a secret grants a stat boost, other peers should validate the "Unlock" to prevent simple memory-editing cheats.
- **NEVER use `PlayerPrefs` (Godot's equivalent of Settings) for secrets** — Use a dedicated `user://secrets.cfg`.

### UX & Anti-Brute Force
- **NEVER allow unlimited rapid-fire cheat attempts** — A simple macro can brute-force a 4-button combo in seconds. Use `secret_lockout_cheat_guard.gd` to add a penalty for excessive failures.
- **NEVER trigger a secret without an 'Aha!' audio/visual cue** — The reward for finding a secret is the *feeling* of discovery. Use `secret_audio_environment_occluder.gd` to change the atmosphere.

## Best Practices

1. **Event-Based Combo Detection** - Avoid polling in `_process`.
2. **Subtle Cues** - Secrets should be hinted at, not invisible.
3. **Global Persistence** - Use separate save files for meta-progress.

---

## Elite Meta Patterns (galleries / lore / ghosting)

> **MANDATORY** when building achievement galleries, lore journals, or ghosted-secret visibility: read [secrets-meta-patterns.md](references/secrets-meta-patterns.md). **Do NOT Load** for basic combo/spam/look-at triggers — use the decision tree scripts above.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using InputEvent](https://docs.godotengine.org/en/stable/tutorials/inputs/inputevent.html) — Event pipeline (`_input` / `_unhandled_input`), `is_action_pressed`, and echo filtering for cheat buffers.
- [Input examples](https://docs.godotengine.org/en/stable/tutorials/inputs/input_examples.html) — Practical InputMap action patterns for multi-step sequences without `_process` polling.
- [Controllers, gamepads, and joysticks](https://docs.godotengine.org/en/stable/tutorials/inputs/controllers_gamepads_joysticks.html) — Map classic Konami-style codes to pad D-pad/face buttons with consistent action names.
- [InputMap](https://docs.godotengine.org/en/stable/classes/class_inputmap.html) — Runtime action enumeration used by sequence matchers (`get_actions` / `event.is_action_pressed`).
- [Saving games](https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html) — Canonical persist loop; keep meta-unlocks out of per-slot save groups.
- [File paths in Godot](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html) — `user://secrets.cfg` / `user://meta_secrets.cfg` placement across platforms.
- [ConfigFile](https://docs.godotengine.org/en/stable/classes/class_configfile.html) — INI-style dedicated secret flags separate from Settings and main SaveManager payloads.
- [Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html) — `SecretData` Resource patterns, `emit_changed`, and achievement bridges.
- [Vector math](https://docs.godotengine.org/en/stable/tutorials/math/vector_math.html) — Dot-product look-at detection for hidden walls without per-frame raycasts.
- [Random number generation](https://docs.godotengine.org/en/stable/tutorials/math/random_number_generation.html) — Weighted rare-encounter rolls and pity timers for secret vendors.
- [Audio buses](https://docs.godotengine.org/en/stable/tutorials/audio/audio_buses.html) — Bus effects / occlusion when entering sealed secret areas.
- [Singletons (Autoload)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html) — Host SecretPersistence / meta unlock managers across scene changes.

### Related Skills

#### Prerequisites
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Action buffers, echo filtering, and InputMap remaps that cheat-sequence watchers must share with gameplay input.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — `sequence_matched` / `secret_spam_triggered` buses so UI, audio, and achievements react without hard-wiring detectors.
- [godot-autoload-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-autoload-architecture/SKILL.md) — SecretPersistence and meta-unlock Autoloads need boot order and scene-change survival rules.

#### Complements
- [godot-save-load-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-save-load-systems/SKILL.md) — Keep gallery/meta flags in `user://meta_secrets.cfg` while run progress stays in versioned save slots.
- [godot-resource-data-patterns](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md) — Typed `SecretData` / lore Resources with `emit_changed` for achievement and journal bridges.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — Bus effects and stingers for sealed-room occlusion and the discovery “Aha!” cue.
- [godot-ui-rich-text](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md) — BBCode lore journals that append discovered secret descriptions.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Glimmer energy pulses and ghosted-secret fade tweens without AnimationPlayer overhead.
- [godot-particles](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-particles/SKILL.md) — Optional sparkle/dust layers that hint at interactables without spoiling the secret.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — Subtle wall-glimmer / dissolve materials for look-at reveal transitions.

#### Downstream / consumers
- [godot-quest-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-quest-system/SKILL.md) — Route discovery flags into quest stages, journals, and true-ending gates.
- [godot-monte-carlo-balancer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md) — Simulate rare-encounter weights, spam thresholds, and completion-% unlock odds before shipping.
- [godot-adapt-single-to-multiplayer](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-single-to-multiplayer/SKILL.md) — Server/peer validation when a secret grants combat or economy advantages.
- [godot-theme-easter](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-theme-easter/SKILL.md) — Seasonal/themed Easter content that consumes the same unlock and cue pipeline.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Library router and mirrored module entry; open when discovering which Domain Skill owns secrets vs input, save, or audio.
