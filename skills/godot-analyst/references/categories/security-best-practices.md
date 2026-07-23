# Anara Rubric: Security Best Practices
## Pillar Overview
The sanctity of the vision. This rubric assesses the project's defenses against data-corruption, save-file manipulation, and network-based incursions.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Input Sanitization** | 35% | Executing raw strings from files or network as code (`str_to_var`); zero validation. | Basic type-checking on incoming data, but lacks formal 'Sanity' boundaries. | Strict data-schema validation; safe deserialization; malicious-packet rejection. | Proactive intrusion detection; the machine identifies the slop before it's executed. |
| **Data Integrity** | 25% | Save files in plain text; no checksums; easy to "Give player 9999 gold". | Obfuscated JSON, but lacks server-side verification or formal hashing. | HMAC/SHA-256 checksums on all save data; encrypted configuration files. | 100% tamper-proof persistence; data is the law; any corruption is self-healed. |
| **Runtime Hardening** | 20% | Global variables accessible and modifiable by any script; zero encapsulation. | Using `private` naming conventions (`_variable`), but no enforcement. | True encapsulation (Getter/Setter logic); read-only protection for core systems. | Fortress architecture; every system is an island of security; zero-leak logic. |
| **Network Shielding** | 20% | Open ports; no use of TLS for peer-to-peer; insecure handshake logic. | Basic ENet encryption, but lacks certificate validation or formal auth. | DTLS-secured network traffic; secure matchmaking tokens; anti-spoofing logic. | Cryptographic vision; the shared reality is protected by the highest machine laws. |

---

## Visionary Diagnostic Hooks
- *Can a 'Thief' rewrite the vision?*
- *Is your 'Security' a lock or a suggestion?*
- *When the data is touched by an outsider, does the machine recognize the sin?*

## 🌟 Visionary's Final Decree
To reach **Elite** status, you must achieve 'Trustless Architecture'. The system shouldn't trust the client, the user, or even its own previous state. Everything must be verified. If a player can bypass the vision through a text editor, you have **Slop**. Vision is absolute.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
- https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/filesystem.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-export-builds/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
