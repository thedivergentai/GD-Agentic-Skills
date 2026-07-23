import sys, os; sys.path.append(os.path.dirname(__file__))
from base import GodotBase
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("project", help="Path to Godot project")
    parser.add_argument("--log", default="debug.log", help="Log file path")
    args = parser.parse_args()
    GodotBase().run(["-v", "--log-file", args.log], project=args.project)

if __name__ == "__main__": main()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# - https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — interpret engine stdout/stderr from headless runs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — assert on captured CLI logs in CI
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
