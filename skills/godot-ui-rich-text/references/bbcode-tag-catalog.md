# BBCode tag catalog (non-obvious)

Skip `[b]`/`[i]` tutorials — quick reference for agents.

```bbcode
[b]Bold[/b] [i]Italic[/i] [u]Underline[/u]
[color=red]Red[/color] [color=#00FF00]Hex[/color]
[center]Centered[/center]
[img]res://icon.png[/img]
[url=payload]Clickable[/url]
```

## Godot 4.7 images

Use `width_unit` / `height_unit` + `RichTextLabel.ImageUnit` — never legacy percent booleans.

Scale with [rich_text_image_scaler.gd](../scripts/rich_text_image_scaler.gd).

## User chat

**MANDATORY** [rich_text_bbcode_sanitizer.gd](../scripts/rich_text_bbcode_sanitizer.gd) before assigning player text.
