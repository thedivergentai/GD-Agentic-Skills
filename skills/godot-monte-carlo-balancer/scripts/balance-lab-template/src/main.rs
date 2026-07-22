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
