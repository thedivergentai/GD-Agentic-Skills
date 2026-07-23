import sys, os; sys.path.append(os.path.dirname(__file__))
from base import GodotBase
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("pid", type=int, help="Process ID to stop")
    args = parser.parse_args()
    import subprocess, platform
    if platform.system().lower() == 'windows': subprocess.run(["taskkill", "/F", "/PID", str(args.pid)])
    else: os.kill(args.pid, 9)

if __name__ == "__main__": main()

# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# - https://docs.godotengine.org/en/stable/classes/class_os.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — terminate hung headless Godot PIDs
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — clean CI jobs after export
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-builder/SKILL.md
# =============================================================================
