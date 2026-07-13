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

## 🛠 Expert Components (scripts/)

> **MANDATORY**: Read the appropriate script before implementing the corresponding pattern.

### Original Expert Patterns
- [adaptive_difficulty_adjuster.gd](scripts/adaptive_difficulty_adjuster.gd) - Sophisticated logic engine for Flow-State targeting (70%) and progressive hints.

### Modular Components
- [tts_manager.gd](scripts/tts_manager.gd) - displayServer Text-to-Speech integration for accessibility.
- [dynamic_localization.gd](scripts/dynamic_localization.gd) - Runtime localization switching and pluralization support.
- [interactive_rich_text.gd](scripts/interactive_rich_text.gd) - Meta-click handling for interactive glossaries.
- [threaded_scoring_engine.gd](scripts/threaded_scoring_engine.gd) - WorkerThreadPool patterns for grading algorithms.

---

## Core Loop
1.  **Learn**: Player receives new information (text, diagram, video).
2.  **Apply**: Player solves a problem or completes a task using that info.
3.  **Feedback**: Game provides immediate correction or reward.
4.  **Adapt**: System adjusts future questions based on performance.
5.  **Master**: Player unlocks new topics or cosmetic rewards.

## Skill Chain

| Phase | Skills | Purpose |
|-------|--------|---------|
| 1. UI | `godot-ui-rich-text`, `godot-ui-theming` | Readable text, drag-and-drop answers |
| 2. Data | `godot-save-load-systems`, `json-serialization` | Student profiles, progress tracking |
| 3. Logic | `state-machine` | Quiz flow (Question -> Answer -> Result) |
| 4. Juice | `godot-particles`, `godot-tweening` | Making learning feel rewarding |
| 5. Meta | `godot-scene-management` | Navigating between lessons and map |

## Architecture Overview

### 1. The Curtain (Question Manager)
Manages the flow of a single "Lesson" or "Quiz".

```gdscript
# quiz_manager.gd
extends Node

var current_question: QuestionData
var correct_streak: int = 0

func submit_answer(answer_index: int) -> void:
    if current_question.is_correct(answer_index):
        handle_success()
    else:
        handle_failure()

func handle_success() -> void:
    correct_streak += 1
    EffectManager.play_confetti()
    StudentProfile.add_xp(current_question.topic, 10)
    load_next_question()

func handle_failure() -> void:
    correct_streak = 0
    # Spaced Repetition: Add this question back to the queue
    question_queue.push_back(current_question)
    show_explanation()
```

### 2. The Student Profile
Persistent data tracking mastery.

```gdscript
# student_profile.gd
class_name StudentProfile extends Resource

@export var topic_mastery: Dictionary = {} # "math_add": 0.5 (50%)
@export var total_xp: int = 0
@export var badges: Array[String] = []

func get_mastery(topic: String) -> float:
    return topic_mastery.get(topic, 0.0)
```

### 3. Curriculum Tree
Defining the dependency graph of knowledge.

```gdscript
# curriculum_node.gd
extends Resource
@export var id: String
@export var title: String
@export var required_topics: Array[String] # Prereqs
```

### 4. Mastery-Based Matchmaking (Profiles)
Use custom Resources for student profiles to track and react to mastery changes.

```gdscript
# student_profile.gd (Resource)
class_name StudentProfile extends Resource
signal mastery_up(new_tier: int)

@export var score: int = 0:
    set(v):
        score = v
        if score > threshold: _promote()

func _promote():
    tier += 1
    mastery_up.emit(tier)
```

### 5. Visual Analytics (Custom Monitors)
Inject metrics into the Godot Editor Debugger without building complex UI.

```gdscript
# analytics_manager.gd (Autoload)
func _ready():
    if not Engine.is_editor_hint():
        Performance.add_custom_monitor("edu/correct_rate", _get_rate)

func _get_rate():
    return float(correct) / total_attempts
```

### 6. Hint-Cooldown (Progressive Disclosure)
Decouple time-based hint reveals using signals.

```gdscript
# hint_manager.gd
signal hint_revealed(text: String)
var _timer: float = 0.0

func _process(delta):
    _timer += delta
    if _timer >= cooldown:
        hint_revealed.emit(hints.pop_front())
        _timer = 0.0
```

## Key Mechanics Implementation

### Adaptive Difficulty algorithm
If player is crushing it, give harder questions. If struggling, ease up.

```gdscript
func get_next_question() -> QuestionData:
    var player_rating = StudentProfile.get_rating(current_topic)
    # Target a 70% success rate for "Flow State"
    var target_difficulty = player_rating + 0.1 
    return QuestionBank.find_question(target_difficulty)
```

### Juice (The "Duolingo Effect")
Learning is hard. The game must heavily reward effort visually.
*   **Sound**: Satisfying "Ding!" on correct.
*   **Visuals**: Screen shake, godot-particles, multiplier popup.
*   **UI**: Progress bars filling up smoothly (Tweening).

## Godot-Specific Tips

*   **RichTextLabel**: Essential for mathematical formulas or coloring keywords (BBCode).
*   **Drag and Drop**: Godot's Control nodes have built-in `_get_drag_data` and `_drop_data` methods. Perfect for "Match the items" puzzles.
*   **Localization**: Educational games often need to support multiple languages. Use Godot's `TranslationServer` from day one.

## Common Pitfalls

1.  **Chocolate-Covered Broccoli**: Game loop and Learning loop are separate. **Fix**: Make the mechanic *be* the learning (e.g., Typing of the Dead).
2.  **Punishing Failure**: Player gets "Game Over" for being wrong. **Fix**: Never fail state. Just "Try Again" or "Here's a hint".
3.  **Wall of Text**: Too much reading. **Fix**: Interaction first. Show, don't tell.


## Reference
- Master Skill: [godot-master](../godot-master/SKILL.md)
