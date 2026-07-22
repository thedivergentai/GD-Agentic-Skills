---
name: godot-ui-theming
description: "Expert blueprint for UI themes using Theme resources, StyleBoxes, custom fonts, and theme overrides for consistent visual styling. Covers StyleBoxFlat/Texture, theme inheritance, dynamic theme switching, and font variations. Use when implementing consistent UI styling OR supporting multiple themes. Keywords Theme, StyleBox, StyleBoxFlat, add_theme_override, font, theme inheritance, dark mode."
---

# UI Theming

Theme resources, StyleBox styling, font management, and override system define consistent UI visual identity.

## Available Scripts

### [global_theme_manager.gd](../scripts/ui_theming_global_theme_manager.gd)
Expert theme manager with dynamic switching, theme variants, and fallback handling.

### [ui_scale_manager.gd](../scripts/ui_theming_ui_scale_manager.gd)
Runtime theme switching and DPI/Resolution scale management.

### [theme_swapper.gd](../scripts/ui_theming_theme_swapper.gd)
Dynamic Dark/Light mode implementation using cascading theme root propagation.

### [danger_button_assignment.gd](../scripts/ui_theming_danger_button_assignment.gd)
Expert use of `theme_type_variation` for semantic UI styling without scene duplication.

### [dynamic_stylebox_color.gd](../scripts/ui_theming_dynamic_stylebox_color.gd)
Safe runtime StyleBox modification. Demonstrates the critical `duplicate()` pattern for isolated overrides.

### [procedural_theme_safe.gd](../scripts/ui_theming_procedural_theme_safe.gd)
Reliable theming for generated UI elements using `NOTIFICATION_THEME_CHANGED`.

### [custom_chart_drawing.gd](../scripts/ui_theming_custom_chart_drawing.gd)
Pattern for reading active Theme properties (colors, fonts) in custom `_draw()` logic.

### [theme_isolation.gd](../scripts/ui_theming_theme_isolation.gd)
Ensuring HUD consistency by isolating nodes from parent themes and referencing Project Defaults.

### [pulsating_ui_theme.gd](../scripts/ui_theming_pulsating_ui_theme.gd)
Animating UI styles via Tweens. Targets StyleBox properties directly after duplication.

### [crisp_ui_scaler.gd](../scripts/ui_theming_crisp_ui_scaler.gd)
High-quality resolution-independent scaling using `content_scale_factor` to maintain font crispness.

### [memory_safe_custom_drawing.gd](../scripts/ui_theming_memory_safe_custom_drawing.gd)
Fixing the "disappearing stylebox" bug by caching resources at the class level for the RenderingServer.

### [rtl_theme_mirroring.gd](../scripts/ui_theming_rtl_theme_mirroring.gd)
Bi-directional (RTL/LTR) UI support. Swaps theme variants dynamically based on layout direction.

## NEVER Do in UI Theming

- **NEVER create StyleBox in `_ready()` for many nodes** — Instantiating `StyleBoxFlat.new()` 100 times creates 100 unique objects. Use a Theme resource for shared heritage.
- **NEVER forget theme inheritance** — Parent themes are ignored if a child has its own theme. Apply themes at the root and use `theme_type_variation` for specific overrides.
- **NEVER hardcode colors in StyleBox** — Use `theme.get_color()` to maintain a single source of truth for your palette.
- **NEVER use `add_theme_override` for global styles** — This is brittle. Define styles in a Theme resource for automatic propagation across the project.
- **NEVER modify theme resources during `_draw()` OR `_process()`** — Frequent layout recalculations will severely degrade performance.
- **NEVER assign `StyleBoxEmpty` to focus styles without a fallback** — This invisibly breaks controller/keyboard navigation [1]. Always provide a visible alternative (e.g. scale change).
- **NEVER use standard `set()` for theme properties** — Calling `node.set("font_color", red)` fails. You MUST use the dedicated `add_theme_color_override()` API [3].
- **NEVER use `expand_margin_*` to increase clickable area** — It only expands the VISUAL bounds. Use `content_margin_*` on the StyleBox or adjust the Control's size to ensure input works [5].
- **NEVER define StyleBoxes as local variables inside `_draw()`** — They will be garbage collected before the RenderingServer can finish drawing them [7]. Store at class level.
- **NEVER duplicate scenes/themes just to change one color** — Use `theme_type_variation` to create lightweight derived styles (e.g. "DangerButton") within the same Theme [8].
- **NEVER skip `corner_radius_all` shortcut** — It's a useful shorthand for uniform rounding in `StyleBoxFlat`.

---

1. Project Settings → **GUI → Theme**
2. Create new Theme resource
3. Assign to root Control node
4. All children inherit theme

