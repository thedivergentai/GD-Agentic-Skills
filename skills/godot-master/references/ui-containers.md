---
name: godot-ui-containers
description: "Expert blueprint for responsive UI layouts using Container nodes (HBoxContainer, VBoxContainer, GridContainer, MarginContainer, ScrollContainer, HFlowContainer, SubViewportContainer). Covers size flags, anchors, split containers, virtual_list pooling, stretch_shrink previews, and dynamic layouts. Use when building adaptive interfaces OR implementing responsive menus. Keywords: Container, HBoxContainer, VBoxContainer, GridContainer, HFlowContainer, SubViewportContainer, virtual_list, stretch_shrink, size_flags, EXPAND_FILL, anchors, responsive."
---

## Godot 4.7 Baseline

- Expert patterns in this skill target **Godot 4.7+** (stable, 2026-06-18).
- Consult the [Godot 4.7 migration guide](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html) when upgrading projects from 4.6.
- **NEVER** assume 4.6 defaults (stretch mode, audio area_mask, RichTextLabel percent flags) without checking 4.7 migration notes.

# UI Containers

Container auto-layout, size flags, anchors, and split ratios define responsive UI systems.

## Decision Tree: Container type → script

| Need | Prefer | MANDATORY script |
|------|--------|------------------|
| Breakpoint shell / full-screen adaptive root | Margin + Box containers | [responsive_layout_builder.gd](../scripts/ui_containers_responsive_layout_builder.gd) |
| Fixed columns that change with width | `GridContainer` | [responsive_grid.gd](../scripts/ui_containers_responsive_grid.gd) / [responsive_inventory_grid.gd](../scripts/ui_containers_responsive_inventory_grid.gd) |
| Wrapping chips / tags | `HFlowContainer` | [responsive_tag_cloud.gd](../scripts/ui_containers_responsive_tag_cloud.gd) |
| Thousands of scroll rows | Virtual pool (not raw children) | [virtual_list.gd](../scripts/ui_containers_virtual_list.gd) |
| Log/chat autoscroll | `ScrollContainer` | [terminal_autoscroll.gd](../scripts/ui_containers_terminal_autoscroll.gd) |
| 3D character/item preview in UI | `SubViewportContainer` | [viewport_3d_preview.gd](../scripts/ui_containers_viewport_3d_preview.gd) |
| Deep nesting causing layout spikes | Anchors/offsets instead | [performance_anchor_layout.gd](../scripts/ui_containers_performance_anchor_layout.gd) |
| Radial/wheel menus | Custom `Container` | [custom_radial_container.gd](../scripts/ui_containers_custom_radial_container.gd) |


## Do-NOT-Load (by scenario)

| Scenario | Load | Do NOT load |
|----------|------|-------------|
| Inventory / shop grid | `responsive_grid.gd` / `responsive_inventory_grid.gd` | `custom_radial_container.gd`, `viewport_3d_preview.gd` |
| Tag cloud / chip wrap | `responsive_tag_cloud.gd` | Grid column scripts, `virtual_list.gd` |
| Thousands of log/chat rows | `virtual_list.gd` + `terminal_autoscroll.gd` | Inventory/radial/viewport scripts |
| 3D item/character preview | `viewport_3d_preview.gd` | Radial menu + inventory grid scripts |
| Radial / wheel menu | `custom_radial_container.gd` | Virtual list + tag cloud |
| Deep nesting / layout spikes | `performance_anchor_layout.gd` | Full responsive builder catalog |

## Available Scripts

### [virtual_list.gd](../scripts/ui_containers_virtual_list.gd)
Virtual List Pooling — recycle a small Control pool + spacer height for O(1) ScrollContainer rows.

### [responsive_layout_builder.gd](../scripts/ui_containers_responsive_layout_builder.gd)
Expert container builder with breakpoint-based responsive layouts.

### [responsive_grid.gd](../scripts/ui_containers_responsive_grid.gd)
Auto-adjusting GridContainer that changes column count based on available width.

### [responsive_inventory_grid.gd](../scripts/ui_containers_responsive_inventory_grid.gd)
Expert logic for dynamic Grid columns based on available width and item minimum size.

### [terminal_autoscroll.gd](../scripts/ui_containers_terminal_autoscroll.gd)
Safe ScrollContainer management. Handles the common "one-frame delay" bug when adding logs or chat.

### [viewport_3d_preview.gd](../scripts/ui_containers_viewport_3d_preview.gd)
High-performance 3D-in-UI setup. Uses `stretch_shrink` and `transparent_bg` for character previews.

### [dynamic_tab_manager.gd](../scripts/ui_containers_dynamic_tab_manager.gd)
Pattern for dynamic tab spawning, custom titles, and tab closing logic.

