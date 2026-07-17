# 📱 GDSkills Feed & Project History

> **"Where Expert Knowledge Meets Agentic Speed."** — *The Code Architect*

---

## 📌 Pinned Post: A Message from Divergent AI
**March 19, 2026**

Hey everyone! 🚀 The project is gaining some serious traction and I'm loving the energy. It motivated me to push a massive overhaul. 

We've spent a "Big Brain" amount of hours updating **every single microskill** to be completely packed with expert-tier knowledge pulled straight from the source (Godot 4.3+ Technical Docs). 

**The Goal:** Zero slop. 100% Native Godot Best Practices. 

I want this library to be the "Long-Term Memory" your agents need to build your dream games without the technical debt. Let's make something awesome! 🛠️

---

## 🚀 Major Release: v0.0.8 — The Director's Cut Update
**July 7, 2026**

<div align="center">
  <img src="assets/banner_0_0_8.webp" alt="The Director's Cut Update - v0.0.8" width="100%" />
</div>

Godot 4.7 dropped and we didn't just bump a version string — we gave the **entire library** a Director's Cut pass. 🎬 Every Domain Skill, every persona script, every mirror in `godot-master` now speaks **4.7+** fluently. Your agents get the migration notes *before* they write the slop.

- **Godot 4.7 Upgrade**: All 92 Domain Skills updated with a committed migration digest, targeted API deltas, and a full version string sweep across the stack.
- **godot-master Sync**: Full mirror refresh of domain skill references and bundled scripts for 4.7.
- **Domain Skills Rename**: "Micro-Skills" are now **Domain Skills** — same modular expertise, clearer branding on the feed.
- **Persona Squad 4.7**: Anara scores 4.7 modernity signals, Aurelius opened **Sector IX** (the 4.7 never-list), and Builder respects `GODOT_PATH` so your CLI isn't married to one install folder.

> "Anara gave my horror prototype +10 for AreaLight3D and Aurelius vetoed my `width_in_percent` RichTextLabel in the same session. I feel seen." — *Beta Tester*

---

## 🧹 Follow-up: MCP leftovers cleared + agent-neutral install docs
**July 17, 2026**

We said in v0.0.7 that MCP Setup/Builder were gone. A few references were still hanging around and biting people (dead `@modelcontextprotocol/server-godot` package, Claude-only config paths). Those are out now.

- **MCP purge**: Removed leftover MCP reference docs and scripts from `godot-master` / `godot-auditor`. Programmatic scenes go through **godot-builder** (Workflow 11).
- **README agent rubric**: Common host agents and their `-a` / discovery paths for clone + DIA workflows — not Claude-only symlink advice.
- **Docs target**: Public library target wording is **Godot 4.7+** end-to-end (README / CONTRIBUTING / PARTNERS). Feature-era notes like "added in 4.5" inside skills stay as historical API markers.
- **Skill counts**: Totals reconciled to **96** skills (92 Domain + master + 3 personas); category headers fixed to match the lists.

---

## 🎬 Director's Cut: Godot 4.7 Tidbits
**July 7, 2026**

*Quick hits from the engine release your agents now know by heart.*

**"Finally, a real rectangle of light."**

4.7 ships **AreaLight3D** — actual rectangular area lights with soft shadows. No more faking neon signs with emissive materials and praying GI cooperates. Your `godot-3d-lighting` and horror genre skills already route agents there.

> [!TIP]
> **Pro Tip:** If your agent suggests emissive quads for "screen glow," point it at AreaLight3D first. The Director's Cut is about *cinematic* defaults.

---

**"HDR isn't a PC flex anymore."**

HDR output landed on desktop *and* mobile (plus visionOS). Platform and lighting Domain Skills now treat HDR as baseline, not a stretch goal for showcase builds.

---

**"The Asset Library graduated."**

Godot's **Asset Store** replaces the old Asset Library — threaded loading, ratings, zoom previews. Foundations and export skills reflect the new workflow so agents don't send you to dead UI labels.

---

**"Your thumb deserves a native joystick."**

Built-in **virtual joystick** on mobile. No plugin archaeology required. `godot-platform-mobile` and adapt-desktop-to-mobile skills cover it — ship touch controls without a dependency rabbit hole.

---

**"Aurelius has opinions about 4.6 leftovers."**

Sector IX of the never-list is live. Highlights your agents must not sleep on:

- `RichTextLabel` **`width_in_percent` / `height_in_percent`** → gone; use `width_unit` / `height_unit` with `ImageUnit`.
- **`AudioEffectSpectrumAnalyzer.tap_back_pos`** → removed. RIP.
- Mouse/keyboard **`event.device == 0`** → use `InputEvent.DEVICE_ID_MOUSE` and `DEVICE_ID_KEYBOARD`.
- **Jolt `SoftBody3D`** → mass and stiffness math changed; retune after upgrade or your jelly physics becomes *abstract art*.

> "I thought my platformer one-ways were broken. Turns out 4.7 wants one-way direction on the **shape**, not just the body. GDSkills caught it." — *Trial User*

---

**"2D platformers: one-way collision grew a compass."**

**CollisionShape2D** one-way direction is now relative to shape orientation — not just "up is magic." Platformer and 2D physics Domain Skills document the new mental model.

---

<div align="center">

