#!/usr/bin/env python3
"""Classify an artifact and write a GDAS evidence ledger. Stdlib only."""

from __future__ import annotations

import argparse
import json
import re
import struct
import sys
import tempfile
from pathlib import Path

CAP = 40
SOURCE_EXT = {
    ".py", ".gd", ".rs", ".cs", ".cpp", ".c", ".h", ".hpp", ".js", ".ts",
    ".lua", ".java", ".go", ".swift", ".kt",
}
ASSET_EXT = {
    ".png", ".jpg", ".jpeg", ".webp", ".gif", ".wav", ".ogg", ".mp3",
    ".gltf", ".glb", ".svg",
}
WEB_EXT = {".html", ".htm", ".css", ".js", ".mjs"}
SYMBOL_RE = re.compile(
    r"(?m)^[ \t]*(?:pub(?:\([^)]*\))?\s+)?(?:async\s+)?(?:unsafe\s+)?(?:def|fn|func|function|class_name|class|struct)\s+([A-Za-z_][A-Za-z0-9_]*)"
)

GODOT_SKILLS = {
    "combat": "godot-combat-system",
    "input": "godot-input-handling",
    "screen": "godot-scene-management",
    "save": "godot-save-load-systems",
    "ui": "godot-ui-containers",
    "asset": "godot-project-foundations",
    "entity": "godot-composition",
    "default": "godot-project-foundations",
}
BEVY_SKILLS = {
    "combat": "bevy-combat-system",
    "input": "bevy-input-handling",
    "screen": "bevy-state-machines",
    "save": "bevy-save-load",
    "ui": "bevy-ui-layout",
    "asset": "bevy-asset-scenes",
    "entity": "bevy-ecs-composition",
    "default": "bevy-project-foundations",
}


def slot_for(name: str) -> str:
    tokens = set(re.findall(r"[a-z0-9]+", name.lower()))
    if tokens & {"health", "damage", "attack", "hit"}:
        return "combat"
    if tokens & {"button", "label", "menu", "hud", "dialog", "ui", "title"}:
        return "ui"
    if tokens & {"input", "key", "axis", "move"}:
        return "input"
    if tokens & {"save", "load", "slot"}:
        return "save"
    if tokens & {"scene", "screen", "level", "lobby", "state", "phase", "mode"}:
        return "screen"
    return "default"


def entry(index: str, number: int, status: str, kind: str, name: str, detail: str, evidence: str) -> dict:
    slot = slot_for(name + " " + kind)
    if kind == "asset":
        slot = "asset"
    if kind == "screen":
        slot = "screen"
    if kind == "input":
        slot = "input"
    return {
        "id": f"{index}-{number:03d}",
        "status": status,
        "kind": kind,
        "name": name[:180],
        "detail": detail[:400],
        "evidence": evidence[:400],
        "suggested_skill_godot": GODOT_SKILLS[slot if slot in GODOT_SKILLS else "default"],
        "suggested_skill_bevy": BEVY_SKILLS[slot if slot in BEVY_SKILLS else "default"],
    }


def push(bucket: list, limits: list, item: dict, label: str) -> None:
    if len(bucket) >= CAP:
        note = f"{label} truncated at {CAP} entries."
        if note not in limits:
            limits.append(note)
        return
    bucket.append(item)


def read_text(path: Path, limits: list | None = None, limit: int = 200_000) -> str:
    data = path.read_bytes()
    if len(data) > limit:
        note = f"{path.name} truncated at {limit} bytes."
        if limits is not None and note not in limits:
            limits.append(note)
        data = data[:limit]
    return data.decode("utf-8-sig", errors="replace")


UI_WORDS = ("button", "label", "menu", "title", "hud", "dialog", "score")
STATE_RE = re.compile(r"\b((?:[A-Za-z_][A-Za-z0-9_]*)?(?:state|phase|mode))\b", re.I)
QUOTED_RE = re.compile(r"""(["'])((?:\\.|(?!\1).){2,80})\1""")