### [responsive_tag_cloud.gd](../scripts/ui_containers_responsive_tag_cloud.gd)
Wrapping item lists using `HFlowContainer`, essential for tag clouds and responsive menus.

### [performance_anchor_layout.gd](../scripts/ui_containers_performance_anchor_layout.gd)
Optimization architecture. Replaces deep container nesting with lightweight Anchor and Offset logic.

### [custom_radial_container.gd](../scripts/ui_containers_custom_radial_container.gd)
Expert custom container logic implementing a radial/circle layout via `NOTIFICATION_SORT_CHILDREN`.

### [animated_container_shuffle.gd](../scripts/ui_containers_animated_container_shuffle.gd)
Dynamic sibling reordering and animation logic for interactive UI lists.

### [aspect_ratio_mini_map.gd](../scripts/ui_containers_aspect_ratio_mini_map.gd)
Enforcing strict aspect ratios (e.g. 1:1, 16:9) across fluid window resizes using `AspectRatioContainer`.

### [container_size_flags_pro.gd](../scripts/ui_containers_container_size_flags_pro.gd)
Advanced sizing logic using `SIZE_EXPAND_FILL` and `stretch_ratio` for weighted layouts.

## NEVER Do in UI Containers

- NEVER ignore **`mouse_filter`** properties; strictly set to `PASS` or `IGNORE` on overlay containers to prevent them from blocking clicks to underlying buttons.
- NEVER instantiate thousands of nodes in a `ScrollContainer`; strictly use **Virtual List Pooling** — **MANDATORY read** [virtual_list.gd](../scripts/ui_containers_virtual_list.gd) (`VScrollBar` hook + single spacer child) for O(1) rendering performance.
- NEVER manually calculate card dimensions for responsive grids; strictly use an **`AspectRatioContainer`** to lock proportions (e.g., 2:3 ratio) while allowing parent containers to handle scaling.
- **NEVER manually set child `position` or `size` in a Container** — Containers override child transforms during `queue_sort()`. Use `custom_minimum_size` or `size_flags` instead [1].
- **NEVER forget `size_flags` for expansion** — Default is `SIZE_SHRINK_BEGIN`. Children will stay tiny unless you set `SIZE_EXPAND_FILL` for responsive containers.
- **NEVER use `GridContainer` without setting `columns`** — Default is 1, creating a simple vertical list. For responsive wrapping, use `HFlowContainer` instead [8].
- **NEVER nest containers too deeply (10+ levels)** — Heavy nesting causes layout recalculation spikes. Replace intermediate containers with Anchor Layouts for static padding [16].
- **NEVER skip separation overrides** — Default theme separation is often too tight. Use `add_theme_constant_override("separation", value)` for professional breathing room.
- **NEVER use `ScrollContainer` without a minimum size** — Without it, the container may collapse to zero or expand infinitely, breaking the scroll mechanism.
- **NEVER scroll to a new child on the same frame it was added** — The layout hasn't updated yet. You MUST `await get_tree().process_frame` before setting `scroll_vertical` [5].
- **NEVER scale a `SubViewportContainer` to change its size** — This distorts the rendered contents. Adjust margins or use `stretch` and `stretch_shrink` properties instead [2].
- **NEVER leave `mouse_filter` on default for layered Viewports** — Input events might not reach children. Use `MOUSE_FILTER_PASS` or `STOP` to ensure events drill down [6].
- **NEVER use `GridContainer` for responsive wrapping** — Use `HFlowContainer` if you want items to wrap based on width. GridContainer enforces a strict column count [7].
- **NEVER animate `position` directly inside a container** — Use `Tween` on `custom_minimum_size` to smoothly "push" siblings during transitions [1].

---

## Godot 4.7: Control

- **Offset transform** on Control nodes — visual offset without breaking layout constraints.
- **TextureRect** can tile **AtlasTexture** regions as repeating textures.
- Line drawing: antialiasing feather removed — lines render thinner; increase width if needed.

## Expert Layout Patterns

### 1. Split-Screen-Container (Dynamic)
Standard pattern for local multiplayer or comparisons using `HSplitContainer`.

```gdscript
# split_screen.gd
func setup_split(v1: SubViewport, v2: SubViewport):
    var hsplit = HSplitContainer.new()
    var c1 = SubViewportContainer.new()
    c1.stretch = true # Resize viewport to match container
    c1.add_child(v1)
    hsplit.add_child(c1)
    # repeat for c2/v2...
```

### 2. Virtual List ScrollContainer (Pooling)
High-performance list for thousands of items. **MANDATORY**: implement via [virtual_list.gd](../scripts/ui_containers_virtual_list.gd) (`setup_pool` + `set_data`) — do not paste a one-off scroll recycler inline.

### 3. Aspect-Ratio-Locked Cards
Responsive cards that maintain proportions (e.g., 2:3) in any grid or flow container.

