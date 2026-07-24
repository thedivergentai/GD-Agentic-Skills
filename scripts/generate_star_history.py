#!/usr/bin/env python3
"""Fetch GitHub stargazer history and render Lattice-branded star-history SVGs.

Outputs (into --out-dir, default site/):
  - star-history.json
  - star-history-dark.svg
  - star-history-light.svg

Auth: STAR_HISTORY_TOKEN or GITHUB_TOKEN env var.
Repo: GITHUB_REPOSITORY (owner/name) or --repo owner/name.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from collections import Counter
from datetime import date, datetime, timedelta, timezone
from pathlib import Path
from typing import Any
from xml.sax.saxutils import escape

API_ROOT = "https://api.github.com"
ACCEPT_STAR = "application/vnd.github.star+json"
PER_PAGE = 100
MAX_PAGES = 400  # GitHub pagination cap (~40k stars)
USER_AGENT = "gd-agentic-skills-star-history/1.0"

WIDTH = 1200
HEIGHT = 400
PAD_L, PAD_R, PAD_T, PAD_B = 72, 48, 72, 56


def die(msg: str, code: int = 1) -> None:
    print(msg, file=sys.stderr)
    raise SystemExit(code)


def tokens_from_env() -> list[str]:
    """Prefer Actions GITHUB_TOKEN; optional STAR_HISTORY_TOKEN is fallback only.

    Fine-grained PATs with Metadata-only cannot list stargazers
    ("Resource not accessible by personal access token"). The default
    Actions GITHUB_TOKEN can, for public repos.
    """
    primary = (os.environ.get("GITHUB_TOKEN") or "").strip()
    alt = (os.environ.get("STAR_HISTORY_TOKEN") or "").strip()
    ordered: list[str] = []
    for tok in (primary, alt):
        if tok and tok not in ordered:
            ordered.append(tok)
    if not ordered:
        die("Set GITHUB_TOKEN (preferred) or STAR_HISTORY_TOKEN")
    return ordered


def resolve_repo(cli_repo: str | None) -> str:
    if cli_repo:
        return cli_repo.strip()
    env = (os.environ.get("GITHUB_REPOSITORY") or "").strip()
    if env:
        return env
    die("Pass --repo owner/name or set GITHUB_REPOSITORY")


def _is_true_rate_limit(code: int, detail: str, remaining: str | None) -> bool:
    if code == 429:
        return True
    lower = detail.lower()
    if "rate limit" in lower or "secondary rate" in lower:
        return True
    if code == 403 and remaining is not None:
        try:
            return int(remaining) == 0
        except ValueError:
            return False
    return False


def api_get(url: str, token: str, accept: str = ACCEPT_STAR) -> tuple[Any, dict[str, str]]:
    req = urllib.request.Request(
        url,
        headers={
            "Accept": accept,
            "Authorization": f"Bearer {token}",
            "X-GitHub-Api-Version": "2022-11-28",
            "User-Agent": USER_AGENT,
        },
        method="GET",
    )
    retries = 0
    while True:
        try:
            with urllib.request.urlopen(req, timeout=60) as resp:
                headers = {k.lower(): v for k, v in resp.headers.items()}
                body = resp.read().decode("utf-8")
                return json.loads(body), headers
        except urllib.error.HTTPError as e:
            remaining = e.headers.get("X-RateLimit-Remaining") if e.headers else None
            reset = e.headers.get("X-RateLimit-Reset") if e.headers else None
            retry_after = e.headers.get("Retry-After") if e.headers else None
            detail = e.read().decode("utf-8", errors="replace")[:800]
            if _is_true_rate_limit(e.code, detail, remaining) and retries < 5:
                wait = 30
                if retry_after:
                    try:
                        wait = max(5, int(retry_after))
                    except ValueError:
                        pass
                elif remaining == "0" and reset:
                    try:
                        wait = max(5, int(reset) - int(time.time()) + 2)
                    except ValueError:
                        pass
                wait = min(wait, 90)
                print(
                    f"Rate limited (HTTP {e.code}, remaining={remaining}); sleeping {wait}s…",
                    file=sys.stderr,
                )
                time.sleep(wait)
                retries += 1
                continue
            # Permission / other errors: raise with body attached for callers.
            err = urllib.error.HTTPError(e.url, e.code, detail or e.msg, e.hdrs, None)
            raise err from None
        except urllib.error.URLError as e:
            if retries < 5:
                retries += 1
                time.sleep(2**retries)
                continue
            die(f"Network error: {e}")


def api_get_with_fallback(url: str, tokens: list[str]) -> tuple[Any, dict[str, str]]:
    last_detail = ""
    for i, token in enumerate(tokens):
        try:
            return api_get(url, token)
        except urllib.error.HTTPError as e:
            last_detail = str(e.reason) if e.reason else ""
            inaccessible = "not accessible by personal access token" in last_detail.lower()
            if e.code == 403 and inaccessible and i + 1 < len(tokens):
                print(
                    f"Token {i + 1}/{len(tokens)} cannot access stargazers (403); trying next…",
                    file=sys.stderr,
                )
                continue
            die(f"GitHub API error {e.code} for {url}: {last_detail}")
    die(f"All tokens failed for {url}: {last_detail}")


def fetch_starred_at(repo: str, tokens: list[str]) -> list[str]:
    """Return list of ISO starred_at timestamps (oldest first)."""
    timestamps: list[str] = []
    for page in range(1, MAX_PAGES + 1):
        qs = urllib.parse.urlencode({"per_page": PER_PAGE, "page": page})
        url = f"{API_ROOT}/repos/{repo}/stargazers?{qs}"
        rows, headers = api_get_with_fallback(url, tokens)
        if not isinstance(rows, list):
            die(f"Unexpected stargazers payload: {type(rows)}")
        if not rows:
            break
        for row in rows:
            if not isinstance(row, dict) or "starred_at" not in row:
                die(
                    "Stargazer row missing starred_at — ensure Accept: "
                    "application/vnd.github.star+json is honored"
                )
            timestamps.append(row["starred_at"])
        print(f"Fetched page {page} ({len(timestamps)} stars)…", file=sys.stderr)
        if len(rows) < PER_PAGE:
            break
        # Light pacing
        rem = headers.get("x-ratelimit-remaining")
        if rem is not None:
            try:
                if int(rem) < 20:
                    time.sleep(1.0)
            except ValueError:
                pass
        else:
            time.sleep(0.05)
    else:
        print(
            f"WARNING: hit pagination cap ({MAX_PAGES * PER_PAGE} stars); series may be truncated.",
            file=sys.stderr,
        )
    # API returns newest-first typically; sort ascending by time
    timestamps.sort()
    return timestamps


def build_daily_series(timestamps: list[str]) -> list[dict[str, Any]]:
    if not timestamps:
        today = date.today().isoformat()
        return [{"date": today, "stars": 0}]

    counts: Counter[str] = Counter()
    for ts in timestamps:
        # starred_at like 2024-01-15T12:34:56Z
        day = ts[:10]
        counts[day] += 1

    days = sorted(counts.keys())
    start = date.fromisoformat(days[0])
    end = date.fromisoformat(days[-1])
    # Extend to today so the chart reflects current total even with no new stars
    today = datetime.now(timezone.utc).date()
    if end < today:
        end = today

    points: list[dict[str, Any]] = []
    total = 0
    cursor = start
    while cursor <= end:
        key = cursor.isoformat()
        total += counts.get(key, 0)
        points.append({"date": key, "stars": total})
        cursor = cursor + timedelta(days=1)
    return points


def downsample(points: list[dict[str, Any]], max_points: int = 400) -> list[dict[str, Any]]:
    """Keep chart path manageable; always keep first and last."""
    if len(points) <= max_points:
        return points
    step = (len(points) - 1) / (max_points - 1)
    out: list[dict[str, Any]] = []
    for i in range(max_points):
        idx = int(round(i * step))
        out.append(points[idx])
    # Ensure last point exact
    out[-1] = points[-1]
    # Deduplicate consecutive identical dates
    deduped: list[dict[str, Any]] = []
    for p in out:
        if deduped and deduped[-1]["date"] == p["date"]:
            deduped[-1] = p
        else:
            deduped.append(p)
    return deduped


def fmt_int(n: int) -> str:
    return f"{n:,}"


def month_label(d: date) -> str:
    return d.strftime("%b %Y").upper()


def theme_palette(theme: str) -> dict[str, str]:
    if theme == "light":
        return {
            "bg0": "#F3F7F4",
            "bg1": "#E8F0EA",
            "grid": "#B7D0BE",
            "line": "#1A7F37",
            "fill": "#3FB950",
            "fill_opacity": "0.18",
            "title": "#0B1A12",
            "meta": "#4A6B55",
            "axis": "#5E7A66",
            "pill_bg": "#1A7F37",
            "pill_fg": "#F3F7F4",
            "panel": "#FFFFFF",
            "glow": "#3FB950",
        }
    return {
        "bg0": "#0B1A12",
        "bg1": "#050A07",
        "grid": "#1F6B3A",
        "line": "#3FB950",
        "fill": "#3FB950",
        "fill_opacity": "0.28",
        "title": "#F4F7FB",
        "meta": "#6F9B7C",
        "axis": "#5E8A6C",
        "pill_bg": "#3FB950",
        "pill_fg": "#041208",
        "panel": "#0B1A12",
        "glow": "#3FB950",
    }


def render_svg(
    points: list[dict[str, Any]],
    repo: str,
    theme: str,
) -> str:
    pal = theme_palette(theme)
    plot = downsample(points)
    total = int(plot[-1]["stars"]) if plot else 0
    start_d = date.fromisoformat(plot[0]["date"]) if plot else date.today()
    end_d = date.fromisoformat(plot[-1]["date"]) if plot else date.today()

    chart_x = PAD_L
    chart_y = PAD_T
    chart_w = WIDTH - PAD_L - PAD_R
    chart_h = HEIGHT - PAD_T - PAD_B

    max_stars = max((int(p["stars"]) for p in plot), default=1) or 1
    n = len(plot)
    coords: list[tuple[float, float]] = []
    for i, p in enumerate(plot):
        x = chart_x if n == 1 else chart_x + (i / (n - 1)) * chart_w
        y = chart_y + chart_h - (int(p["stars"]) / max_stars) * chart_h
        coords.append((x, y))

    def path_line() -> str:
        if not coords:
            return ""
        parts = [f"M{coords[0][0]:.2f},{coords[0][1]:.2f}"]
        for x, y in coords[1:]:
            parts.append(f"L{x:.2f},{y:.2f}")
        return " ".join(parts)

    def path_area() -> str:
        if not coords:
            return ""
        bottom = chart_y + chart_h
        parts = [f"M{coords[0][0]:.2f},{bottom:.2f}", f"L{coords[0][0]:.2f},{coords[0][1]:.2f}"]
        for x, y in coords[1:]:
            parts.append(f"L{x:.2f},{y:.2f}")
        parts.append(f"L{coords[-1][0]:.2f},{bottom:.2f} Z")
        return " ".join(parts)

    # Axis ticks: ~4 x labels, ~3 y labels
    x_labels = []
    if n >= 2:
        for frac, anchor in ((0.0, "start"), (0.5, "middle"), (1.0, "end")):
            idx = int(round(frac * (n - 1)))
            d = date.fromisoformat(plot[idx]["date"])
            x = coords[idx][0]
            x_labels.append((x, month_label(d), anchor))
    y_labels = []
    for frac in (0.0, 0.5, 1.0):
        stars = int(round(max_stars * frac))
        y = chart_y + chart_h - frac * chart_h
        y_labels.append((y, fmt_int(stars)))

    # Sample node dots along the curve
    node_idxs = set()
    if n >= 2:
        for frac in (0.25, 0.5, 0.75, 1.0):
            node_idxs.add(int(round(frac * (n - 1))))
    nodes_svg = "".join(
        f'<circle cx="{coords[i][0]:.2f}" cy="{coords[i][1]:.2f}" r="4" fill="{pal["line"]}"/>'
        for i in sorted(node_idxs)
        if i < n
    )

    uid = "d" if theme == "dark" else "l"
    repo_short = repo.split("/")[-1] if "/" in repo else repo
    title = "STAR HISTORY"
    meta_right = "GD AGENTIC SKILLS"
    subtitle = (
        f"{fmt_int(total)} stars · {start_d.isoformat()} → {end_d.isoformat()}"
    )

    x_label_svg = "".join(
        f'<text x="{x:.2f}" y="{HEIGHT - 18}" text-anchor="{anchor}" '
        f'fill="{pal["axis"]}" font-family="Consolas, ui-monospace, monospace" '
        f'font-size="12">{escape(label)}</text>'
        for x, label, anchor in x_labels
    )
    y_label_svg = "".join(
        f'<text x="{PAD_L - 12}" y="{y + 4:.2f}" text-anchor="end" '
        f'fill="{pal["axis"]}" font-family="Consolas, ui-monospace, monospace" '
        f'font-size="11">{escape(label)}</text>'
        for y, label in y_labels
    )

    svg = f'''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="{WIDTH}" height="{HEIGHT}" viewBox="0 0 {WIDTH} {HEIGHT}" role="img" aria-label="Star history for {escape(repo)}">
  <title>Star history — {escape(repo)} ({fmt_int(total)} stars)</title>
  <desc>{escape(subtitle)}. Data: GitHub stargazers API. Style: Lattice Terminal.</desc>
  <defs>
    <linearGradient id="bg-{uid}" x1="0.2" y1="0" x2="0.8" y2="1">
      <stop offset="0%" stop-color="{pal["bg0"]}"/>
      <stop offset="100%" stop-color="{pal["bg1"]}"/>
    </linearGradient>
    <linearGradient id="fill-{uid}" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="{pal["fill"]}" stop-opacity="{pal["fill_opacity"]}"/>
      <stop offset="100%" stop-color="{pal["fill"]}" stop-opacity="0"/>
    </linearGradient>
    <filter id="glow-{uid}" x="-20%" y="-20%" width="140%" height="140%">
      <feGaussianBlur stdDeviation="2.4" result="b"/>
      <feMerge>
        <feMergeNode in="b"/>
        <feMergeNode in="SourceGraphic"/>
      </feMerge>
    </filter>
    <pattern id="grid-{uid}" width="20" height="20" patternUnits="userSpaceOnUse">
      <path d="M 20 0 L 0 0 0 20" fill="none" stroke="{pal["grid"]}" stroke-width="0.7" opacity="0.45"/>
    </pattern>
  </defs>
  <rect width="{WIDTH}" height="{HEIGHT}" rx="14" fill="url(#bg-{uid})"/>
  <rect x="{chart_x}" y="{chart_y}" width="{chart_w}" height="{chart_h}" fill="url(#grid-{uid})" opacity="0.7"/>
  <rect x="48" y="22" width="52" height="20" rx="4" fill="{pal["pill_bg"]}"/>
  <text x="74" y="36" text-anchor="middle" fill="{pal["pill_fg"]}" font-family="Segoe UI, system-ui, sans-serif" font-size="10" font-weight="800" letter-spacing="1.5">LIVE</text>
  <text x="112" y="38" fill="{pal["title"]}" font-family="Segoe UI, system-ui, sans-serif" font-size="18" font-weight="700" letter-spacing="2.5">{title}</text>
  <text x="{WIDTH - 48}" y="38" text-anchor="end" fill="{pal["meta"]}" font-family="Consolas, ui-monospace, monospace" font-size="12" letter-spacing="1">{escape(meta_right)}</text>
  <line x1="48" y1="52" x2="320" y2="52" stroke="{pal["line"]}" stroke-width="1" opacity="0.75"/>
  <text x="48" y="66" fill="{pal["meta"]}" font-family="Consolas, ui-monospace, monospace" font-size="12">{escape(subtitle)} · {escape(repo_short)}</text>
  <path d="{path_area()}" fill="url(#fill-{uid})"/>
  <path d="{path_line()}" fill="none" stroke="{pal["line"]}" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round" filter="url(#glow-{uid})"/>
  {nodes_svg}
  <line x1="{chart_x}" y1="{chart_y + chart_h}" x2="{chart_x + chart_w}" y2="{chart_y + chart_h}" stroke="{pal["grid"]}" stroke-width="1" opacity="0.6"/>
  <line x1="{chart_x}" y1="{chart_y}" x2="{chart_x}" y2="{chart_y + chart_h}" stroke="{pal["grid"]}" stroke-width="1" opacity="0.6"/>
  {x_label_svg}
  {y_label_svg}
</svg>
'''
    return svg


def write_outputs(
    out_dir: Path,
    repo: str,
    points: list[dict[str, Any]],
) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    payload = {
        "generated_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "repo": repo,
        "total": int(points[-1]["stars"]) if points else 0,
        "points": points,
    }
    json_path = out_dir / "star-history.json"
    json_path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {json_path} ({payload['total']} stars, {len(points)} daily points)", file=sys.stderr)

    for theme, name in (("dark", "star-history-dark.svg"), ("light", "star-history-light.svg")):
        svg = render_svg(points, repo, theme)
        path = out_dir / name
        path.write_text(svg, encoding="utf-8")
        # BOM check
        raw = path.read_bytes()
        if raw[:3] == b"\xef\xbb\xbf":
            die(f"BOM written to {path}; aborting")
        print(f"Wrote {path}", file=sys.stderr)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", help="owner/name (default: GITHUB_REPOSITORY)")
    parser.add_argument(
        "--out-dir",
        default="site",
        help="Output directory for JSON + SVGs (default: site)",
    )
    args = parser.parse_args()
    repo = resolve_repo(args.repo)
    tokens = tokens_from_env()
    print(f"Fetching stargazers for {repo} ({len(tokens)} token(s) available)…", file=sys.stderr)
    timestamps = fetch_starred_at(repo, tokens)
    print(f"Collected {len(timestamps)} stars", file=sys.stderr)
    points = build_daily_series(timestamps)
    write_outputs(Path(args.out_dir), repo, points)


if __name__ == "__main__":
    main()