def scan_source(root: Path, limits: list) -> list:
    items: list = []
    files = [p for p in root.rglob("*") if p.is_file() and p.suffix.lower() in SOURCE_EXT]
    if root.is_file():
        files = [root]
    number = 1
    seen: set[str] = set()
    for path in sorted(files):
        text = read_text(path, limits)
        rel = str(path if root.is_file() else path.relative_to(root))
        names = SYMBOL_RE.findall(text)
        if not names and not QUOTED_RE.search(text) and not STATE_RE.search(text):
            push(items, limits, entry("src", number, "unknown", "symbol", path.stem, "No declarations parsed.", rel), "source")
            number += 1
            continue
        for name in names:
            seen.add(name)
            push(items, limits, entry("src", number, "confirmed", "symbol", name, "Declaration found in source text.", rel), "source")
            number += 1
            if len(items) >= CAP:
                break
        for _quote, body in QUOTED_RE.findall(text):
            if not any(word in body.lower() for word in UI_WORDS):
                continue
            push(items, limits, entry("src", number, "confirmed", "string", body, "UI-shaped string literal. Behavior around it is not proven.", rel), "source")
            number += 1
            if len(items) >= CAP:
                break
        for name in STATE_RE.findall(text):
            if name in seen:
                continue
            seen.add(name)
            push(items, limits, entry("src", number, "partial", "symbol", name, "State-looking name. The transition rules were not parsed.", rel), "source")
            number += 1
            if len(items) >= CAP:
                break
        if len(items) >= CAP:
            break
    return items


def scan_web(root: Path, limits: list) -> list:
    items: list = []
    html_files = [root] if root.is_file() else sorted(p for p in root.rglob("*") if p.suffix.lower() in {".html", ".htm"})
    number = 1
    for path in html_files:
        text = read_text(path, limits)
        rel = path.name if root.is_file() else str(path.relative_to(root))
        visible = re.sub(r"<script[\s\S]*?</script>", " ", text, flags=re.I)
        visible = re.sub(r"<style[\s\S]*?</style>", " ", visible, flags=re.I)
        title = re.search(r"<title>(.*?)</title>", visible, re.I | re.S)
        if title:
            push(items, limits, entry("web", number, "confirmed", "screen", re.sub(r"\s+", " ", title.group(1)).strip(), "Document title.", rel), "web")
            number += 1
        for heading in re.findall(r"<h1[^>]*>(.*?)</h1>", text, re.I | re.S):
            name = re.sub(r"<[^>]+>", "", heading)
            name = re.sub(r"\s+", " ", name).strip()
            if name:
                push(items, limits, entry("web", number, "confirmed", "screen", name, "Top-level heading.", rel), "web")
                number += 1
        for src in re.findall(r"""<script[^>]+src=["']([^"']+)["']""", text, re.I):
            push(items, limits, entry("web", number, "confirmed", "symbol", src, "Script URL. Body was not executed.", rel), "web")
            number += 1
        for src in re.findall(r"""<img[^>]+src=["']([^"']+)["']""", text, re.I):
            push(items, limits, entry("web", number, "confirmed", "asset", src, "Image URL. Bytes were not copied.", rel), "web")
            number += 1
        if len(items) >= CAP:
            break
    json_files = [] if root.is_file() else sorted(p for p in root.rglob("*.json") if p.is_file())
    for path in json_files:
        rel = str(path.relative_to(root))
        try:
            payload = json.loads(read_text(path, limits))
        except json.JSONDecodeError:
            push(items, limits, entry("web", number, "unknown", "symbol", path.name, "JSON file did not parse.", rel), "web")
            number += 1
            continue
        keys = list(json_key_paths(payload))
        if len(keys) > CAP:
            limits.append(f"JSON keys in {path.name} truncated at {CAP}.")
        for key in keys:
            if len(items) >= CAP:
                note = f"web truncated at {CAP} entries."
                if note not in limits:
                    limits.append(note)
                break
            push(items, limits, entry("web", number, "confirmed", "symbol", key, "JSON key. Values are not treated as mechanics.", rel), "web")
            number += 1
    if not items:
        push(items, limits, entry("web", 1, "unknown", "screen", root.name, "No HTML title or heading.", str(root)), "web")
    limits.append("Script bodies were not executed or decompiled.")
    return items


def json_key_paths(value, prefix: str = ""):
    if isinstance(value, dict):
        for key, child in value.items():
            path = f"{prefix}.{key}" if prefix else str(key)
            yield path
            yield from json_key_paths(child, path)
    elif isinstance(value, list):
        for index, child in enumerate(value):
            yield from json_key_paths(child, f"{prefix}[{index}]")


