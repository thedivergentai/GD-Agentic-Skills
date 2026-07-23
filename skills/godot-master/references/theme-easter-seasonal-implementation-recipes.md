# Seasonal implementation recipes

Gate first — [easter_seasonal_activation_gate.gd](../scripts/theme_easter_easter_seasonal_activation_gate.gd).

## Custom cursor

```gdscript
func _apply_easter_cursor() -> void:
    var cursor_img := preload("res://ui/easter/cursor_bunny.png")
    Input.set_custom_mouse_cursor(cursor_img, Input.CURSOR_ARROW, Vector2(16, 16))
```

MANDATORY: [easter_custom_cursor_manager.gd](../scripts/theme_easter_easter_custom_cursor_manager.gd) for hotspot discipline.

## Themed SFX map

`Dictionary` of original name → seasonal `AudioStream` — [easter_seasonal_audio_swapper.gd](../scripts/theme_easter_easter_seasonal_audio_swapper.gd).

## Spring environment tween

Tween `Environment` ambient / tonemap / fog — never hard-cut mid-frame (see SKILL.md World-Environment-Override).

## Palette tokens

Import from [easter_pastel_color_palette.gd](../scripts/theme_easter_easter_pastel_color_palette.gd) — do not paste ad-hoc hex lists in features.
