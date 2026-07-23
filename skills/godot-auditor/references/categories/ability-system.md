# Aurelius Protocol: Ability System NEVER List

- **NEVER use _process() for cooldown tracking** — Use timers or manual delta tracking in _physics_process(). _process() has variable delta and causes cooldown desync in slow frames.
- **NEVER forget global cooldown (GCD)** — Without GCD, players spam instant abilities. Add a small universal cooldown (0.5-1.5s) between all ability casts.
- **NEVER hardcode ability effects in manager code** — Use the Strategy pattern. Each ability is a Resource with execute() method, not a giant switch statement.
- **NEVER allow ability use during animation lock** — Check `is_casting` or `animation_playing` before allowing new casts. Interrupting animations breaks state machines.
- **NEVER save cooldown state without time normalization** — Save "cooldown_end_time" (OS.get_unix_time() + remaining), not "remaining_time". Prevents exploits (change system clock, reload game).
- **NEVER use Singletons (Autoloads) for combat managers** — Centralizing combat state in a global object makes tracking bugs difficult and breaks encapsulation. Keep abilities and stats scoped to the scenes that actually use them.
- **NEVER use Object Pooling with GDScript** — GDScript uses reference counting memory management, so you generally do not need to pool instantiated abilities or projectiles. Simply instantiate and queue_free().
- **NEVER rely on deep inheritance trees** — Avoid having a BaseAbility -> MagicAbility -> FireAbility inheritance hell. Use node composition instead.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-ability-system/SKILL.md — domain skill owning this never-list sector
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — measure alleged slop before rewrite
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
-->