def scan_assets(root: Path, limits: list, license_note: str, copy_dir: Path | None) -> list:
    items: list = []
    files = [root] if root.is_file() else sorted(p for p in root.rglob("*") if p.is_file() and p.suffix.lower() in ASSET_EXT)
    number = 1
    note = (license_note or "").strip()
    if note.lower() == "unspecified":
        note = ""
    allow_copy = bool(note) and copy_dir is not None
    for path in files:
        if len(items) >= CAP:
            note_cap = f"assets truncated at {CAP} entries."
            if note_cap not in limits:
                limits.append(note_cap)
            break
        rel = path.name if root.is_file() else str(path.relative_to(root))
        shown = note or "unspecified"
        item = entry("asset", number, "confirmed", "asset", path.name, f"Media file. license={shown}.", rel)
        item["source_path"] = str(path)
        item["license"] = shown
        if allow_copy:
            dest = copy_dir / rel
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.write_bytes(path.read_bytes())
            item["copied"] = str(dest)
            item["detail"] += " Bytes copied under the operator license note."
        else:
            item["detail"] += " Bytes were not copied."
        items.append(item)
        number += 1
    if allow_copy:
        limits.append(f"Asset bytes copied to {copy_dir}. license={license_note}.")
    elif note:
        limits.append(f"Operator license note recorded: {license_note}. Pass --allow-assets with --out to copy bytes.")
    else:
        limits.append("Asset license is unspecified. Bytes were not copied.")
    return items


def leb(data: bytes, offset: int) -> tuple[int, int]:
    value = 0
    shift = 0
    while offset < len(data):
        byte = data[offset]
        offset += 1
        value |= (byte & 0x7F) << shift
        if byte < 128:
            return value, offset
        shift += 7
        if shift > 35:
            break
    raise ValueError("bad leb128")


def skip_limits(body: bytes, cursor: int) -> int:
    flags = body[cursor]
    cursor += 1
    _, cursor = leb(body, cursor)
    if flags & 1:
        _, cursor = leb(body, cursor)
    return cursor


def wasm_name(data: bytes, offset: int) -> tuple[str, int]:
    length, offset = leb(data, offset)
    raw = data[offset:offset + length]
    offset += length
    return raw.decode("utf-8", errors="replace"), offset


def scan_wasm(path: Path, limits: list) -> list:
    data = path.read_bytes()
    items: list = []
    if len(data) < 8 or data[:4] != b"\x00asm":
        return [entry("wasm", 1, "unknown", "symbol", path.name, "Missing WASM magic.", path.name)]
    try:
        return _scan_wasm_sections(path, data, limits, items)
    except (ValueError, IndexError) as exc:
        limits.append(f"{path.name} WASM section parse stopped: {exc}.")
        if not items:
            items.append(entry("wasm", 1, "unknown", "symbol", path.name, "WASM section was truncated.", path.name))
        return items


def _scan_wasm_sections(path: Path, data: bytes, limits: list, items: list) -> list:
    offset = 8
    number = 1
    while offset < len(data) and len(items) < CAP:
        section_id = data[offset]
        offset += 1
        size, offset = leb(data, offset)
        body = data[offset:offset + size]
        offset += size
        cursor = 0
        if section_id == 2:
            count, cursor = leb(body, cursor)
            for _ in range(count):
                module, cursor = wasm_name(body, cursor)
                field, cursor = wasm_name(body, cursor)
                kind = body[cursor]
                cursor += 1
                if kind == 0:
                    _, cursor = leb(body, cursor)
                elif kind == 1:
                    cursor += 1
                    cursor = skip_limits(body, cursor)
                elif kind == 2:
                    cursor = skip_limits(body, cursor)
                elif kind == 3:
                    cursor += 2
                else:
                    break
                push(items, limits, entry("wasm", number, "confirmed", "import", f"{module}.{field}", "WASM import.", path.name), "wasm")
                number += 1
                if len(items) >= CAP:
                    break
        elif section_id == 7:
            count, cursor = leb(body, cursor)
            for _ in range(count):
                name, cursor = wasm_name(body, cursor)
                cursor += 1
                _, cursor = leb(body, cursor)
                push(items, limits, entry("wasm", number, "confirmed", "symbol", name, "WASM export.", path.name), "wasm")
                number += 1
                if len(items) >= CAP:
                    break
    strings = re.findall(rb"[\x20-\x7e]{6,80}", data)
    kept = 0
    for raw in strings:
        if kept >= 10:
            limits.append(f"{path.name} printable strings truncated at 10.")
            break
        text = raw.decode("ascii")
        if text.startswith("asm"):
            continue
        push(items, limits, entry("wasm", number, "partial", "string", text, "ASCII run inside the module. Not a proven mechanic. Non-ASCII text is not harvested.", path.name), "wasm")
        number += 1
        kept += 1
    limits.append("WASM function bodies were not lifted.")
    if not items:
        items.append(entry("wasm", 1, "unknown", "symbol", path.name, "No imports or exports parsed.", path.name))
    return items


