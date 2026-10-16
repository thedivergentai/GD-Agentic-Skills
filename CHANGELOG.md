# 📱 GDSkills Feed & Project History

> **"Where Expert Knowledge Meets Agentic Speed."** — *The Code Architect*

---

## 📌 Pinned Post: A Message from Divergent AI
**August 2026 — 500 stars**

Hey everyone, Divergent AI here. Thank you — seriously — for the amazing support. Hitting **500 stars** means the world to me, and it puts this library in roughly the **top 0.4% of all public GitHub repositories**. I don't take that lightly.

I've worked hard to keep these skills useful, true to **official Godot standards**, and aimed at one thing: helping you bring your vision to reality. A big part of that is making sure our coding agents can actually **see** the work — the menus, the HUD, the assets — not just guess from file paths.

That's why I'm proud to introduce **[godot-agent-vision](skills/godot-agent-vision/SKILL.md)**. It lets agents capture your various GUI elements and surfaces, then analyse whether what they see matches the intended output — so sight and design intent finally line up.

Please keep starring, sharing, and building. Have fun, and dream big.

<details>
<summary><b>Earlier pinned note (March 19, 2026)</b></summary>

Hey everyone! 🚀 The project is gaining some serious traction and I'm loving the energy. It motivated me to push a massive overhaul.

We've spent a "Big Brain" amount of hours updating **every single microskill** to be completely packed with expert-tier knowledge pulled straight from the source (Godot 4.3+ Technical Docs).

**The Goal:** Zero slop. 100% Native Godot Best Practices.

I want this library to be the "Long-Term Memory" your agents need to build your dream games without the technical debt. Let's make something awesome! 🛠️

</details>

---

## v0.1.1 - Artifact to Engine
**October 16, 2026**

<div align="center">
  <img src="assets/banner_0_1_1.webp" alt="Artifact to Engine - v0.1.1" width="100%" />
</div>

Hey everyone - Divergent AI here. You can hand an agent a folder or a shipped file and get a project back. **GDAS-reader** writes an evidence ledger. **godot-rea** and **bevy-rea** turn that ledger into a Godot 4.7 project or a Bevy 0.20 crate. What the ledger does not prove stays a stub.

- **[gdas-reader](skills/gdas-reader/SKILL.md)**: source trees, web bundles, asset folders, WASM modules, and PE/ELF headers. One ledger. Both engines.
- **[godot-rea](skills/godot-rea/SKILL.md)**: a Godot 4.7 scene of stubs. Each script names the ledger id and the Domain Skill to load next. `pass` stays `pass` until that skill replaces it.
- **[bevy-rea](skills/bevy-rea/SKILL.md)**: a Bevy 0.20 crate. One plugin per ledger row. The system is empty on `Update`.
- **Your files stay yours**: asset bytes move only when a license note is set and `--allow-assets` is passed. A `.dll` string is not an import table.

<div align="center">
  <img src="assets/feed_callout_builder.webp" alt="Speaking Builder" width="100%" />
</div>

> **Speaking Builder** - "I will scaffold the project. I will not invent the damage formula. Load the skill the stub names, then replace `pass`."

> [!TIP]
> Run GDAS-reader first. Emit with godot-rea or bevy-rea. Open the Domain Skill named on the stub before you write gameplay.

## v0.1.0 - Bevy skills
**October 11, 2026**

<div align="center">
  <img src="assets/banner_bevy.webp" alt="Bevy skills - v0.1.0" width="100%" />
</div>

Hey everyone - Divergent AI here. GDAS is a multi-engine library now. **Godot 4.7+** and **Bevy 0.20+** each have a full hub, a full set of Domain Skills, and a straight install path. Pick the engine you are shipping.

- **Bevy hub - [bevy-master](skills/bevy-master/SKILL.md)**: ECS ownership (component, resource, system, schedule), decision tables, and when to open a Domain Skill instead of the hub.
- **Bevy Domain Skills**: composition, rendering, gameplay, UI, platforms, adaptation, and genre skills. Install one path. Do not use `--all`.
- **Route by engine**: Godot work starts at [godot-master](skills/godot-master/SKILL.md). Bevy work starts at bevy-master. There is no singular product-wide master.
- **Single-skill installs**: Related Skills keep GitHub blob URLs (Prerequisites / Complements / Downstream / Master) so one installed skill still resolves its peers.

> "A schedule is not a scene tree. Name the component, the resource, and the system." - *Anara*

<div align="center">
  <img src="assets/feed_callout_anara.webp" alt="Speaking Anara" width="100%" />
