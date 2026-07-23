---
name: godot-platform-vr
description: "Expert blueprint for VR platforms (Meta Quest, PSVR, SteamVR, Pico) covering XR toolkit (OpenXR), comfort settings (vignetting, snap turning, teleport), motion controls, hand tracking, and 90+ FPS requirements. Use when targeting VR headsets or implementing immersive 3D experiences. Keywords VR, XR, OpenXR, Meta Quest, motion sickness, comfort, locomotion, XRController3D, foveated rendering."
---

# Platform: VR

90+ FPS, comfort-first design, and motion control accuracy define VR development.

## NEVER Do (Expert VR Rules)

### Rendering & Comfort
- **NEVER drop below 90 FPS** — In VR, 72 FPS or less causes instant nausea. You MUST maintain at least 90 FPS (Meta Quest 2/3 typical) and minimize rendering jank.
- **NEVER use smooth rotation without a vignette (comfort mask)** — Smooth rotation causes motion sickness. Always provide snap turning OR dynamic vignetting.
- **NEVER force 3D MSAA if Foveated Rendering is enabled** — Foveation can conflict with MSAA natively in the OpenXR pipeline on some hardware.

### Locomotion & Interaction
- **NEVER skip a teleport locomotion option** — Smooth movement is intolerable for many. Always offer teleportation as an accessibility alternative.
- **NEVER use billboarding for VR UI** — `BILLBOARD_ENABLED` breaks stereoscopic depth cues. Use static `MeshInstance3D` planes with `SubViewports`.
- **NEVER place UI too close or too far** — 0.5m causes eye strain; 10m is unreadable. Optimal distance is 1-3 meters from the player.

### Safety & System
- **NEVER forget to respect physical play area boundaries** — Stepping into real-world objects is a safety risk. Use `XRServer` to fetch guardian bounds.
- **NEVER ignore focus_lost or session_ended signals** — Gracefully handle disconnections or system menu overlays by pausing the simulation.
- **NEVER hardcode XRControllerTracker names** — Use the **OpenXR Action Map** system to decouple gameplay from specific hardware labels.

---

## Godot 4.7: OpenXR

- `OpenXRExtensionWrapper._on_register_metadata` adds `interaction_profile_metadata` parameter — update all extension wrappers.

## Comfort Decision Tree (start here)

1. **Can the player opt out of continuous locomotion?** → If no, stop and add teleport + seated mode before any smooth locomotion code.
2. **Turning:** snap turn default → load [vr_locomotion_handler.gd](scripts/vr_locomotion_handler.gd). Smooth turn only with vignette + comfort toggle.
3. **Play area / focus:** load [vr_safety_guardian_warner.gd](scripts/vr_safety_guardian_warner.gd) + [vr_headset_focus_guard.gd](scripts/vr_headset_focus_guard.gd) before shipping any locomotion.
4. **Session bootstrap / actions / FPS:** then load [vr_openxr_initializer.gd](scripts/vr_openxr_initializer.gd), [vr_input_action_mapper.gd](scripts/vr_input_action_mapper.gd), [vr_performance_config.gd](scripts/vr_performance_config.gd).

## Available Scripts

> **MANDATORY**: After the comfort decision tree, read the matching script before implementing that pattern. Do not invent a bare `use_xr = true` / `XRController3D.is_button_pressed` demo — start from the scripts below.

### [vr_openxr_initializer.gd](scripts/vr_openxr_initializer.gd)
Expert OpenXR initialization with driver support and feature verification.

### [vr_hand_gesture_detector.gd](scripts/vr_hand_gesture_detector.gd)
Pinch and Grab recognition using `XRHandModifier3D` for hand tracking.

### [vr_locomotion_handler.gd](scripts/vr_locomotion_handler.gd)
Snap turn, comfort vignette, and accessibility `teleport_to()` with guardian/focus failure modes.