def cstrings(data: bytes, limit: int = 30) -> tuple[list[str], bool]:
    found = []
    truncated = False
    for raw in re.findall(rb"[\x20-\x7e]{6,120}", data[:2_000_000]):
        text = raw.decode("ascii")
        if text in found:
            continue
        if len(found) >= limit:
            truncated = True
            break
        found.append(text)
    if len(data) > 2_000_000:
        truncated = True
    return found, truncated


def scan_pe(path: Path, limits: list) -> list:
    data = path.read_bytes()
    if len(data) < 0x40 or data[:2] != b"MZ":
        return [entry("pe", 1, "unknown", "import", path.name, "MZ header is missing or shorter than 64 bytes.", path.name)]
    try:
        e_lfanew = struct.unpack_from("<I", data, 0x3C)[0]
    except struct.error:
        return [entry("pe", 1, "unknown", "import", path.name, "PE offset could not be read.", path.name)]
    if e_lfanew < 0 or e_lfanew + 4 > len(data) or data[e_lfanew:e_lfanew + 4] != b"PE\x00\x00":
        limits.append("MZ stub without a readable PE signature. The import table was not parsed.")
        return [entry("pe", 1, "unknown", "import", path.name, "PE signature missing.", path.name)]
    items: list = []
    number = 1
    push(items, limits, entry("pe", number, "confirmed", "import", "PE", "Portable Executable signature. Import directory was not walked.", path.name), "pe")
    number += 1
    strings, truncated = cstrings(data)
    if truncated:
        limits.append("PE printable strings truncated at 30, or the scan stopped at 2 MB.")
    for text in strings:
        detail = "Printable string. The import table was not parsed."
        if text.lower().endswith(".dll"):
            detail = "Printable string ending in .dll. Not an import-table entry."
        push(items, limits, entry("pe", number, "partial", "string", text, detail, path.name), "pe")
        number += 1
    limits.append("PE machine code was not decompiled.")
    return items


def scan_elf(path: Path, limits: list) -> list:
    data = path.read_bytes()
    if len(data) < 16 or data[:4] != b"\x7fELF":
        return [entry("elf", 1, "unknown", "import", path.name, "ELF header is missing or shorter than 16 bytes.", path.name)]
    bits = "64-bit" if data[4] == 2 else "32-bit" if data[4] == 1 else "unknown-class"
    items = [entry("elf", 1, "confirmed", "import", f"ELF {bits}", "ELF identification. Dynamic section was not walked.", path.name)]
    number = 2
    strings, truncated = cstrings(data)
    if truncated:
        limits.append("ELF printable strings truncated at 30, or the scan stopped at 2 MB.")
    for text in strings:
        detail = "Printable string. The dynamic section was not parsed."
        if text.startswith("lib") and ".so" in text:
            detail = "Printable string that looks like a shared object. Not a dynamic-section entry."
        push(items, limits, entry("elf", number, "partial", "string", text, detail, path.name), "elf")
        number += 1
    limits.append("ELF machine code was not decompiled.")
    return items