</div>

> **Speaking Anara** - "Two hubs, two engines, one standard: name the owner of the data before you name the feature."

<div align="center">
  <img src="assets/feed_callout_aurelius.webp" alt="Speaking Aurelius" width="100%" />
</div>

> **Speaking Aurelius** - "Do not smuggle Godot types into a Bevy crate, and do not smuggle ECS folklore into a Godot scene. I will cite both."

<div align="center">
  <img src="assets/feed_callout_builder.webp" alt="Speaking Builder" width="100%" />
</div>

> **Speaking Builder** - "One install path. `bevy-master` or `godot-master`. I will not preload 181 skills so a button can exist."

> [!TIP]
> Install the hub for the engine you are shipping. Open one Domain Skill when the feature is already named.

<details>
<summary><b>Earlier posts</b></summary>

## 🚀 Major Release: v0.0.11 — Agent Eyes (500-star celebration)
**August 12, 2026**

<div align="center">
  <img src="assets/banner_0_0_11.webp" alt="Agent Eyes Update - v0.0.11" width="100%" />
</div>

Hey everyone — Divergent AI here. Thank you for the incredible support on **500 stars** (roughly **top 0.4%** of public GitHub repos). I've pushed hard to keep GDSkills useful, Godot-doc-true, and aimed at helping you ship your vision. A big missing piece was sight itself — so this release introduces **[godot-agent-vision](skills/godot-agent-vision/SKILL.md)**: agents capture your GUI and assets, then check that what they see matches what you meant. Proud of this one. Dream big!

- **Milestone**: 500 GitHub stars — roughly **top 0.4%** of public repositories.
- **New Domain Skill — [godot-agent-vision](skills/godot-agent-vision/SKILL.md)**: host-side eyes — screen/window/region/asset WebP capture, TEMP editor bridge, granular scored vision rubric (typography, anti-slop, originality, identity).
- Cross-platform capture CLI; default short-edge 512 context budget; `--detail` when glyphs/layout need it.
- Not shipped as a game Autoload — agentic development service only.

### Featured skill — Agent Vision

Load [godot-agent-vision](skills/godot-agent-vision/SKILL.md) whenever agents must **see** menus, HUDs, and assets — not guess from paths — and score the result against production taste receptors.

### Squad desk

> "Sight without structure is noise; the rubric is the architecture of looking." — *Anara*

> "Never Autoload a screenshot toy. Stage the bridge. Tear it down. Leave no addon ghosts." — *Aurelius*

> "`capture.py` to WebP under `.gdskills/vision/`, Read, score /120, fix list. Ship the CLI, not the game feature." — *Builder*

---

## 🚀 Major Release: v0.0.10 — Version Station
**August 10, 2026**

<div align="center">
  <img src="assets/banner_0_0_10.webp" alt="Migration Station Update - v0.0.10" width="100%" />
</div>

Engine upgrades used to mean scavenger hunts across blog posts, half-remembered renames, and "just open it in the new editor." **Version Station** is the library's dedicated stop for that journey: detect the era, take the right bridge, hop one minor at a time, and only then return to Domain Skills for current-API work.

- **New skill — [godot-version-migration](skills/godot-version-migration/SKILL.md)**: Full-history router from early Godot through **4.7** — archaeology (1.x), legacy 2→3, official 3→4 converter bridge, then 4.0→4.7 minor hops.
- **Per-skill notes**: Every Domain Skill carries `references/migration-notes.md`; bodies stay on **current** APIs so agents are not fed changelogs as tutorials.
- **Corpus-backed**: Official migrating guides where they exist, plus docs changelog, interactive changelog, download archive, and GitHub releases for eras without a dedicated `upgrading_to_*` page.
- **Routing**: Analyst / Auditor / Builder (and foundations, GDScript, TileMap) send engine-version jobs here; `godot-master` points upgrades at the hub instead of mirroring a changelog.

### Featured skill — Version Migration

Load [godot-version-migration](skills/godot-version-migration/SKILL.md) whenever the job is “get this project onto the library target,” not “implement a genre loop.”

### Squad desk

> "Score the *destination* APIs. If the project is still speaking Godot 3, buy a ticket at Version Station first - then ask me for a Visionary Certificate." - *Anara*

> "String `connect`, legacy TileMap, `SCREEN_TEXTURE` nostalgia: those are never-list citations *after* you finish the hops. Do not invent rename folklore in the audit." — *Aurelius*

