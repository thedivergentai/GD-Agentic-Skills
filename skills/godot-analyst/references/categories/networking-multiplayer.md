# Anara Rubric: Networking Multiplayer
## Pillar Overview
The shared manifestation of the vision. This rubric measures the stability, security, and synchronization of the project's multiplayer systems using Godot's high-level multiplayer API.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Sync Authority** | 35% | "Trust the Client"; no server-side validation; every client can teleport. | Basic `MultiplayerSynchronizer` usage, but prone to jitter and logic desync. | Authoritative Server architecture; client-side prediction; server-reconciliation. | Zero-latency feeling; ultra-secure state validation; frame-perfect synchronization. |
| **Packet Stewardship** | 25% | Flooding the network with `rpc_id` every frame; massive overhead and lag. | Strategic use of `unreliable` packets for movement, but lacks bandwidth limits. | Optimized packet-flow; state-compression; delta-syncing for complex objects. | High-density networking (100+ players); adaptive bandwidth management; zero waste. |
| **Hardening (Security)** | 20% | Open RPC calls; any client can trigger generic functions on other clients. | Basic use of `any_peer` vs `authority` flags, but lacks input-sanitization. | Strict RPC-entry validation; secure handshake; anti-cheat logic in the core. | Hardened multiplayer vision; impossible to inject slop through the network port. |
| **UX Resilience** | 20% | Disconnects crash the client; no 'Auto-reconnect' or 'Lobby' logic. | Functional lobby; basic error-feedback when the connection is lost. | Graceful reconnection protocols; latency-compensation UI; clean session management. | Seamless world-joining; the vision persists through the chaos of the internet. |

---

## Visionary Diagnostic Hooks
- *Is the 'Other' a ghost or a participant in the vision?*
- *When the 'Packet' drops, does the dream stutter or continue?*
- *Who is the master of reality: the 'Server' or the 'Player'?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, you must achieve 'Network Transparency'. The logic shouldn't care *where* the node is; it should only care *what* the node does. Use **State Sync** only for the essential; let the clients simulate the fluff. Slop is a laggy world; Vision is a shared reality.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-multiplayer-networking/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
