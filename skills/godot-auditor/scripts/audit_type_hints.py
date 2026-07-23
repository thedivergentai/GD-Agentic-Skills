# audit_type_hints.py
# Offline Python utility to scan GDScript for Variant container slop and string signal connect decay.

import os
import re
import sys

class TypeHintAuditor:
    def __init__(self, project_root):
        self.project_root = project_root
        self.variant_array = re.compile(r'\bvar\s+\w+\s*:\s*Array\s*=\s*\[\]', re.MULTILINE)
        self.variant_dict = re.compile(r'\bvar\s+\w+\s*:\s*Dictionary\s*=\s*\{\}', re.MULTILINE)
        self.string_connect = re.compile(r'\.connect\s*\(\s*"[^"]+"\s*,', re.MULTILINE)
        self.findings = []

    def scan_files(self):
        for root, _, files in os.walk(self.project_root):
            for file in files:
                if file.endswith('.gd'):
                    self.audit_file(os.path.join(root, file))

    def audit_file(self, file_path):
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            rel = os.path.relpath(file_path, self.project_root)
            for pattern, kind in (
                (self.variant_array, 'untyped Array'),
                (self.variant_dict, 'untyped Dictionary'),
                (self.string_connect, 'string signal connect'),
            ):
                for match in pattern.finditer(content):
                    line_no = content.count('\n', 0, match.start()) + 1
                    self.findings.append({
                        'file': rel,
                        'line': line_no,
                        'kind': kind,
                        'snippet': match.group(0).strip(),
                    })

    def generate_report(self):
        print("=== GDScript Type-Hint Audit Report ===")
        if not self.findings:
            print("[PASS] No Variant containers or string connects detected.")
            return

        print(f"[FAIL] Detected {len(self.findings)} type-safety violations.")
        for item in self.findings:
            print(f"- {item['file']}:{item['line']} [{item['kind']}] -> {item['snippet']}")
        print("------------------------------------")
        print("RECOMMENDATION: Use Array[T]/Dictionary[K,V] and Signal.connect(callable).")
        print("Pair with gdscript-mastery category never-list for hot-loop typing rules.")

if __name__ == "__main__":
    root = sys.argv[1] if len(sys.argv) > 1 else "."
    auditor = TypeHintAuditor(root)
    auditor.scan_files()
    auditor.generate_report()
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/static_typing.html
# - https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-gdscript-mastery/SKILL.md — typed Array/Dictionary decrees
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-signal-architecture/SKILL.md — Signal.connect vs string connect
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md
# =============================================================================
