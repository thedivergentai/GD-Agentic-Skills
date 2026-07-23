# Secrets Meta Patterns (load on demand)

> **MANDATORY** when building achievement galleries, lore journals, or ghosted-secret visibility — not for basic combo/spam/look-at triggers (use `scripts/secret_*`).

## When to open this file
- Gallery / achievement bridge over `SecretData` Resources
- Lore journal UI that appends BBCode on discovery
- Ghosting found secrets (partial transparency + disabled collision)

## Do NOT Load
- Basic cheat buffers, spam thresholds, or dot-product look-at — stay in SKILL.md decision tree + `secret_*` scripts
- Full Resource authoring — pair with godot-resource-data-patterns when defining new `.tres` types

---

## 1. Secret Flag Tracker (Achievement Bridge)

Use `Resource` objects to track discovery states and emit signals that bridge to your achievement system.

```gdscript
# secret_data.gd
class_name SecretData extends Resource
@export var id: StringName
@export var is_found := false:
    set(v):
        is_found = v
        emit_changed()

# secret_manager.gd (AutoLoad)
func _on_secret_changed(data: SecretData):
    if data.is_found:
        achievement_system.unlock(data.id)
```

## 2. Environmental Storytelling Lore History

Extend secret resources to include lore snippets. Record a history of discovered items to populate a player journal using `RichTextLabel` with BBCode.

```gdscript
# lore_item.gd
class_name LoreItem extends SecretData
@export_multiline var description: String

# lore_journal_ui.gd
func add_entry(lore: LoreItem):
    journal_label.text += "\n[b]Discovery:[/b] " + lore.description
```

## 3. Ghosting System (Collected Secret Visibility)

Instead of deleting found secrets, render them with partial transparency and disable their collision. This informs players that the area has been "cleared."

```gdscript
# ghostable_secret.gd
func _ready():
    if secret_data.is_found:
        _apply_ghost_visuals()

func _apply_ghost_visuals():
    # 2D: Use modulate alpha
    modulate.a = 0.3
    # 3D: Adjust GeometryInstance3D transparency
    # transparency = 0.7

    # Disable monitoring safely
    set_deferred("monitoring", false)
```
