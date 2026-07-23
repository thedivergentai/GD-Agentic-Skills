# Progression & Unlocks

```gdscript
class_name UnlockSystem
extends Node

var unlocks: Dictionary = {
    "basic_facility": true,
    "advanced_facility": false,
    "marketing": false,
    "automation": false
}

var unlock_conditions: Dictionary = {
    "advanced_facility": {"money_earned": 50000},
    "marketing": {"reputation": 70},
    "automation": {"workers_hired": 20}
}

var progress: Dictionary = {
    "money_earned": 0.0,
    "workers_hired": 0
}

func check_unlocks() -> Array[String]:
    var newly_unlocked: Array[String] = []
    
    for unlock in unlock_conditions:
        if unlocks[unlock]:
            continue  # Already unlocked
        
        var conditions := unlock_conditions[unlock]
        var all_met := true
        
        for condition in conditions:
            if progress.get(condition, 0) < conditions[condition]:
                all_met = false
                break
        
        if all_met:
            unlocks[unlock] = true
            newly_unlocked.append(unlock)
    
    return newly_unlocked
```

---