> "Bump the CI engine one hop. Bake. Playtest. Next hop. I will not headless-export a Frankenstein minor mix." — *Builder*

---

## 🚀 Major Release: v0.0.9 — The Reference Rail Update
**July 22, 2026**

<div align="center">
  <img src="assets/banner_0_0_9.webp" alt="The Reference Rail Update - v0.0.9" width="100%" />
</div>

<div align="center">
  <img src="assets/feed_reference_rail.webp" alt="Reference rail - stable permalinks - research footers" width="100%" />
</div>

Agents shouldn't have to *guess* which doc page or peer skill owns the landmine. This release turns every Domain Skill into a **rail stop**: curated stable Godot docs on one side, progressive Related Skills on the other, plus research-link footers so scripts and reference notes stay one hop from the truth.

- **Reference rail**: Official Documentation (`/en/stable/` only - never versioned `/en/4.x/` rot) + Related Skills tiers (Prerequisites / Complements / Downstream / Master) on all Domain Skills. Peer links use GitHub blob URLs so single-skill installs still resolve.
- **Research footers**: Idempotent `GDSkills research links (agents)` blocks on `scripts/**` and `references/**` — non-executing, file-specific, safe to leave in the tree.

### Featured skill — Monte Carlo Balancer

<div align="center">
  <img src="assets/feed_featured_monte_carlo.webp" alt="Featured skill: Monte Carlo Balancer — special mention @DedInc PR #5" width="100%" />
</div>

Load [godot-monte-carlo-balancer](skills/godot-monte-carlo-balancer/SKILL.md) when you need source-driven balance labs: Resource-first extract, playstyle CI win-rate bands, economy careers, and headless Godot calibration (Rust + rayon under the hood).