def classify(path: Path) -> str:
    if path.is_file():
        suffix = path.suffix.lower()
        head = path.read_bytes()[:8]
        if suffix == ".wasm" or head[:4] == b"\x00asm":
            return "wasm"
        if head[:2] == b"MZ":
            return "pe"
        if head[:4] == b"\x7fELF":
            return "elf"
        if suffix in {".html", ".htm"}:
            return "web"
        if suffix in ASSET_EXT:
            return "assets"
        if suffix in SOURCE_EXT:
            return "source"
        return "unknown"
    counts = {"web": 0, "assets": 0, "source": 0, "wasm": 0}
    for child in path.rglob("*"):
        if not child.is_file():
            continue
        suffix = child.suffix.lower()
        if suffix in {".html", ".htm"}:
            counts["web"] += 3
        elif suffix in WEB_EXT:
            counts["web"] += 1
        elif suffix in ASSET_EXT:
            counts["assets"] += 1
        elif suffix in SOURCE_EXT:
            counts["source"] += 1
        elif suffix == ".wasm":
            counts["wasm"] += 2
    best = max(counts, key=counts.get)
    if counts[best] == 0:
        return "unknown"
    return best


def kinds_present(path: Path) -> list[str]:
    if path.is_file():
        return [classify(path)]
    flags = {"source": False, "web": False, "assets": False, "wasm": False}
    for child in path.rglob("*"):
        if not child.is_file():
            continue
        suffix = child.suffix.lower()
        if suffix in {".html", ".htm", ".json"}:
            flags["web"] = True
        if suffix in ASSET_EXT:
            flags["assets"] = True
        if suffix in SOURCE_EXT:
            flags["source"] = True
        if suffix == ".wasm":
            flags["wasm"] = True
    found = [name for name in ("source", "web", "assets", "wasm") if flags[name]]
    return found or ["unknown"]


def build_ledger(path: Path, license_note: str, copy_dir: Path | None = None) -> dict:
    kinds = kinds_present(path)
    limits: list[str] = []
    entries: list = []
    for kind in kinds:
        if kind == "source":
            entries.extend(scan_source(path, limits))
        elif kind == "web":
            entries.extend(scan_web(path, limits))
        elif kind == "assets":
            entries.extend(scan_assets(path, limits, license_note, copy_dir))
        elif kind == "wasm":
            targets = [path] if path.is_file() else sorted(path.rglob("*.wasm"))
            if len(targets) > 1:
                limits.append(f"{len(targets)} WASM modules. Scanning stops at the entry cap.")
            for target in targets:
                entries.extend(scan_wasm(target, limits))
                if len(entries) >= CAP:
                    break
        elif kind == "pe":
            entries.extend(scan_pe(path, limits))
        elif kind == "elf":
            entries.extend(scan_elf(path, limits))
        else:
            limits.append("Artifact class was not recognized.")
            entries.append(entry("unk", 1, "unknown", "symbol", path.name, "No supported parser.", str(path)))
    return {
        "source": str(path),
        "kind": kinds[0] if len(kinds) == 1 else "mixed",
        "limits": limits,
        "entries": entries,
    }


def minimal_wasm() -> bytes:
    # (module (func (export "tick") (import "env" "log"))) is hand-built below.
    # type section: one func type () -> ()
    # import section: env.log func 0
    # function section empty because the only func is imported
    # export section: tick -> func 0
    def uleb(value: int) -> bytes:
        out = bytearray()
        while True:
            byte = value & 0x7F
            value >>= 7
            if value:
                out.append(byte | 0x80)
            else:
                out.append(byte)
                return bytes(out)

    def section(section_id: int, body: bytes) -> bytes:
        return bytes([section_id]) + uleb(len(body)) + body

    def name(text: str) -> bytes:
        raw = text.encode("ascii")
        return uleb(len(raw)) + raw

    type_body = uleb(1) + bytes([0x60, 0x00, 0x00])
    import_body = uleb(1) + name("env") + name("log") + bytes([0x00]) + uleb(0)
    export_body = uleb(1) + name("tick") + bytes([0x00]) + uleb(0)
    return b"\x00asm" + struct.pack("<I", 1) + section(1, type_body) + section(2, import_body) + section(7, export_body)


