# audit_signals.py
# Offline Python utility to scan GDScript files for risky signal patterns.
# Specifically targets anonymous lambdas which can cause memory leaks if not managed.

import os
import re

class SignalAuditor:
    def __init__(self, project_root):
        self.project_root = project_root
        # Pattern for lambda connections: .connect(func(...)
        self.lambda_pattern = re.compile(r'\.connect\(func\s*\(.*?\)\s*:', re.MULTILINE)
        self.risky_lambdas = []

    def scan_files(self):
        for root, _, files in os.walk(self.project_root):
            for file in files:
                if file.endswith('.gd'):
                    self.audit_file(os.path.join(root, file))

    def audit_file(self, file_path):
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            matches = self.lambda_pattern.finditer(content)
            for match in matches:
                line_no = content.count('\n', 0, match.start()) + 1
                self.risky_lambdas.append({
                    'file': os.path.relpath(file_path, self.project_root),
                    'line': line_no,
                    'snippet': match.group(0)
                })

    def generate_report(self):
        print("=== GDScript Signal Audit Report ===")
        if not self.risky_lambdas:
            print("[PASS] No risky lambdas detected.")
            return

        print(f"[FAIL] Detected {len(self.risky_lambdas)} risky anonymous lambdas.")
        print("Lambdas capturing local variables can cause leaks if the signal source outlives the target.")
        for leak in self.risky_lambdas:
            print(f"- {leak['file']}:{leak['line']} -> {leak['snippet']}...")
        print("------------------------------------")
        print("RECOMMENDATION: Use Callable.is_standard() at runtime to audit connections,")
        print("or prefer named functions for long-lived signal connections.")

if __name__ == "__main__":
    # In a real scenario, this would take the project path as an argument.
    auditor = SignalAuditor(".")
    auditor.scan_files()
    auditor.generate_report()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# - https://docs.godotengine.org/en/stable/tutorials/scripting/instancing_with_signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — typed Signal.connect and lambda disconnect rules
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-debugging-profiling/SKILL.md — prove leaks with connection/orphan tooling
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
# =============================================================================
