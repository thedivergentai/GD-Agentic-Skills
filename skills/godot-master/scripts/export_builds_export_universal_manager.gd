extends Node
## Editor tool to programmatically iterate and export all defined presets in one click.

func export_all() -> void:
    var config := ConfigFile.new()
    var err = config.load("res://export_presets.cfg")
    if err != OK:
        push_error("Failed to load export_presets.cfg")
        return
        
    for section in config.get_sections():
        if section.begins_with("preset."):
            var preset_name = config.get_value(section, "name")
            var path = config.get_value(section, "export_path")
            
            print("Exporting preset: ", preset_name, " to ", path)
            
            # Execute Godot headless for export
            var output = []
            var exit_code = OS.execute(OS.get_executable_path(), ["--headless", "--export-release", preset_name, path], output)
            
            if exit_code == 0:
                print("Successfully exported ", preset_name)
            else:
                push_error("Failed to export ", preset_name, ". Exit code: ", exit_code)
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-desktop/SKILL.md — multi-preset desktop matrix
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-platform-mobile/SKILL.md — include mobile presets in one-click export
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md
# =============================================================================
