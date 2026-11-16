#!/usr/bin/env bash
# Optional nightly fleet snapshot. Template only: CI does not run it.
# The fleet steward's routine points this at a checkout of the private {{FLEET_REPO}}.
# Quiet on success. One-off prompts are not part of the export the routine hands in.
# A routine that disappeared is kept as a file marked deleted, not removed.
set -euo pipefail

if [ -z "${FLEET_REPO_DIR:-}" ] || [ -z "${SNAPSHOT_SRC:-}" ]; then
  echo "FAIL: set FLEET_REPO_DIR (private repo checkout) and SNAPSHOT_SRC (redacted export)" >&2
  exit 1
fi

patterns="$(cd "$(dirname "$0")" && pwd)/snapshot-leak-patterns.txt"
if [ ! -f "$patterns" ]; then
  echo "FAIL: missing $patterns" >&2
  exit 1
fi

hits=$(grep -R -n -I -E -f "$patterns" "$SNAPSHOT_SRC" || true)
if [ -n "$hits" ]; then
  echo "FAIL: credential leak scan matched" >&2
  printf '%s\n' "$hits" >&2
  exit 1
fi

mkdir -p "$FLEET_REPO_DIR/routines" "$FLEET_REPO_DIR/bots"

# Remember files this snapshot is allowed to mark deleted.
declare -A seen=()
while IFS= read -r -d '' src; do
  rel="${src#"$SNAPSHOT_SRC"/}"
  case "$rel" in
    routines/*|bots/*) ;;
    *) continue ;;
  esac
  dest="$FLEET_REPO_DIR/$rel"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  seen["$rel"]=1
done < <(find "$SNAPSHOT_SRC" -type f -print0)

if [ "${#seen[@]}" -eq 0 ]; then
  echo "FAIL: SNAPSHOT_SRC has no routines/ or bots/ files" >&2
  exit 1
fi

while IFS= read -r -d '' old; do
  rel="${old#"$FLEET_REPO_DIR"/}"
  if [ -n "${seen[$rel]:-}" ]; then
    continue
  fi
  if grep -q '^status: deleted$' "$old" 2>/dev/null; then
    continue
  fi
  cat > "$old" <<EOF
---
status: deleted
---

Deleted in the fleet. Kept so the snapshot still shows that this routine or profile existed.
EOF
done < <(find "$FLEET_REPO_DIR/routines" "$FLEET_REPO_DIR/bots" -type f -print0 2>/dev/null || true)

git -C "$FLEET_REPO_DIR" add -A routines bots
if git -C "$FLEET_REPO_DIR" diff --cached --quiet; then
  exit 0
fi
git -C "$FLEET_REPO_DIR" commit -m "Fleet snapshot" >/dev/null
git -C "$FLEET_REPO_DIR" push >/dev/null
