#!/usr/bin/env bash
# Self-rebuilding launcher (Linux/macOS).
# Install as: tools/balance_lab.sh  with crate at tools/balance_lab/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CRATE_DIR="$SCRIPT_DIR/balance_lab"
MANIFEST="$CRATE_DIR/Cargo.toml"
BINARY="$CRATE_DIR/target/release/balance-lab"

needs_build=0
if [[ ! -x "$BINARY" ]]; then
    needs_build=1
else
    if [[ "$MANIFEST" -nt "$BINARY" ]]; then
        needs_build=1
    else
        while IFS= read -r -d '' src; do
            if [[ "$src" -nt "$BINARY" ]]; then
                needs_build=1
                break
            fi
        done < <(find "$CRATE_DIR/src" -name '*.rs' -print0)
    fi
fi

if [[ "$needs_build" -eq 1 ]]; then
    cargo build --release --manifest-path "$MANIFEST"
fi

exec "$BINARY" "$@"
# =============================================================================
# GDSkills research links (agents) — does not affect runtime
# Official docs:
# - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
# - https://docs.godotengine.org/en/stable/classes/class_json.html
# - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
# Related skills:
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Resource-first extract
# - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — Phase 7 headless calibration
# Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md
# =============================================================================