### [vr_passthrough_manager.gd](scripts/vr_passthrough_manager.gd)
Alpha blending and underlay setup for Mixed Reality (AR/VR) transitions.

### [vr_performance_config.gd](scripts/vr_performance_config.gd)
Expert Foveated Rendering and Variable Rate Shading (VRS) setup.

### [vr_haptic_sequencer.gd](scripts/vr_haptic_sequencer.gd)
Complex haptic pulse sequencing using `XRController3D` triggers.

### [vr_physics_hand_controller.gd](scripts/vr_physics_hand_controller.gd)
Non-clipping, physics-following hands that respect environmental solid.

### [vr_safety_guardian_warner.gd](scripts/vr_safety_guardian_warner.gd)
Guardian/Chaperone boundary distance warning logic using `XRServer`.

### [vr_headset_focus_guard.gd](scripts/vr_headset_focus_guard.gd)
Headset-aware pause logic for focus loss (System Menu / Headset Off).

### [vr_input_action_mapper.gd](scripts/vr_input_action_mapper.gd)
OpenXR Action Map abstraction to decouple logic from hardware buttons.

---

## Teleport Accessibility Path

Always ship teleport (or room-scale only) as an alternative to smooth locomotion.

1. **MANDATORY read** [vr_locomotion_handler.gd](scripts/vr_locomotion_handler.gd) — `teleport_to(target_global)`.
2. **Raycast** from controller aim to floor/navmesh; pass the hit point into `teleport_to`.
3. **Failure modes (must handle):**
   - **Guardian clip** — reject targets outside play-area bounds; warn via [vr_safety_guardian_warner.gd](scripts/vr_safety_guardian_warner.gd).
   - **Focus pause** — never teleport while the tree is paused / headset focus lost; [vr_headset_focus_guard.gd](scripts/vr_headset_focus_guard.gd) owns pause/mute.
4. Pair teleport with snap turn + vignette from the same locomotion handler.

## Comfort Gates (NEVER-adjacent)

These are hard comfort gates, not soft preferences:

1. **90+ FPS** before any optional VFX — nausea risk outweighs polish.
2. **Teleport or snap-turn path** always available — never ship smooth-only locomotion.
3. **Guardian + focus handlers** live before first public playtest.
4. **UI at 1–3 m** on composition layers / static quads — never billboarded close-range HUD.

### Expert patterns (script pointers)

1. **Mixed-Reality passthrough (Quest 3)** — `environment_blend_mode = ALPHA_BLEND` + `transparent_bg` exposes the camera feed through scene alpha → [mixed_reality_manager.gd](scripts/mixed_reality_manager.gd) / [vr_passthrough_manager.gd](scripts/vr_passthrough_manager.gd).
2. **Composition-layer UI** — `OpenXRCompositionLayerQuad` + `SubViewport` bypasses lens blur → [xr_performance_overlay.gd](scripts/xr_performance_overlay.gd).
3. **Universal grab** — OpenXR action map + central reparent manager → [universal_grab_manager.gd](scripts/universal_grab_manager.gd) + [vr_input_action_mapper.gd](scripts/vr_input_action_mapper.gd).

## Deep dives (on demand)

- Extended OpenXR bootstrap, motion-control samples → [xr-comfort-patterns.md](references/xr-comfort-patterns.md)

## Reference

> Progressive disclosure: open Official Documentation links only when researching a specific API; load Related Skills when routing to a peer domain — do not preload the whole lattice.

