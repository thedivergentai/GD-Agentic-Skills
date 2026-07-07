# Godot 4.7 Migration Digest — GDSkills Upgrade Reference

> **Source:** [Upgrading from Godot 4.6 to 4.7](https://docs.godotengine.org/en/4.7/tutorials/migrating/upgrading_to_godot_4.7.html)
> **Engine release:** 4.7-stable (2026-06-18)
> **GDSkills target:** v0.0.8 — all skills baseline **4.7+**

---

## New Features (Additive Knowledge)

| Feature | Description | Primary Skills |
|---------|-------------|----------------|
| **AreaLight3D** | Rectangular area light with soft shadows; replaces emissive+GI workarounds for screens, panels, billboards | `godot-3d-lighting`, `godot-3d-materials`, `godot-genre-horror` |
| **HDR output** | HDR display support on Windows, macOS, iOS, visionOS, Linux (Wayland) | `godot-platform-desktop`, `godot-platform-mobile`, `godot-3d-lighting`, `godot-export-builds` |
| **Asset Store** | Replaces Asset Library; threaded loading, ratings, zoom previews | `godot-project-foundations`, `godot-export-builds`, `godot-master` |
| **Control offset transform** | Visual UI offset without affecting layout constraints | `godot-ui-containers`, `godot-ui-theming`, `godot-composition-apps` |
| **Path3D snap-to-colliders** | Path points snap to collider surfaces | `godot-3d-world-building`, `godot-procedural-generation` |
| **3D vertex snapping** | Vertex/origin snap base setting (B key) | `godot-3d-world-building` |
| **Built-in virtual joystick** | Native mobile touch joystick (no plugin required) | `godot-platform-mobile`, `godot-adapt-desktop-to-mobile` |
| **Collapsible animation tracks** | Animation editor track collapse | `godot-animation-player`, `godot-animation-tree-mastery` |
| **GradientTexture2D conic** | Conic gradient generation | `godot-shaders-basics`, `godot-ui-theming` |
| **TextureRect atlas tiling** | Tile AtlasTexture regions as repeating textures | `godot-ui-containers` |
| **CollisionShape2D one-way direction** | One-way collision relative to shape orientation | `godot-2d-physics`, `godot-genre-platformer` |
| **Drawable Texture API** | New rendering texture API | `godot-shaders-basics`, `godot-3d-materials` |
| **Popup/dropdown search** | Dynamic search in editor popups | `godot-composition-apps` |

---

## Breaking Changes → Skill Mapping

### GUI / UI

| Change | GDScript OK? | Skills |
|--------|-------------|--------|
| `RichTextLabel.ImageUpdateMask.UPDATE_WIDTH_IN_PERCENT` → `UPDATE_WIDTH_UNIT` | ❌ | `godot-ui-rich-text`, `godot-dialogue-system`, `godot-genre-visual-novel` |
| `add_image`/`update_image`: `width_in_percent`/`height_in_percent` → `width_unit`/`height_unit` (`ImageUnit` enum) | ✔️ (rename) | Same as above |
| `add_image`/`update_image`: width/height `int` → `float` | ✔️ | Same as above |
| `Control.accessibility_live` type moved to `AccessibilityServer` | ✔️ | `godot-ui-containers` |

### Audio

| Change | GDScript OK? | Skills |
|--------|-------------|--------|
| `AudioEffectSpectrumAnalyzer.tap_back_pos` **removed** | ❌ | `godot-audio-systems` |
| `AudioStreamPlayer` default `area_mask` changed `1` → `0` (disabled) | Behavior | `godot-audio-systems`, `godot-2d-physics`, `godot-physics-3d` |

### Input

| Change | GDScript OK? | Skills |
|--------|-------------|--------|
| Mouse/keyboard device IDs: `0` → `InputEvent.DEVICE_ID_MOUSE` / `DEVICE_ID_KEYBOARD` | Behavior | `godot-input-handling`, `godot-platform-console` |

### Physics (Jolt)

| Change | Skills |
|--------|--------|
| `WorldBoundaryShape3D.plane.d` sign convention flipped vs 4.6 | `godot-physics-3d` |
| `SoftBody3D` mass default: per-point 1kg → total 1kg | `godot-physics-3d` |
| `SoftBody3D.linear_stiffness` application changed — retune required | `godot-physics-3d` |
| `Area3D` now reports `SoftBody3D` overlaps | `godot-physics-3d` |
| `body_set_shape_as_one_way_collision` adds `direction` param (2D) | `godot-2d-physics` |

### XR

| Change | Skills |
|--------|--------|
| `OpenXRExtensionWrapper._on_register_metadata` adds `interaction_profile_metadata` | `godot-platform-vr` |

### Editor / Import

| Change | Skills |
|--------|--------|
| `EditorSceneFormatImporter` constants → `ImportFlags` enum | `godot-export-builds`, `godot-3d-world-building` |

### GDScript

| Change | Skills |
|--------|--------|
| Typed override methods inherit return type — explicit `return` required | `godot-gdscript-mastery`, `godot-auditor` |
| Packed array element set no longer calls whole-array setter | `godot-gdscript-mastery` |

### Rendering

| Change | Skills |
|--------|--------|
| `LinearToSRGB` visual shader no longer clamps `[0,1]` on Mobile/Forward+ | `godot-shaders-basics` |
| `CanvasItem` line antialiasing feather removed — lines appear thinner | `godot-2d-animation`, `godot-ui-containers` |
| `ImageTexture.get_format()` moved to `Texture2D` base | `godot-shaders-basics`, `godot-3d-materials` |

### Animation

| Change | Skills |
|--------|--------|
| `Animation.length` metadata `float` → `double` | `godot-animation-player` |
| `LookAtModifier3D.relative` default `true` → `false` | `godot-animation-tree-mastery` |
| Blend space `add_blend_point` adds optional `name` param | `godot-animation-tree-mastery` |

---

## Changed Defaults

| Property | Old | New | Skills |
|----------|-----|-----|--------|
| Project stretch mode | `disabled` | `canvas_items` | `godot-project-templates`, `godot-project-foundations` |
| Project stretch aspect | `keep` | `expand` | Same |
| `rendering/reflections/sky_reflections/roughness_layers` | 7 | 8 | `godot-3d-lighting` |
| `ResourceImporterDynamicFont.hinting` | 1 | 3 | `godot-ui-theming` |
| `RichTextLabel.add_image` width/height unit | `false` | `0` (ImageUnit) | `godot-ui-rich-text` |

---

## Version String Sweep

Replace across all skills and scripts:
- `Godot 4.6` → `Godot 4.7`
- `Godot 4.6+` → `Godot 4.7+`
- `4.6.1-stable` → `4.7-stable` (builder CLI paths)
- `4.5+` → `4.7+` (README, CONTRIBUTING public baseline)

---

## skill-judge Upgrade Rules

1. **Additive compression only** — merge redundant paragraphs; never delete NEVER lists or decision trees
2. **Add** 4.7 edge cases where expert knowledge delta exists
3. **Improve descriptions** with WHAT/WHEN/KEYWORDS if missing
4. **Update script headers** `(Godot 4.6)` → `(Godot 4.7)`
5. **Do NOT sync godot-master** until Phase 5
