# Quest System Deep Dive (load on demand)

> **MANDATORY** when wiring Quest/Objective/Manager/UI beyond [quest_resource.gd](../scripts/quest_system_quest_resource.gd) + [quest_manager_singleton.gd](../scripts/quest_system_quest_manager_singleton.gd). Prefer bundled scripts over inline class dumps.

## Core Resource shapes

```gdscript
class_name Quest extends Resource
signal progress_updated(objective_id: StringName, progress: int)
signal completed

@export var quest_id: StringName
@export var objectives: Array[QuestObjective] = []

func is_complete() -> bool:
    return objectives.all(func(obj): return obj != null and obj.is_complete())
```

```gdscript
class_name QuestObjective extends Resource
enum Type { KILL, COLLECT, TALK, REACH }

@export var objective_id: StringName
@export var required_amount: int = 1
var current_amount: int = 0

func progress(amount: int = 1) -> void:
    current_amount = mini(current_amount + amount, required_amount)
```

## Manager accept / progress / complete

```gdscript
func accept_quest(quest: Quest) -> void:
    if quest.quest_id in completed_quests:
        return
    active_quests.append(quest)
    quest.completed.connect(_on_quest_completed.bind(quest), CONNECT_ONE_SHOT)
```

> **CAUTION:** Disconnect completion Callables when quest leaves active set — double rewards if signals fire twice.

## Triggers (decoupled)

```gdscript
# enemy.gd — prefer kill_objective_trigger.gd / EventBus
func _on_died() -> void:
    QuestManager.update_objective(&"kill_bandits", 1)
```

**NEVER** hardcode quest logic inside enemy scripts — use [kill_objective_trigger.gd](../scripts/quest_system_kill_objective_trigger.gd).

## Quest UI tracker

Rebuild from manager signals only — [quest_ui_tracker.gd](../scripts/quest_system_quest_ui_tracker.gd). UI must not compute progress formulas.

## Elite: NavMesh waypoint helper

[quest_waypoint_helper.gd](../scripts/quest_system_quest_waypoint_helper.gd) — update `NavigationAgent3D.target_position` only when objectives change (not every frame).

## Elite: prerequisite graph

[branching_quest_data.gd](../scripts/quest_system_branching_quest_data.gd) — `@export var prerequisites: Array[QuestData]` inspected in editor instead of hardcoded unlock chains.

## Elite: thread-safe progress

[quest_conflict_resolver.gd](../scripts/quest_system_quest_conflict_resolver.gd) — `Mutex` around shared progress maps when networking or parallel combat threads update the same objective id; defer UI signals to main thread.

## Persistence

Save id maps + counts — [quest_persistence_loader.gd](../scripts/quest_system_quest_persistence_loader.gd). **NEVER** serialize live Quest Resource graphs with mutable `current_amount` on shared `.tres` files.

## Best practices

1. Signal-driven updates — no `_process` polling.
2. `StringName` ids — silent failures on typos with plain strings.
3. Rewards via inventory/economy signals — not inside Quest Resource.
