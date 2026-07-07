import os
import subprocess
import platform

class GodotBase:
    def __init__(self, godot_path=None, godot_console_path=None):
        self.os_type = platform.system().lower()
        env_godot = os.environ.get("GODOT_PATH")
        env_console = os.environ.get("GODOT_CONSOLE_PATH")
        if self.os_type == 'windows':
            self.godot_path = godot_path or env_godot or r"D:\Godot\Godot_v4.7-stable_win64.exe"
            self.godot_console_path = godot_console_path or env_console or r"D:\Godot\Godot_v4.7-stable_win64_console.exe"
        else:
            self.godot_path = godot_path or env_godot or "godot"
            self.godot_console_path = godot_console_path or env_console or self.godot_path

    def normalize(self, path):
        return os.path.abspath(path).replace("\\", "/")

    def run(self, args, console=True, headless=True, project=None):
        exe = self.godot_console_path if console and self.os_type == 'windows' else self.godot_path
        cmd = [exe]
        if headless: cmd.append("--headless")
        if project: cmd.extend(["--path", self.normalize(project)])
        cmd.extend(args)
        return subprocess.run(cmd, capture_output=True, text=True)

    def write_worker(self, project, code):
        import time
        path = os.path.join(project, f".tmp_{int(time.time())}.gd")
        with open(path, "w", encoding="utf-8") as f: f.write(code)
        return path