### Official Documentation
- [Setting up XR](https://docs.godotengine.org/en/stable/tutorials/xr/setting_up_xr.html) — OpenXR project enablement, XROrigin3D/XRCamera3D tree, and first headset session bootstrap.
- [A better XR start script](https://docs.godotengine.org/en/stable/tutorials/xr/a_better_xr_start_script.html) — robust initialize → use_xr sequencing, focus signals, and failure paths before viewport XR mode.
- [The XR action map](https://docs.godotengine.org/en/stable/tutorials/xr/xr_action_map.html) — hardware-agnostic actions so gameplay never hardcodes controller button strings.
- [Basic XR locomotion](https://docs.godotengine.org/en/stable/tutorials/xr/basic_xr_locomotion.html) — teleport vs continuous movement and comfort-oriented turning patterns.
- [OpenXR hand tracking](https://docs.godotengine.org/en/stable/tutorials/xr/openxr_hand_tracking.html) — XRHandModifier3D / joint tracking and controller fallback expectations.
- [OpenXR composition layers](https://docs.godotengine.org/en/stable/tutorials/xr/openxr_composition_layers.html) — crisp SubViewport UI via OpenXRCompositionLayerQuad instead of billboarded 3D quads.
- [AR / passthrough](https://docs.godotengine.org/en/stable/tutorials/xr/ar_passthrough.html) — environment blend modes and transparent viewport setup for mixed reality.
- [OpenXR settings](https://docs.godotengine.org/en/stable/tutorials/xr/openxr_settings.html) — foveation, render target multiplier, and other headset performance knobs.
- [XR room-scale](https://docs.godotengine.org/en/stable/tutorials/xr/xr_room_scale.html) — play-area / guardian bounds via XRServer for physical safety.
- [Deploying XR on Android](https://docs.godotengine.org/en/stable/tutorials/xr/deploying_to_android.html) — Quest-class Android export, permissions, and OpenXR loader packaging.
- [Variable rate shading](https://docs.godotengine.org/en/stable/tutorials/3d/variable_rate_shading.html) — VRS / foveated shading tradeoffs that pair with OpenXR foveation for 90+ FPS.
- [XRInterface](https://docs.godotengine.org/en/stable/classes/class_xrinterface.html) — initialize, focus, passthrough, haptics, and blend-mode APIs shared by OpenXR/WebXR.

### Related Skills

#### Prerequisites
- [godot-project-foundations](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-project-foundations/SKILL.md) — project settings, scene tree, and viewport basics required before enabling OpenXR and use_xr.
- [godot-input-handling](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-input-handling/SKILL.md) — action/event mental model that the OpenXR Action Map extends for motion controllers.
- [godot-gdscript-mastery](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md) — typed XR scripts, await timers for snap-turn comfort, and signal wiring for focus/haptics.

#### Complements
- [godot-camera-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-camera-systems/SKILL.md) — XRCamera3D is still a Camera3D; comfort UI distance and head-relative framing reuse camera placement rules.
- [godot-performance-optimization](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md) — draw-call and GPU budgets that decide whether 90/120 Hz holds under foveation and VRS.
- [godot-physics-3d](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-physics-3d/SKILL.md) — CharacterBody3D/RigidBody3D grab-and-throw hands that must not clip through static world geometry.
- [godot-audio-systems](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-audio-systems/SKILL.md) — mute/duck buses when headset focus is lost so system menus never leave game audio blasting.
- [godot-shaders-basics](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-shaders-basics/SKILL.md) — comfort vignettes and spatial overlays during locomotion without fighting the XR compositor.
- [godot-ui-containers](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ui-containers/SKILL.md) — layout inside SubViewports projected through composition layers at 1–3 m.
- [godot-export-builds](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md) — Android/desktop export presets and OpenXR loader packaging for Quest and PCVR.
- [godot-platform-mobile](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md) — standalone headset Android constraints (thermal, resolution scale, touchless UX) that overlap Quest shipping.

#### Downstream / consumers
- [godot-platform-web](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md) — WebXR session_started/ended flows that reuse the same XRServer interface patterns for browser VR.
- [godot-scene-management](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md) — pause trees and scene swaps when focus_lost or session_ended fires mid-experience.

#### Master
- [godot-master](https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-master/SKILL.md) — library router and mirrored module entry for cross-skill discovery.
