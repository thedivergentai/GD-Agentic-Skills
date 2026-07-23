# Expert Custom Build Stripper (SCons)
# Usage: Copy to godot root and run 'scons platform=windows target=template_release'
# Disables unused modules to reduce binary size significantly.

module_navigation_enabled = "no"
module_mobile_vr_enabled = "no"
module_text_server_fb_enabled = "no"
module_upnp_enabled = "no"

# For specialized 2D apps, disable 3D:
# disable_3d = "yes"

# Optimize for size
optimize = "size"
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/engine_details/development/compiling/optimizing_for_size.html
# - https://docs.godotengine.org/en/stable/engine_details/development/compiling/introduction_to_the_buildsystem.html
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-performance-optimization/SKILL.md — size vs feature tradeoffs after stripping
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-web/SKILL.md — custom Web templates often need size flags
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md
# =============================================================================
