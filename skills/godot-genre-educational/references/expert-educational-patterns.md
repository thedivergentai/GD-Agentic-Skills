# Expert patterns (load on demand)

> **MANDATORY** when implementing beyond Golden Path / Decision Trees. Do not paste into SKILL.md or scenes from memory.

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