```gdscript
# card_grid.gd
func add_card(texture: Texture2D):
    var arc = AspectRatioContainer.new()
    arc.ratio = 0.66 # 2:3 proportions
    arc.stretch_mode = AspectRatioContainer.STRETCH_FIT
    
    var tr = TextureRect.new()
    tr.texture = texture
    tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
    tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
    
    arc.add_child(tr)
    grid_container.add_child(arc)
```

> Size-flag recipes: **MANDATORY** [container_size_flags_pro.gd](../scripts/ui_containers_container_size_flags_pro.gd) — do not paste beginner `SIZE_EXPAND_FILL` tutorials inline.

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Using Containers](https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html) — Canonical guide for box/grid/flow/split containers, size flags, and when Containers override child transforms.
- [Size and anchors](https://docs.godotengine.org/en/stable/tutorials/ui/size_and_anchors.html) — Anchor presets and offsets for responsive Control placement when you intentionally skip deep Container nesting.
- [Control node gallery](https://docs.godotengine.org/en/stable/tutorials/ui/control_node_gallery.html) — Visual catalog of Control/Container types so agents pick HFlow vs Grid vs Split correctly.
- [Custom GUI controls](https://docs.godotengine.org/en/stable/tutorials/ui/custom_gui_controls.html) — NOTIFICATION_SORT_CHILDREN and fit_child_in_rect patterns required for custom radial/layouts.
- [GUI navigation](https://docs.godotengine.org/en/stable/tutorials/ui/gui_navigation.html) — Focus neighbors and keyboard/gamepad traversal across container-built menus.
- [Multiple resolutions](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html) — Stretch modes and content scale that interact with container-driven responsive UI.
- [Control](https://docs.godotengine.org/en/stable/classes/class_control.html) — size_flags_*, custom_minimum_size, mouse_filter, and anchors APIs every layout script uses.
- [Container](https://docs.godotengine.org/en/stable/classes/class_container.html) — Base sort lifecycle (queue_sort / SORT_CHILDREN) that forbids manual child position/size.
- [ScrollContainer](https://docs.godotengine.org/en/stable/classes/class_scrollcontainer.html) — Scroll bars, minimum size pitfalls, and post-frame scroll_vertical updates for log/chat UIs.
- [HFlowContainer](https://docs.godotengine.org/en/stable/classes/class_hflowcontainer.html) — Width-based wrapping for tag clouds and chip lists (prefer over fixed-column GridContainer).
- [AspectRatioContainer](https://docs.godotengine.org/en/stable/classes/class_aspectratiocontainer.html) — Lock card/minimap proportions under fluid parent sizes.
- [SubViewportContainer](https://docs.godotengine.org/en/stable/classes/class_subviewportcontainer.html) — stretch / stretch_shrink for 3D-in-UI previews without scaling distortion.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — Scene tree ownership, Control roots, and project layout conventions every responsive menu assumes before wiring containers.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — Typed Control APIs, `@onready`, and safe child rebuild loops used when building grids/tabs at runtime.
- [godot-signal-architecture](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md) — Resize, tab-changed, and inventory-refresh signals should flow signal-up / call-down so layout scripts never own game state.

#### Complements
- [godot-ui-theming](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-theming/SKILL.md) — Theme constants (`separation`, margins) and type variations style container chrome without hardcoding colors in layout code.
- [godot-ui-rich-text](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-rich-text/SKILL.md) — RichTextLabel minimum sizes and BBCode content drive ScrollContainer height; pair after the layout shell exists.
- [godot-tweening](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-tweening/SKILL.md) — Animate `custom_minimum_size` / reorder feedback instead of tweening `position` inside Containers.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — Focus, mouse_filter, and action maps for interactive lists/tabs built from Containers.
- [godot-adapt-desktop-to-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-adapt-desktop-to-mobile/SKILL.md) — Breakpoint-driven column counts and safe-area margins compose with responsive Grid/HFlow builders.
- [godot-inventory-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-inventory-system/SKILL.md) — Inventory grids consume responsive column logic; containers present slots, inventory owns item truth.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — Virtual list pooling and shallow anchor layouts when ScrollContainer would otherwise spawn thousands of Controls.

#### Downstream / consumers
- [godot-dialogue-system](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-dialogue-system/SKILL.md) — Dialogue choice lists and history panels are Scroll/VBox layouts that reuse autoscroll and separation patterns.
- [godot-genre-card-game](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-genre-card-game/SKILL.md) — Hand arcs, drag layers, and deck UIs assemble AspectRatio/HFlow containers around card Resources.
- [godot-composition-apps](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-composition-apps/SKILL.md) — Tooling/app UIs reuse the same Container size-flag and split patterns outside gameplay HUDs.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — Router and mirrored module entry for UI Containers when agents start from the library index.
