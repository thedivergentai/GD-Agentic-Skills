extends OptionButton
class_name ResolutionDropdownManager

## Expert PC Resolution Options
## PC games must provide native resolution choices that respect the monitor's capabilities.
## Mobile simply forces the native OS resolution, but windowed PC needs explicit arrays.

const SUPPORTED_ASPECTS = [
    Vector2i(1920, 1080), # 16:9
    Vector2i(2560, 1440), # 16:9 1440p
    Vector2i(3840, 2160), # 16:9 4K
    Vector2i(3440, 1440), # 21:9 Ultrawide
    Vector2i(1280, 720)   # 16:9 720p (for absolute potatoes)
]

func _ready() -> void:
    item_selected.connect(_on_resolution_selected)
    _populate_resolutions()

func _populate_resolutions() -> void:
    self.clear()
    
    # Query the physical monitor size
    var screen_size = DisplayServer.screen_get_size()
    
    var index = 0
    for res in SUPPORTED_ASPECTS:
        # Don't offer resolutions larger than the user's actual monitor
        if res.x <= screen_size.x and res.y <= screen_size.y:
            self.add_item(str(res.x) + " x " + str(res.y), index)
            self.set_item_metadata(index, res)
            index += 1

func _on_resolution_selected(index: int) -> void:
    var res = self.get_item_metadata(index)
    
    # Apply to the window frame
    DisplayServer.window_set_size(res)
    
    # Center the window back on the screen after scaling
    var screen_center = DisplayServer.screen_get_position() + (DisplayServer.screen_get_size() / 2)
    var new_window_pos = screen_center - (res / 2)
    DisplayServer.window_set_position(new_window_pos)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html
# - https://docs.godotengine.org/en/stable/classes/class_displayserver.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md — layout survival across resolution changes
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md — stretch mode / content scale
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-mobile-to-desktop/SKILL.md
# =============================================================================
