# Container layout recipes

## VBox separation

```gdscript
$VBoxContainer.add_theme_constant_override("separation", 10)
```

## Responsive anchors

```gdscript
$MarginContainer.set_anchors_preset(Control.PRESET_FULL_RECT)
$MarginContainer.add_theme_constant_override("margin_left", 20)
```

## Size flags

```gdscript
button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
```

Weighted layouts: [container_size_flags_pro.gd](../scripts/container_size_flags_pro.gd).

## Split screen

See Expert Layout Patterns in SKILL.md — `HSplitContainer` + `SubViewportContainer.stretch = true`.

## Virtual list

**MANDATORY** [virtual_list.gd](../scripts/virtual_list.gd) — do not paste one-off pool recyclers.
