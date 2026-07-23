# Anara Rubric: Testing Patterns
## Pillar Overview
The proof of architectural existence. This rubric measures the project's commitment to automated verification and the robustness of its logic through testing.

---

## Analytical Performance Matrix

| Criterion | Weight | SLOP (0-2) | FUNCTIONAL (3-5) | PROFESSIONAL (6-8) | ELITE (Visionary) (9-10) |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **Coverage Rigor** | 35% | Zero automated tests; "I just run the game to see if it works." | Basic unit tests for a few core math functions, but missing for main logic. | Robust test suite for all critical systems (Save/Load, Inventory, Logic). | 100% coverage of core business-logic; automated regression testing on every build. |
| **Deterministic Proof** | 25% | Tests rely on 'Luck' or manual input; non-deterministic results. | Mocked data for tests, but lacks formal 'Mock' objects for engine classes. | Pure deterministic environment; using 'Test Runners' (e.g., GUT) with mocking. | Zero-engine-dependency logic; the vision is proven in isolation through pure data. |
| **Integration Depth** | 20% | Only testing internal functions; no 'System-to-System' integration tests. | Some integration tests, but they require the full game to load. | Headless integration tests; verifying complex system flows without the visuals. | Full CI/CD integration; every PR is verified by a battery of architectural proofs. |
| **Diagnostic Feedback** | 20% | Test failures provide no context; obscure "Error" messages. | Tests print results to console, but lack formal reporting. | Detailed test reports; identifying specific broken lines in the logic-vision. | Predictive diagnostic analysis; the machine suggests the fix for the broken proof. |

---

## Visionary Diagnostic Hooks
- *If I change the 'Inventory' logic, will the machine tell me I broke the 'Shop'?*
- *Is your 'Proof' as strong as your 'Promise'?*
- *When the tests fail, does the vision remain clear?*

## 🌟 Visionary's Final Decree
If it is not tested, it does not exist. A project without a proof of logic is merely a prototype. To reach **Elite** status, you must achieve 'Test-Driven Architecture'—where the test is written before the dream is coded. This is the mark of a true Visionary.
<!--
GDSkills research links (agents)
Official docs:
- https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html
- https://docs.godotengine.org/en/stable/tutorials/best_practices/scene_organization.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html
Related skills:
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-testing-patterns/SKILL.md — domain remediation for this Anara rubric
- https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-auditor/SKILL.md — compliance citations alongside Visionary scores
Parent skill: https://github.com/thedivergentai/gd-agentic-skills/blob/main/skills/godot-analyst/SKILL.md
-->
