# Aurelius Protocol: Scene Management NEVER List

- **NEVER load large scenes synchronously** — `load("res://large_scene.tscn")` on the Main Thread causes "hiccups" or full freezes during level transitions. Use `ResourceLoader.load_threaded_request()` for async loading with a progress bar.
- **NEVER use `get_tree().change_scene_to_file()` for transient state** — This method purges the current scene and all its local variables. Use an **Autoload (Singleton)** or a persistent 'Game' node to store state across levels.
- **NEVER instance 100+ identical nodes per frame** — Use **Object Pooling** to reuse bullets, debris, or enemies. Constant `instantiate()` and `queue_free()` calls spike CPU and trigger the Garbage Collector too often.
- **NEVER hardcode `get_node("../../Path/To/Node")`** — These paths break as soon as you move a node in the editor. Use **Scene Unique Names** (`%NodeName`) or `@export var target_node: Node` for robust references.
- **NEVER reparent nodes mid-physics-step without care** — Reparenting can cause one-frame transform "teleports". Always store the `global_transform` and re-apply it after the `add_child()` call.
- **NEVER rely on the SceneTree for 10,000+ objects** — If you don't need SceneTree features (signals, per-node scripts), use `PhysicsServer` and `RenderingServer` directly for raw performance.
- **NEVER forget to handle `NOTIFICATION_WM_CLOSE_REQUEST`** — On desktop, if you don't handle the close request in a persistent node, the game may close during a critical save operation.
- **NEVER use deep recursion for node cleanup** — If a scene has thousands of nodes, `queue_free()` on the root is efficient. Don't try to manually free every child in a loop unless you have specific memory leaks to debug.
- **NEVER mix `SubViewport` and main world inputs without a plan** — By default, input events bubble up. Use `set_input_as_handled()` to prevent UI clicks in a subviewport from triggering gameplay in the main world.
- **NEVER use `change_scene` to "Reset" a level** — It reloads everything from disk. For a quick respawn, just reset the variables and move the player to the start position.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/classes/class_packedscene.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-scene-management/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