## Godot 4.7: UI Theming

- **Control offset transform** for inspector-driven visual tweaks without relayout.
- `ResourceImporterDynamicFont.hinting` default changed to **3** — verify font crispness on target DPI.
- **GradientTexture2D** supports **conic** gradients.

## StyleBox Pattern

```gdscript
# Create StyleBoxFlat for buttons
var style := StyleBoxFlat.new()
style.bg_color = Color.DARK_BLUE
style.corner_radius_top_left = 5
style.corner_radius_top_right = 5
style.corner_radius_bottom_left = 5
style.corner_radius_bottom_right = 5

# Apply to button
$Button.add_theme_stylebox_override("normal", style)
```

## Font Loading

```gdscript
# Load custom font
var font := load("res://fonts/my_font.ttf")
$Label.add_theme_font_override("font", font)
$Label.add_theme_font_size_override("font_size", 24)
```

## Expert Theming Patterns

### 1. Shared-Color-Palette (The Static Pattern)
Maintain a single source of truth for UI colors accessible to both the Theme Editor and GDScript.
- **Theme Setup**: In your `.theme` file, create a custom type called `Palette` and add `Color` items (e.g., `primary`, `danger`, `accent`).
- **Static Access**: Use a `SharedPalette` class with `static func get_primary() -> Color` that pulls from `ThemeDB.get_project_theme()`. This ensures UI scripts and the visual theme never drift.

### 2. Theme-Type-Variations
Avoid duplicating button scenes or styleboxes for variants like "Danger" or "Ghost" styles.
- **Implementation**: In the Theme Editor, create a new **Type Variation**. Set its **Base Type** to `Button`.
- **Inheritance**: The variation inherits all properties from the base type. You only override what's different (e.g., set `font_color` to red for `DangerButton`).
- **Usage**: Assign via code `node.theme_type_variation = &"DangerButton"` or via the Inspector dropdown.

### 3. Runtime-Theme-Swapping (Accessibility)
Efficiently switch the visual style of the entire game for Light, Dark, or High-Contrast modes.
- **Cascading Updates**: Assign a new `Theme` resource to the **root** Control node. Godot propagates this to every descendant.
- **Accessibility**: Use `NOTIFICATION_THEME_CHANGED` to update elements that don't support automatic theming (like custom `_draw()` logic or RichText effects).
- **High-Contrast**: Ensure High-Contrast themes use pure black/white and thicker focus outlines for low-vision accessibility.

### 4. Themed-Asset-Loading (Seasonal Variants)
Godot Themes support more than just colors and fonts—they can store textures.
- **Setup**: Define UI icons as **Icon** items within separate Theme resources (e.g., `halloween.theme`, `christmas.theme`).
- **Swapping**: Swapping the root theme resource instantly cascades the new icon textures across all buttons and panels without manual logic.

### 5. UI-Focus-Manager (Dynamic Controller Icons)
Standard focus styles are static. For professional UX, swap controller icons based on the connected device.
- **Detection**: Use `Input.get_joy_name(device)` to identify the controller (e.g., "PS4 Controller", "Xbox One Controller").
- **Implementation**:
    ```gdscript
    func _on_joy_connection_changed(device: int, connected: bool):
        if connected:
            var joy_name = Input.get_joy_name(device).to_lower()
            if "xbox" in joy_name:
                _set_prompt_icons("res://ui/icons/xbox/")
            elif "playstation" in joy_name or "ps" in joy_name:
                _set_prompt_icons("res://ui/icons/ps/")
    ```
- **Interpolation**: When a node gains focus, use a `Tween` to move a dedicated "Highlight Panel" to the node's `get_global_rect()`.

### 6. Asset-Dependency-Audit (Draw-Call Reduction)
Ensuring UI textures are optimized for rendering performance.
- **Atlas Packing**: Use `AtlasTexture` to crop small UI elements from a singular large sheet. This reduces VRAM state changes and minimizes draw calls [14].
- **Compression Policy**:
    - **2D/Pixel Art**: Use **Lossless** compression to avoid blurry artifacts [15].
    - **UI Backgrounds**: Use **Lossy** or **Basis Universal** for large illustrations to save disk space without decreasing VRAM usage [15].
- **Audit**: Use `ResourceLoader.get_dependencies(scene_path)` to ensure no uncompressed raw assets (e.g. `.png`) are leaking into the final export [19].

## Reference
- [Godot Docs: GUI Theming](https://docs.godotengine.org/en/stable/tutorials/ui/gui_skinning.html)


### Related
- Master Skill: [godot-master](../SKILL.md)