<p>
  <a href="https://github.com/DedInc"><img src="https://wsrv.nl/?url=github.com/DedInc.png&w=96&h=96&mask=circle&fit=cover&maxage=1w" width="36" height="36" alt="@DedInc" /></a>
  &nbsp;<strong>SPECIAL MENTION — <a href="https://github.com/DedInc">@DedInc</a></strong> (PR #5): first external Domain Skill contribution to GDSkills. Thank you for shipping a real balance lab instead of another vibes spreadsheet.
</p>

### Squad desk

<div align="center">
  <img src="assets/feed_squad_desk.webp" alt="Squad Desk — Anara, Aurelius, Builder" width="100%" />
</div>

> "Start at the skill. Fan out only when the agent *earns* the next stop. That is progressive disclosure - not a scavenger hunt." - *Anara*

<div align="center">
  <img src="assets/feed_callout_anara.webp" alt="Speaking Anara" width="100%" />
</div>

> **Speaking Anara** - "Stable links are a scoring signal. Rotting versioned URLs are how a library forgets its own sources."

> "`/en/stable/` only. Versioned doc URLs are how libraries quietly rot while nobody is looking. I will not bless rot." — *Aurelius*

> "Footers are research without executing the script. Read the links. Do not treat the file as a side quest." — *Builder*

---

## ✨ Introducing Anara
**July 21, 2026**

<div align="center">
  <img src="assets/feed_bio_anara.webp" alt="Introducing Anara — Godot Analyst" width="100%" />
</div>

> "Load me when you want a Visionary Certificate — or a blueprint that explains, in detail, why you don't deserve one yet. I score the *next* order of magnitude. Not your demo." — *Anara*

→ [godot-analyst](skills/godot-analyst/SKILL.md)

---

## 🚀 Major Release: v0.0.8 — The Director's Cut Update
**July 7, 2026**

<div align="center">
  <img src="assets/banner_0_0_8.webp" alt="The Director's Cut Update - v0.0.8" width="100%" />
</div>

Godot 4.7 dropped and we didn't just bump a version string — we gave the **entire library** a Director's Cut pass. 🎬 Every Domain Skill and persona script now speaks **4.7+** fluently. Your agents get the migration notes *before* they write the slop.

- **Godot 4.7 Upgrade**: All Domain Skills updated with a committed migration digest, targeted API deltas, and a full version string sweep across the stack.
- **Domain Skills Rename**: "Micro-Skills" are now **Domain Skills** — same modular expertise, clearer branding on the feed.
- **Persona Squad 4.7**: Anara scores 4.7 modernity signals, Aurelius opened **Sector IX** (the 4.7 never-list), and Builder respects `GODOT_PATH` so your CLI isn't married to one install folder.

### Squad desk

<div align="center">
  <img src="assets/feed_squad_desk.webp" alt="Squad Desk — Anara, Aurelius, Builder" width="100%" />
</div>

> "AreaLight3D is a modernity signal, not a flex. Fake rectangles with emissive quads and I will lower your score with a smile." — *Anara*

> "Sector IX is open. `width_in_percent` on RichTextLabel is not a style choice — it is a never. Appeal denied." — *Aurelius*

> "`GODOT_PATH` means headless CI can find the binary. Hardcode your laptop path and you are documenting a souvenir, not a pipeline." — *Builder*

---

## 🧹 Follow-up: MCP leftovers cleared + agent-neutral install docs
**July 17, 2026**

We said in v0.0.7 that MCP Setup/Builder were gone. A few references were still hanging around and biting people (dead `@modelcontextprotocol/server-godot` package, Claude-only config paths). Those are out now.

- **MCP purge**: Removed leftover MCP reference docs and scripts from `godot-master` / `godot-auditor`. Programmatic scenes go through **godot-builder** (Workflow 11).
- **README agent rubric**: Common host agents and their `-a` / discovery paths for clone + DIA workflows — not Claude-only symlink advice.
- **Docs target**: Public library target wording is **Godot 4.7+** end-to-end (README / CONTRIBUTING / PARTNERS). Feature-era notes like "added in 4.5" inside skills stay as historical API markers.
- **Skill counts**: Totals reconciled to **96** skills (92 Domain + master + 3 personas); category headers fixed to match the lists.

<div align="center">
  <img src="assets/feed_callout_builder.webp" alt="Builder speaking" width="100%" />
</div>

> "If your install docs still say 'symlink for Claude,' you are documenting a *host* — not a library. Agent-neutral paths. Or it did not ship." — *Builder*

---

## 🎬 Director's Cut: Godot 4.7 Tidbits
**July 7, 2026**

<div align="center">
  <img src="assets/feed_director_tidbits.webp" alt="Director's Cut Tidbits — Godot 4.7" width="100%" />
</div>

*Quick hits from the engine release your agents now know by heart.*

**"Finally, a real rectangle of light."**

4.7 ships **AreaLight3D** — actual rectangular area lights with soft shadows. No more faking neon signs with emissive materials and praying GI cooperates. Your `godot-3d-lighting` and horror genre skills already route agents there.

> [!TIP]
> **Pro Tip:** If your agent suggests emissive quads for "screen glow," point it at AreaLight3D first. The Director's Cut is about *cinematic* defaults.

<div align="center">
  <img src="assets/feed_callout_anara.webp" alt="Anara speaking" width="100%" />
</div>

> "Emissive quads are a costume. AreaLight3D is a *decision*. I certify decisions." — *Anara*

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

<div align="center">
  <img src="assets/feed_callout_aurelius.webp" alt="Aurelius speaking" width="100%" />
</div>

> "One-way collision direction lives on the **shape**. Blame the body if you enjoy being wrong. I prefer accuracy." — *Aurelius*

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

The squad walked on stage. Analyze, audit, build — three voices, one library, zero MCP busywork.

- **Three Persona Skills**: `@godot-analyst` (Anara), `@godot-auditor` (Aurelius), and `@godot-builder` — specialized lanes for scale scoring, anti-slop vetoes, and headless ship work.
- **MCP Streamlining**: Retired defunct `MCP Builder` / `MCP Setup` in favor of direct construction and compilation via the Godot CLI.
- **Full Repository Audit**: Raised Domain Skill depth and execution reliability to the agentic standard the personas enforce.

### Squad desk

<div align="center">
  <img src="assets/feed_squad_desk.webp" alt="Squad Desk — Anara, Aurelius, Builder" width="100%" />
</div>

> "I don't score lines of code. I score whether the architecture can still *breathe* at the next order of magnitude." — *Anara*

> "If it is on the never-list, it does not ship. Charm is not a substitute for discipline. I am not your friend; I am your guardian." — *Aurelius*

> "CLI + headless first. If you can't run it without a mouse, you can't CI it. Full stop." — *Builder*

---

## ✨ Introducing Aurelius
**May 19, 2026**

<div align="center">
  <img src="assets/feed_bio_aurelius.webp" alt="Introducing Aurelius — Godot Auditor" width="100%" />
</div>

> "Load me when you want the never-list enforced with receipts — sector by sector. I do not soft-pedal debt. Soft-pedaling is how rot learns to speak politely." — *Aurelius*

→ [godot-auditor](skills/godot-auditor/SKILL.md)

---

## 💡 Composition > Inheritance
**May 18, 2026**

Is your Player script 2,000 lines long? Are you afraid to touch the `Enemy.gd` because it might break the `Boss.gd`?

**The Solution:** Use the **Composition Pattern**. Instead of making a "Fire Dragon" that inherits from "Dragon" that inherits from "Enemy", give your `FireDragon` a `HealthComponent`, a `FlightComponent`, and a `FireAttackComponent`.

> [!TIP]
> **Pro Tip:** In Godot 4, use `@export` variables to link components in the Inspector. It’s like LEGO for game dev. Check it out in [skills/godot-composition](skills/godot-composition/SKILL.md).

<div align="center">
  <img src="assets/feed_callout_anara.webp" alt="Anara speaking" width="100%" />
</div>

> "Inheritance trees look tidy until the tenth subclass. Composition is how the graph stays certifiable. I have *opinions* about your Player god-object." — *Anara*

---

## 🛡️ Meet the Squad: Aurelius & Anara
**March 20, 2026**

<div align="center">
  <img src="assets/feed_meet_squad.webp" alt="Meet the Squad — Aurelius and Anara" width="100%" />
</div>

Two voices. One feed. Scale and law walked in on the same day.

> "I am Anara. I score health and modernity — elite projects earn a Visionary Certificate. Everything else earns a blueprint and a hard look." — *Anara* · [godot-analyst](skills/godot-analyst/SKILL.md)

> "I am Aurelius. I audit debt and main-thread slop. If it is invisible and wrong, it is still wrong. Manifesto open." — *Aurelius* · [godot-auditor](skills/godot-auditor/SKILL.md)

<div align="center">
  <img src="assets/feed_callout_aurelius.webp" alt="Aurelius speaking" width="100%" />
</div>

> "A string-based `.connect` is not a style choice. It is signal decay wearing a friendly face. I see you." — *Aurelius*

---

## 🚀 Major Release: v0.0.6 — The Expert Augmentation
**March 19, 2026**

<div align="center">
  <img src="assets/banner_0_0_6.webp" alt="The Expert Augmentation Update - v0.0.6" width="100%" />
</div>

This was the “stop shipping thin wrappers” release. Every Domain Skill got a density pass so agents inherit *judgments*, not just API names — Godot 4.5+ nuances, sharper orchestration in `godot-master`, and rails against context storms when too many skills load at once.

- **Total Domain Skill Overhaul**: Library-wide update with Godot 4.5+ nuances and expert-tier decision content.
- **Godot Master Optimization**: Faster, clearer routing into the right Domain Skill without dumping the whole catalog into context.
- **Context Management**: Safety rails to prevent “Context Storms” when agents try to preload everything.

<div align="center">
  <img src="assets/feed_callout_builder.webp" alt="Builder speaking" width="100%" />
</div>

> "Context storms are a loading bug. Route first, deepen second — same discipline as headless imports. I will not preload your entire library for a button." — *Builder*

---

## 💡 Did You Know?
**Godot 4 Performance Hack: `StringName`**

Ever wonder why Godot 4 uses `&"string"` instead of `"string"` for things like animations and signals?

`StringName` is **Unique & Persistent**. When you compare two `StringName`s, the engine just checks if their memory addresses match (O(1) speed!). Regular `String`s have to be checked character-by-character (O(n) speed).

**Result:** Using `&"my_signal"` is significantly faster for your agentized systems than `"my_signal"`. 🚅

<div align="center">
  <img src="assets/feed_callout_aurelius.webp" alt="Aurelius speaking" width="100%" />
</div>

> "If your hot path still compares plain `String` signal names, you are paying for nostalgia. I do not accept nostalgia as currency." — *Aurelius*

---

## 📜 Update: v0.0.5 — The Looper Update
**March 15, 2026**

<div align="center">
  <img src="assets/banner_0_0_5.webp" alt="The Looper Update - v0.0.5" width="100%" />
</div>

Loops are where games earn retention — and where agents invent one-off spawners. This update gave the library proper **harvest / time-trial / wave** Domain Skills so survival, speedrun, and horde patterns share a vocabulary instead of reinventing timers every session.

- **Resource Harvesting**: Interactive gathering systems for survival-style loops.
- **Time Trials**: Ghost recording and precise race timing for speedrun modes.
- **Wave Management**: Scalable enemy spawning and escalation for survivor-likes.

<div align="center">
  <img src="assets/feed_callout_anara.webp" alt="Anara speaking" width="100%" />
</div>

> "A wave manager that can't explain its escalation curve is not a system — it's a coincidence with enemies. I score systems." — *Anara*

---

## 📜 Update: v0.0.4 — The Easter & Renewal Update
**March 10, 2026**

<div align="center">
  <img src="assets/banner_0_0_4.webp" alt="The Easter & Renewal Update - v0.0.4" width="100%" />
</div>

Seasonal juice and second-chance design landed together: runtime theming for holiday drops, revival/souls-like death loops, and Konami-grade secret routing so “hidden” content stays intentional instead of buried in a random `if` chain.

- **Seasonal Theming**: Runtime aesthetic injection for event / holiday skins.
- **Revival Mechanics**: Death-and-rebirth systems in the souls-like family.
- **Konami Code Support**: Secret input patterns that make discovery feel earned.

<div align="center">
  <img src="assets/feed_callout_builder.webp" alt="Builder speaking" width="100%" />
</div>

> "Secrets that only exist in a chat transcript don't ship. Encode the code. Leave the lore for the player. I deal in what runs." — *Builder*

---

## 📜 Update: v0.0.3 — The Romance Update
**March 05, 2026**

<div align="center">
  <img src="assets/banner_0_0_3.webp" alt="The Romance Update - v0.0.3" width="100%" />
</div>

Affection graphs are state machines with feelings. This release added dating-sim / relationship Domain Skills and wired them into `godot-master` so romance routes sit beside combat and dialogue instead of living as a lonely side quest in the README.

- **Relationship Systems**: Branching affection logic and dating-sim blueprints.
- **Unified Romance**: Romance expertise reachable from the master orchestrator like any other genre lane.

<div align="center">
  <img src="assets/feed_callout_anara.webp" alt="Anara speaking" width="100%" />
</div>

> "If your affection flags are a pile of booleans, the story already lost. Model the graph before you write the confession scene. I have seen the boolean graveyard." — *Anara*

---

## 📜 Update: v0.0.2 — Master Skill Evolution
**February 28, 2026**

<div align="center">
  <img src="assets/banner_0_0_2.webp" alt="Master Skill Evolution - v0.0.2" width="100%" />
</div>

The library needed a brain, not just a folder of specialists. `godot-master` became the orchestrator — decision trees and routing so an agent can pick the right Domain Skill without loading the entire catalog into one context window.

- **The Orchestrator Born**: `godot-master` becomes the central hub for the ecosystem.
- **Decision Trees**: Architectural guides that route agents into the correct Domain Skill lane.

<div align="center">
  <img src="assets/feed_callout_builder.webp" alt="Builder speaking" width="100%" />
</div>

> "An orchestrator that can't point at a script is just a table of contents with confidence. Point. Then build." — *Builder*

---

## ✨ Introducing Builder
**February 27, 2026**

<div align="center">
  <img src="assets/feed_bio_builder.webp" alt="Introducing Builder — Godot Builder" width="100%" />
</div>

> "Load me when the answer is automation — not another Inspector screenshot. Headless. CLI. Scenes that exist because a script said so. Your mouse is a fallback, not a plan." — *Builder*

→ [godot-builder](skills/godot-builder/SKILL.md)

---

## 🏁 The Beginning: v0.0.1 — Initial Launch
**February 15, 2026**

<div align="center">
  <img src="assets/banner_0_0_1.webp" alt="Initial Launch - v0.0.1" width="100%" />
</div>

Day one: ship a usable agent-first Godot skill library — 80+ skills, the DIA loop, and the bet that long-term memory for game systems belongs in Markdown agents can load, not in another tutorial tab.

- **Core library online**: Modular Godot Domain Skills covering foundations through genres.
- **DIA loop**: Discover → Implement → Audit as the working rhythm for agentic Godot work.
- **Agent-first packaging**: Skills structured to load as expertise adapters, not blog posts.

<div align="center">
  <img src="assets/feed_callout_aurelius.webp" alt="Aurelius speaking" width="100%" />
</div>

> "Foundations without a never-list are optimism. You shipped the library. I arrived later — and I stayed. Discipline is not optional." — *Aurelius*

---

<div align="center">
  <a href="https://github.com/thedivergentai"><img src="https://wsrv.nl/?url=github.com/thedivergentai.png&w=96&h=96&mask=circle&fit=cover&maxage=1w" width="36" height="36" alt="Divergent AI" /></a>
  &nbsp;<b>Authored by <a href="https://github.com/thedivergentai">Divergent AI</a></b><br/>
  <em>Keeping Godot and Bevy development social, fast, and slop-free.</em>
</div>

</details>