def self_test() -> int:
    failures = []
    fixture_root = Path(__file__).resolve().parents[1] / "fixtures"
    source_ledger = build_ledger(fixture_root / "source", "")
    if source_ledger["kind"] != "source":
        failures.append("source kind")
    names = {item["name"] for item in source_ledger["entries"]}
    if "apply_damage" not in names or "read_input" not in names:
        failures.append("source symbols")
    for item in source_ledger["entries"]:
        if item["kind"] == "symbol" and item["name"] in {"apply_damage", "read_input"} and item["status"] != "confirmed":
            failures.append("declaration should be confirmed")
    if "Start Button" not in names or not any(item["name"] == "phase" and item["status"] == "partial" for item in source_ledger["entries"]):
        failures.append("ui string or state name")
    button = next(item for item in source_ledger["entries"] if item["name"] == "Start Button")
    if button["suggested_skill_godot"] != "godot-ui-containers":
        failures.append("button routes to ui")
    web = build_ledger(fixture_root / "web", "")
    web_names = {item["name"] for item in web["entries"]}
    if web["kind"] != "web" or "Lobby" not in web_names:
        failures.append("web lobby")
    if "player.health" not in web_names or "screen" not in web_names:
        failures.append("json keys")
    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        wasm_path = root / "sample.wasm"
        wasm_path.write_bytes(minimal_wasm())
        wasm = build_ledger(wasm_path, "")
        wasm_names = {item["name"] for item in wasm["entries"]}
        if wasm["kind"] != "wasm" or "tick" not in wasm_names or "env.log" not in wasm_names:
            failures.append("wasm imports and exports")
        pe_path = root / "sample.exe"
        pe_path.write_bytes(b"MZ" + b"\x00" * 58 + struct.pack("<I", 64) + b"PE\x00\x00" + b"kernel32.dll\x00" + b"HealthBar____")
        pe = build_ledger(pe_path, "")
        if pe["kind"] != "pe":
            failures.append("pe kind")
        if not any(item["status"] == "partial" and "HealthBar" in item["name"] for item in pe["entries"]):
            failures.append("pe string stays partial")
        if any(item["status"] == "confirmed" and str(item["name"]).endswith(".dll") for item in pe["entries"]):
            failures.append("dll string is not an import")
        short = root / "short.exe"
        short.write_bytes(b"MZ")
        try:
            short_ledger = build_ledger(short, "")
        except Exception as exc:
            failures.append(f"short pe raised {exc}")
        else:
            if short_ledger["entries"][0]["status"] != "unknown":
                failures.append("short pe")
        elf_path = root / "sample.elf"
        elf_path.write_bytes(b"\x7fELF\x02" + b"\x00" * 20 + b"libgame.so\x00")
        elf = build_ledger(elf_path, "")
        if elf["kind"] != "elf":
            failures.append("elf kind")
        asset_dir = root / "art"
        asset_dir.mkdir()
        (asset_dir / "hero.png").write_bytes(b"\x89PNG\r\n\x1a\n")
        assets = build_ledger(asset_dir, "")
        if assets["kind"] != "assets" or any(item.get("copied") for item in assets["entries"]):
            failures.append("assets")
        if not any(item.get("license") == "unspecified" for item in assets["entries"]):
            failures.append("license gap")
        copied = build_ledger(asset_dir, "CC0", root / "copied")
        copied_file = root / "copied" / "hero.png"
        if not copied_file.is_file() or copied_file.read_bytes() != b"\x89PNG\r\n\x1a\n":
            failures.append("asset copy")
        if not any(item.get("copied") for item in copied["entries"]):
            failures.append("copied field")
    if failures:
        print("SELF-TEST FAILED: " + ", ".join(failures))
        return 1
    print("SELF-TEST OK")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Write a GDAS evidence ledger.")
    parser.add_argument("artifact", nargs="?", help="File or directory to read")
    parser.add_argument("--out", help="Ledger JSON path. Default: stdout")
    parser.add_argument("--license-note", default="", help="Required with --allow-assets. Recorded on asset entries.")
    parser.add_argument("--allow-assets", action="store_true", help="Copy asset bytes next to --out. Requires --license-note.")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args()
    if args.self_test:
        return self_test()
    if not args.artifact:
        parser.error("artifact path is required")
    if args.allow_assets and not args.license_note:
        parser.error("--allow-assets requires --license-note")
    if args.allow_assets and not args.out:
        parser.error("--allow-assets requires --out")
    path = Path(args.artifact)
    if not path.exists():
        print(f"Missing artifact: {path}", file=sys.stderr)
        return 2
    copy_dir = None
    if args.allow_assets:
        copy_dir = Path(args.out).parent / "copied-assets"
    ledger = build_ledger(path, args.license_note, copy_dir)
    payload = json.dumps(ledger, indent=2)
    if args.out:
        Path(args.out).write_text(payload + "\n", encoding="utf-8")
        print(args.out)
    else:
        print(payload)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
