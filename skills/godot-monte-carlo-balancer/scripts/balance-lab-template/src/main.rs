//! Stub entrypoint. Expand per Phase 0–5; do not treat this as a working balancer.
//! Required modules (create as needed): extract, model, sim, analysis, generate.
//! CLI shape: see SKILL.md — inspect | simulate | career | mode | bruteforce | calibrate
//! Defaults: --seed 42 (constant), --json for CI. Exit 2 until extract+sim exist.

fn main() {
    eprintln!(
        "balance-lab: stub only. Copy this crate to tools/balance_lab/, implement extract→sim, \
         then use tools/balance_lab.ps1|.sh. See godot-monte-carlo-balancer Phase 0–7."
    );
    std::process::exit(2);
}
// =============================================================================
// GDSkills research links (agents) — does not affect runtime
// Official docs:
// - https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html
// - https://docs.godotengine.org/en/stable/classes/class_json.html
// - https://docs.godotengine.org/en/stable/tutorials/editor/command_line_tutorial.html
// Related skills:
// - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-resource-data-patterns/SKILL.md — Resource-first extract
// - https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — Phase 7 headless calibration
// Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-monte-carlo-balancer/SKILL.md
// =============================================================================
