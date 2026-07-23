# Theme authoring recipes

## Project-wide theme

1. Project Settings → GUI → Theme
2. Author in Theme editor
3. Assign at root Control — children inherit

## StyleBoxFlat button

```gdscript
var style := StyleBoxFlat.new()
style.bg_color = Color.DARK_BLUE
style.set_corner_radius_all(5)
$Button.add_theme_stylebox_override("normal", style)
```

> [!CAUTION]
> Runtime tint shared Theme StyleBoxes only after `duplicate()` — [dynamic_stylebox_color.gd](../scripts/dynamic_stylebox_color.gd).

## Custom font

```gdscript
var font := load("res://fonts/my_font.ttf")
$Label.add_theme_font_override("font", font)
$Label.add_theme_font_size_override("font_size", 24)
```

## Focus manager joypad detection (legacy detail)

Prefer [focus_prompt_icon_swapper.gd](../scripts/focus_prompt_icon_swapper.gd) over scattering `Input.get_joy_name` paths in Controls.
