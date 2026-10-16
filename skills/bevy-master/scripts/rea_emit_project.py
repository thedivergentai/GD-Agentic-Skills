#!/usr/bin/env python3
"""Emit a Bevy 0.20 crate from a GDAS evidence ledger. Stdlib only."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


def ident(name: str, fallback: str) -> str:
    cleaned = re.sub(r"[^A-Za-z0-9_]+", "_", name).strip("_").lower()
    if not cleaned or cleaned[0].isdigit():
        cleaned = fallback + "_" + cleaned
    return cleaned[:60]


def rust_type(name: str) -> str:
    parts = [part.capitalize() for part in ident(name, "feature").split("_") if part]
    return "".join(parts) or "Feature"


def load_ledger(path: Path) -> dict:
    data = json.loads(path.read_text(encoding="utf-8-sig"))
    if "entries" not in data:
        raise ValueError("ledger has no entries")
    return data


def one_line(text: str) -> str:
    return " ".join(str(text).split())


def unique_name(raw: str, used: set[str]) -> str:
    base = ident(raw, "feature")
    name = base
    number = 2
    while name in used:
        name = f"{base}_{number}"
        number += 1
    used.add(name)
    return name


def license_allows(item: dict) -> bool:
    note = str(item.get("license", "unspecified")).strip()
    return bool(note) and note.lower() != "unspecified"


def asset_source(item: dict) -> Path | None:
    copied = item.get("copied")
    if copied and Path(copied).is_file():
        return Path(copied)
    source = item.get("source_path")
    if source and Path(source).is_file():
        return Path(source)
    return None


def module_source(item: dict, module: str) -> str:
    skill = item.get("suggested_skill_bevy", "bevy-project-foundations")
    plugin = rust_type(module) + "Plugin"
    system = "tick_" + module
    detail = one_line(item.get("detail", ""))
    return (
        "use bevy::prelude::*;\n"
        "\n"
        f"/// ledger {one_line(item['id'])} status={one_line(item.get('status', 'unknown'))}\n"
        f"/// evidence: {one_line(item.get('evidence', ''))}\n"
        f"/// Load {one_line(skill)} before replacing this stub.\n"
        f"/// {detail}\n"
        f"pub struct {plugin};\n"
        "\n"
        f"impl Plugin for {plugin} {{\n"
        "    fn build(&self, app: &mut App) {\n"
        f"        app.add_systems(Update, {system});\n"
        "    }\n"
        "}\n"
        "\n"
        f"fn {system}() {{\n"
        f"    // Stub only. Do not invent behavior for {item['id']}.\n"
        "}\n"
    )


def place_asset(item: dict, out: Path, allow_assets: bool, module: str) -> str:
    source = asset_source(item)
    if allow_assets and license_allows(item) and source is not None:
        target = out / "assets" / f"{module}{source.suffix.lower()}"
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(source.read_bytes())
        return f"copied {target.name}"
    placeholder = out / "placeholders" / (module + ".txt")
    placeholder.parent.mkdir(parents=True, exist_ok=True)
    placeholder.write_text(
        "Placeholder. Asset bytes were not copied.\n"
        f"license={item.get('license', 'unspecified')}\n"
        f"evidence: {one_line(item.get('evidence', ''))}\n",
        encoding="utf-8",
    )
    return "placeholder"


def emit(ledger: dict, out: Path, allow_assets: bool) -> None:
    src = out / "src"
    features = src / "features"
    features.mkdir(parents=True, exist_ok=True)
    (out / "placeholders").mkdir(exist_ok=True)
    mods = []
    plugins = []
    coverage = [
        "# Coverage",
        "",
        f"Source: {ledger.get('source', '')}",
        f"Kind: {ledger.get('kind', '')}",
        "",
        "## Limits",
        "",
    ]
    for limit in ledger.get("limits", []):
        coverage.append(f"- {limit}")
    coverage.extend(["", "## Entries", ""])
    used: set[str] = set()
    for item in ledger.get("entries", []):
        module = unique_name(item["id"], used)
        plugin = rust_type(module) + "Plugin"
        (features / f"{module}.rs").write_text(module_source(item, module), encoding="utf-8")
        mods.append(f"pub mod {module};")
        plugins.append(f"        .add_plugins(features::{module}::{plugin})")
        asset_note = ""
        if item.get("kind") == "asset":
            asset_note = " " + place_asset(item, out, allow_assets, module)
        coverage.append(
            f"- `{item['id']}` {item.get('status')} {item.get('kind')} `{item.get('name')}` "
            f"-> src/features/{module}.rs via {item.get('suggested_skill_bevy')}{asset_note}"
        )
    (features / "mod.rs").write_text("\n".join(mods) + ("\n" if mods else ""), encoding="utf-8")
    plugin_chain = "\n".join(plugins) if plugins else ""
    main = (
        "use bevy::prelude::*;\n"
        "\n"
        "mod features;\n"
        "\n"
        "fn main() {\n"
        "    App::new()\n"
        "        .add_plugins(DefaultPlugins)\n"
        f"{plugin_chain}\n"
        "        .run();\n"
        "}\n"
    )
    (src / "main.rs").write_text(main, encoding="utf-8")
    cargo = (
        "[package]\n"
        'name = "reconstructed"\n'
        'version = "0.1.0"\n'
        'edition = "2021"\n'
        "\n"
        "[dependencies]\n"
        'bevy = "0.20"\n'
        "\n"
        "[profile.dev]\n"
        "opt-level = 1\n"
        "\n"
        '[profile.dev.package."*"]\n'
        "opt-level = 3\n"
    )
    (out / "Cargo.toml").write_text(cargo, encoding="utf-8")
    (out / "COVERAGE.md").write_text("\n".join(coverage) + "\n", encoding="utf-8")


def self_test() -> int:
    import tempfile

    ledger = {
        "source": "fixture",
        "kind": "source",
        "limits": ["cap"],
        "entries": [
            {
                "id": "src-001",
                "status": "partial",
                "kind": "symbol",
                "name": "apply_damage",
                "detail": "Name only.",
                "evidence": "player.py",
                "suggested_skill_godot": "godot-combat-system",
                "suggested_skill_bevy": "bevy-combat-system",
            }
        ],
    }
    with tempfile.TemporaryDirectory() as tmp:
        out = Path(tmp) / "game"
        emit(ledger, out, False)
        cargo = (out / "Cargo.toml").read_text(encoding="utf-8")
        module = (out / "src" / "features" / "src_001.rs").read_text(encoding="utf-8")
        main = (out / "src" / "main.rs").read_text(encoding="utf-8")
        if 'bevy = "0.20"' not in cargo:
            return 1
        if "bevy-combat-system" not in module or "fn tick_src_001()" not in module:
            return 1
        if "health" in module.lower():
            return 1
        if "DefaultPlugins" not in main or "Src001Plugin" not in main:
            return 1
    print("SELF-TEST OK")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Emit a Bevy crate from a GDAS ledger.")
    parser.add_argument("ledger", nargs="?")
    parser.add_argument("--out", help="Crate directory")
    parser.add_argument("--allow-assets", action="store_true", help="Copy asset bytes when the entry license is not unspecified. Prefers the ledger copied path.")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if args.self_test:
        return self_test()
    if not args.ledger or not args.out:
        parser.error("ledger and --out are required")
    path = Path(args.ledger)
    if not path.exists():
        print(f"Missing ledger: {path}", file=sys.stderr)
        return 2
    emit(load_ledger(path), Path(args.out), args.allow_assets)
    print(args.out)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