**🍿 That's the Director's Cut.**  
*96 skills. Zero 4.6 assumptions. Go build something worth a close-up.*

</div>

---

## 🚀 Major Release: v0.0.7 — The Analyze, Audit, Build! Update
**May 20, 2026**

<div align="center">
  <img src="assets/banner_0_0_7.webp" alt="The Analyze, Audit, Build! Update - v0.0.7" width="100%" />
</div>

- **Three Persona-Based Skills**: Introduced specialized skills for `@godot-analyst` (Anara), `@godot-auditor` (Aurelius), and `@godot-builder` to unify development and optimization.
- **MCP Streamlining**: Retired the defunct `MCP Builder` and `MCP Setup` skills in favor of direct construction and compilation using the Godot CLI.
- **Full Repository Audit**: Executed a comprehensive audit across all microskills to elevate the knowledge depth and execution reliability to the highest agentic standard.
- **Godot Master Synchronization**: Fully synchronized these advancements with `godot-master`, making the lead architect orchestrator more robust than ever.

---
**"Why inherit when you can compose?"**

Is your Player script 2,000 lines long? Are you afraid to touch the `Enemy.gd` because it might break the `Boss.gd`? 

**The Solution:** Use the **Composition Pattern**. Instead of making a "Fire Dragon" that inherits from "Dragon" that inherits from "Enemy", give your `FireDragon` a `HealthComponent`, a `FlightComponent`, and a `FireAttackComponent`.

> [!TIP]
> **Pro Tip:** In Godot 4, use `@export` variables to link components in the Inspector. It’s like LEGO for game dev. Check it out in [skills/godot-composition](skills/godot-composition/SKILL.md).

---

## 🛡️ Meet the Squad: Aurelius & Anara
**March 20, 2026**

The library just got a major IQ boost. 🧠 Say hello to our new **Expert-Grade Diagnostics Duo**.

- **Aurelius (Auditor)**: The project's "Stoic Parent." He's here to audit your code for technical debt and "Main Thread Slop." He talks like a Roman general but cares like a guardian. Check out his manifesto in `skills/godot-auditor`.
- **Anara (Analyst)**: The "Visionary Hype-Girl." She doesn't just see code; she sees your project's soul. She'll score your health and, if you're elite enough, materialize a **Glassmorphism v2 Certificate** for you.

> "Aurelius found a string-based signal in my Player script and I've never felt more judged... or more safe." — *Trial User*

---

## 🚀 Major Release: v0.0.6 — The Expert Augmentation
**March 19, 2026**

<div align="center">
  <img src="assets/banner_0_0_6.webp" alt="The Expert Augmentation Update - v0.0.6" width="100%" />
</div>

- **Total Microskill Overhaul**: All 94 skills updated with Godot 4.5+ nuances.
- **Godot Master Optimization**: The lead architect is now faster and smarter at orchestrating sub-skills.
- **Context Management**: New safety rails added to prevent "Context Storms."

---

## 💡 Did You Know?
**Godot 4 Performance Hack: `StringName`**

Ever wonder why Godot 4 uses `&"string"` instead of `"string"` for things like animations and signals? 

`StringName` is **Unique & Persistent**. When you compare two `StringName`s, the engine just checks if their memory addresses match (O(1) speed!). Regular `String`s have to be checked character-by-character (O(n) speed). 

**Result:** Using `&"my_signal"` is significantly faster for your agentized systems than `"my_signal"`. 🚅

---

## 📜 Update: v0.0.5 — The Looper Update
**March 15, 2026**

<div align="center">
  <img src="assets/banner_0_0_5.webp" alt="The Looper Update - v0.0.5" width="100%" />
</div>

- **Resource Harvesting**: Interactive gathering systems for the survival enthusiasts.
- **Time Trials**: Precise ghost recording for the speedrunners.
- **Wave Management**: Scalable enemy spawning for the survivors.

---

## 📜 Update: v0.0.4 — The Easter & Renewal Update
**March 10, 2026**

<div align="center">
  <img src="assets/banner_0_0_4.webp" alt="The Easter & Renewal Update - v0.0.4" width="100%" />
</div>

- **Seasonal Theming**: Runtime aesthetic injection.
- **Revival Mechanics**: "Souls-like" death and rebirth systems.
- **Konami Code Support**: Because secrets make games better.

---

## 📜 Update: v0.0.3 — The Romance Update
**March 05, 2026**

<div align="center">
  <img src="assets/banner_0_0_3.webp" alt="The Romance Update - v0.0.3" width="100%" />
</div>

- **Relationship Systems**: Branching affection logic and dating sim blueprints.
- **Unified Romance**: Fully integrated into the Godot Master brain.

---

## 📜 Update: v0.0.2 — Master Skill Evolution
**February 28, 2026**

- **The Orchestrator Born**: `godot-master` becomes the central hub for the ecosystem.
- **Decision Trees**: Integrated architectural guides.

---

## 🏁 The Beginning: v0.0.1 — Initial Launch
**February 15, 2026**

The foundation was laid. 80+ skills, the DIA loop, and a dream of agentic game development. 🌍

---

<div align="center">
  <b>Authored by [Divergent AI](https://github.com/thedivergentai)</b>  
  *Keeping Godot development social, fast, and slop-free.*
</div>
