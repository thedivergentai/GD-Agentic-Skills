#!/usr/bin/env python3
"""Emit a Godot 4.7 project from a GDAS evidence ledger. Stdlib only."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


def ident(name: str, fallback: str) -> str:
    cleaned = re.sub(r"[^A-Za-z0-9_]+", "_", name).strip("_")
    if not cleaned or cleaned[0].isdigit():
        cleaned = fallback + "_" + cleaned
    return cleaned[:60]


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


def place_asset(item: dict, out: Path, allow_assets: bool, dest_stem: str) -> str:
    source = asset_source(item)
    if allow_assets and license_allows(item) and source is not None:
        target = out / "assets" / f"{dest_stem}{source.suffix.lower()}"
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_bytes(source.read_bytes())
        return f"copied {target.name}"
    placeholder = out / "placeholders" / f"{dest_stem}.txt"
    placeholder.parent.mkdir(parents=True, exist_ok=True)
    placeholder.write_text(
        "Placeholder. Asset bytes were not copied.\n"
        f"license={item.get('license', 'unspecified')}\n"
        f"evidence: {one_line(item.get('evidence', ''))}\n",
        encoding="utf-8",
    )
    return "placeholder"


def script_body(item: dict) -> str:
    skill = item.get("suggested_skill_godot", "godot-project-foundations")
    status = item.get("status", "unknown")
    return (
        "extends Node\n"
        f"# ledger {one_line(item['id'])} status={one_line(status)}\n"
        f"# evidence: {one_line(item.get('evidence', ''))}\n"
        f"# Load {one_line(skill)} before replacing this stub.\n"
        f"# {one_line(item.get('detail', ''))}\n"
        "\n"
        "func _ready() -> void:\n"
        f"\t# Stub only. Do not invent behavior for {one_line(item['id'])}.\n"
        "\tpass\n"
    )


def emit(ledger: dict, out: Path, allow_assets: bool) -> None:
    out.mkdir(parents=True, exist_ok=True)
    (out / "scenes").mkdir(exist_ok=True)
    (out / "scripts").mkdir(exist_ok=True)
    (out / "placeholders").mkdir(exist_ok=True)
    entries = ledger.get("entries", [])
    ext_resources = []
    nodes = []
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
    for index, item in enumerate(entries, start=1):
        stem = unique_name(item["id"], used)
        script_name = stem + ".gd"
        (out / "scripts" / script_name).write_text(script_body(item), encoding="utf-8")
        ext_resources.append(
            f'[ext_resource type="Script" path="res://scripts/{script_name}" id="{index}"]'
        )
        nodes.append(
            f'[node name="{stem}" type="Node" parent="."]\n'
            f'script = ExtResource("{index}")\n'
        )
        asset_note = ""
        if item.get("kind") == "asset":
            asset_note = " " + place_asset(item, out, allow_assets, stem)
        coverage.append(
            f"- `{item['id']}` {item.get('status')} {item.get('kind')} `{item.get('name')}` "
            f"-> scripts/{script_name} via {item.get('suggested_skill_godot')}{asset_note}"
        )
    load_steps = 1 + len(ext_resources)
    scene = [f"[gd_scene load_steps={load_steps} format=3]", ""]
    scene.extend(ext_resources)
    scene.append("")
    scene.append('[node name="Main" type="Node"]')
    scene.append("")
    scene.extend(nodes)
    (out / "scenes" / "main.tscn").write_text("\n".join(scene) + "\n", encoding="utf-8")
    project = (
        "; Engine configuration file.\n"
        "config_version=5\n"
        "\n"
        "[application]\n"
        "\n"
        'config/name="Reconstructed"\n'
        'run/main_scene="res://scenes/main.tscn"\n'
        'config/features=PackedStringArray("4.7", "Forward Plus")\n'
        "\n"
        "[rendering]\n"
        "\n"
        'renderer/rendering_method="forward_plus"\n'
    )
    (out / "project.godot").write_text(project, encoding="utf-8")
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
                "status": "confirmed",
                "kind": "symbol",
                "name": "apply_damage",
                "detail": "Declaration found.\nhealth = 1",
                "evidence": "player.py",
                "suggested_skill_godot": "godot-combat-system",
                "suggested_skill_bevy": "bevy-combat-system",
            },
            {
                "id": "src_001",
                "status": "unknown",
                "kind": "symbol",
                "name": "apply_damage",
                "detail": "same display name",
                "evidence": "other.py",
                "suggested_skill_godot": "godot-project-foundations",
                "suggested_skill_bevy": "bevy-project-foundations",
            },
            {
                "id": "asset-001",
                "status": "confirmed",
                "kind": "asset",
                "name": "hero.png",
                "detail": "license=unspecified",
                "evidence": "hero.png",
                "suggested_skill_godot": "godot-project-foundations",
                "suggested_skill_bevy": "bevy-asset-scenes",
                "source_path": "",
                "license": "unspecified",
            },
        ],
    }
    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        source = root / "hero.png"
        source.write_bytes(b"PNGDATA-SOURCE")
        already = root / "already.png"
        already.write_bytes(b"PNGDATA-COPIED")
        asset = ledger["entries"][2]
        asset["source_path"] = str(source)
        asset["copied"] = str(already)
        asset["license"] = "unspecified"
        blocked = root / "blocked"
        emit(ledger, blocked, True)
        if (blocked / "assets").exists() or "not copied" not in (blocked / "placeholders" / "asset_001.txt").read_text(encoding="utf-8"):
            return 1
        asset["license"] = "CC0"
        out = root / "proj"
        emit(ledger, out, False)
        script = (out / "scripts" / "src_001.gd").read_text(encoding="utf-8")
        project = (out / "project.godot").read_text(encoding="utf-8")
        scene = (out / "scenes" / "main.tscn").read_text(encoding="utf-8")
        if "godot-combat-system" not in script or "\nhealth = 1" in script:
            return 1
        if 'name="src_001"' not in scene or 'name="src_001_2"' not in scene:
            return 1
        if "forward_plus" not in project or "Forward Plus" not in project or "uid://" in scene:
            return 1
        licensed = root / "licensed"
        emit(ledger, licensed, True)
        if (licensed / "assets" / "asset_001.png").read_bytes() != b"PNGDATA-COPIED":
            return 1
        if not (out / "COVERAGE.md").exists():
            return 1
    print("SELF-TEST OK")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Emit a Godot project from a GDAS ledger.")
    parser.add_argument("ledger", nargs="?")
    parser.add_argument("--out", help="Project directory")
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
