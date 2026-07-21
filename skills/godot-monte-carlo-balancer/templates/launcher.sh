#!/usr/bin/env bash
# Self-rebuilding launcher (Linux/macOS).
# Place next to the balancer crate, e.g. tools/balance_lab.sh with the crate in tools/balance_lab/.
# Rebuilds the optimized binary only when Cargo.toml or any src/*.rs is newer, then forwards all args.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CRATE_DIR="$SCRIPT_DIR/balance_lab"
MANIFEST="$CRATE_DIR/Cargo.toml"
BINARY="$CRATE_DIR/target/release/balance-lab"

needs_build=0
if [[ ! -x "$BINARY" ]]; then
    needs_build=1
else
    if [[ "$MANIFEST" -nt "$BINARY" ]]; then
        needs_build=1
    else
        while IFS= read -r -d '' src; do
            if [[ "$src" -nt "$BINARY" ]]; then
                needs_build=1
                break
            fi
        done < <(find "$CRATE_DIR/src" -name '*.rs' -print0)
    fi
fi

if [[ "$needs_build" -eq 1 ]]; then
    cargo build --release --manifest-path "$MANIFEST"
fi

exec "$BINARY" "$@"
