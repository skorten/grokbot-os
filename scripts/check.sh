#!/usr/bin/env bash
# Grok Bot OS repo checks: leak scan + install consistency.
# Runs locally (bash scripts/check.sh) and in CI (.github/workflows/checks.yml).
# Needs bash, GNU grep, git, python3. Runs gitleaks too if it's on PATH.
set -uo pipefail

# git rev-parse is the repo root inside a checkout. Outside one, fall back to
# the parent of this script: "$(dirname "$0")/..". The old form dirname "$0"/..
# passed "scripts/check.sh/.." to dirname, so cd failed and the scan stayed put.
repo_root=$(git rev-parse --show-toplevel 2>/dev/null) || repo_root="$(dirname "$0")/.."
cd "$repo_root" || { echo "FAIL: couldn't find a git repo or files to scan"; exit 1; }
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "FAIL: couldn't find a git repo or files to scan"
  exit 1
fi

fail=0
err() { echo "FAIL: $*"; fail=1; }
ok()  { echo "ok:   $*"; }

# Files to scan: everything tracked or about to be, minus this script
# (it contains the patterns) and LICENSE (standard license text).
mapfile -t FILES < <(git ls-files --cached --others --exclude-standard \
  | grep -v -x -e 'scripts/check.sh' -e 'LICENSE' \
  | while read -r f; do [ -f "$f" ] && echo "$f"; done)
# An empty list means git ls-files failed or nothing is tracked. Scanning zero
# files makes every grep succeed, so never treat that as a pass.
if [ "${#FILES[@]}" -eq 0 ]; then
  echo "FAIL: couldn't find a git repo or files to scan"
  exit 1
fi

scan() { # scan <label> <grep -E pattern> [allow-filter-regex]
  local label="$1" pat="$2" allow="${3:-}" hits
  hits=$(grep -n -I -E -i -- "$pat" "${FILES[@]}" 2>/dev/null || true)
  if [ -n "$allow" ] && [ -n "$hits" ]; then
    hits=$(printf '%s\n' "$hits" | grep -v -E -- "$allow" || true)
  fi
  if [ -n "$hits" ]; then err "$label"; printf '%s\n' "$hits" | sed 's/^/      /'; else ok "no $label"; fi
}

scan_cs() { # case-sensitive variant (street addresses need capitalized names to avoid prose like "30 minutes each way")
  local label="$1" pat="$2" hits
  hits=$(grep -n -I -E -- "$pat" "${FILES[@]}" 2>/dev/null || true)
  if [ -n "$hits" ]; then err "$label"; printf '%s\n' "$hits" | sed 's/^/      /'; else ok "no $label"; fi
}

echo "== Leak scan (${#FILES[@]} files)"
scan "Notion URLs"            'notion\.(so|site)|notion\.com/'
scan "UUIDs (agent/page IDs)" '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}'
scan "32-hex IDs"             '(^|[^0-9a-f])[0-9a-f]{32}([^0-9a-f]|$)'
scan "Notion view references" 'view://'
scan "email addresses"        '[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}'
scan "phone numbers"          '(\+?1[ .-]?)?\(?[0-9]{3}\)?[ .-][0-9]{3}[ .-][0-9]{4}([^0-9]|$)'
scan_cs "street addresses"    '[0-9]{1,6} +([A-Z][A-Za-z0-9.]* +){1,3}(Street|St|Avenue|Ave|Road|Rd|Boulevard|Blvd|Lane|Ln|Drive|Dr|Court|Ct|Way|Place|Pl|Terrace|Ter|Highway|Hwy|Parkway|Pkwy|Circle|Cir)\.?([^A-Za-z]|$)|(P\.? ?O\.? Box|Apt\.?|Suite) +[0-9]+'
scan "secret-looking tokens"  '(ghp|gho|ghu|ghs|ghr)_[a-z0-9]{20,}|github_pat_[a-z0-9_]{20,}|xox[abprs]-[a-z0-9-]{10,}|AKIA[0-9A-Z]{16}|sk-[a-z0-9_-]{20,}|secret_[a-z0-9]{30,}|ntn_[a-z0-9]{30,}|-----BEGIN [A-Z ]*PRIVATE KEY-----'
# The owner's GitHub handle and name may appear only in the repo link, the NOTICE copyright line,
# and LICENSE (which is not scanned).
scan "owner handle/name outside the repo link" 'skorten|korten' 'https://github\.com/skorten/grokbot-os([^A-Za-z0-9_-]|$)|^NOTICE:[0-9]+:Copyright [0-9]{4} Sean Korten$'

if command -v gitleaks >/dev/null 2>&1; then
  if gitleaks git --no-banner --redact . >/dev/null 2>&1 && gitleaks dir --no-banner --redact . >/dev/null 2>&1; then
    ok "gitleaks (history and working tree)"
  else
    err "gitleaks found something; run: gitleaks git -v --redact . && gitleaks dir -v --redact ."
  fi
else
  echo "skip: gitleaks not installed (CI runs it)"
fi

echo "== Consistency"
python3 - <<'PY' || fail=1
import os, re, sys, glob
bad = 0
def err(m):
    global bad; bad = 1; print("FAIL: " + m)
def ok(m): print("ok:   " + m)

readme = open("README.md").read()
arch = open("architecture.md").read()

# README install prompt: the ```text block under "## Install prompt".
m = re.search(r"^## Install prompt\n(.*?)^```text\n(.*?)^```", readme, re.S | re.M)
if not m:
    err("README has no ```text block under '## Install prompt'"); prompt = ""
else:
    prompt = m.group(2); ok("README install prompt found")

# architecture.md section 8.
m8 = re.search(r"^## 8\. Install.*?$(.*?)(?=^## |\Z)", arch, re.S | re.M)
sec8 = m8.group(1) if m8 else ""
if not m8: err("architecture.md has no '## 8. Install' section")
else: ok("architecture.md section 8 found")

def steps(text, pat):
    return [int(n) for n in re.findall(pat, text, re.M)]
ps = steps(prompt, r"^Step (\d+)\.")
as_ = steps(sec8, r"^\*\*Step (\d+)\.")
want = list(range(8))
for name, got in (("README prompt", ps), ("architecture.md section 8", as_)):
    if got == want: ok(f"{name}: steps 0-7 present, once each, in order")
    else: err(f"{name}: steps are {got}, expected {want}")

# Install section 8 is referenced as such in the prompt.
if prompt and "section 8" not in prompt: err("README prompt doesn't point at architecture.md section 8")

# Notion write access is a stated prerequisite in both, and checked in step 0.
for name, text in (("README prompt", prompt), ("architecture.md section 8", sec8)):
    if not re.search(r"prerequisite", text, re.I) or not re.search(r"write access", text, re.I):
        err(f"{name}: Notion write access isn't stated as a prerequisite")
    s0 = re.search(r"Step 0\..*?(?=Step 1\.|\Z)", text, re.S)
    if not s0 or "Notion" not in s0.group(0) or "write access" not in s0.group(0) or not re.search(r"\bstop\b", s0.group(0), re.I):
        err(f"{name}: step 0 doesn't check Notion write access and stop if missing")
    else: ok(f"{name}: Notion write access prerequisite + step 0 check")

# The read-only sentence follows the Prerequisite line in both places.
READONLY = "Having write access doesn't mean you use it: during the install you only read Notion. Notion Librarian does every Notion write, from step 3 on."
for name, text in (("README prompt", prompt), ("architecture.md section 8", sec8)):
    lines = text.splitlines()
    idx = [i for i, l in enumerate(lines) if re.match(r"(\*\*)?Prerequisite", l)]
    if len(idx) == 1 and idx[0] + 1 < len(lines) and lines[idx[0] + 1].strip() == READONLY:
        ok(f"{name}: read-only sentence follows the Prerequisite line")
    else:
        err(f"{name}: the line right after Prerequisite must be: {READONLY}")

# Every profile the prompt or section 8 names, and every repo path anywhere, exists.
path_re = re.compile(r"(?<![\w/.-])((?:profiles|notion|scripts|\.github)/[\w./*-]+|[\w-]+\.(?:md|csv)|LICENSE)(?![\w/-])")
missing = set()
for f in [p for p in glob.glob("**/*.md", recursive=True)]:
    for ref in path_re.findall(open(f).read()):
        ref = ref.rstrip(".")
        if "<" in ref or "{" in ref: continue
        # A path resolves from the repo root or from the referencing file's folder.
        if not (glob.glob(ref) or glob.glob(os.path.join(os.path.dirname(f), ref))):
            missing.add(f"{f} -> {ref}")
if missing: err("referenced files missing:\n      " + "\n      ".join(sorted(missing)))
else: ok("every referenced repo path exists")

# The prompt is read from the repo root, so its file references must be root-relative.
for ref in path_re.findall(prompt):
    ref = ref.rstrip(".")
    if not glob.glob(ref): err(f"README prompt names {ref}, which isn't a repo-root path")
for ref in re.findall(r"profiles/[\w-]+\.md", prompt + sec8):
    if not os.path.exists(ref): err(f"install names {ref}, which doesn't exist")

# Internal markdown links and anchors resolve.
def slug(h):
    h = re.sub(r"[^\w\- ]", "", h.strip().lower())
    return h.replace(" ", "-")
broken = []
for f in glob.glob("**/*.md", recursive=True):
    text = open(f).read()
    text_nocode = re.sub(r"```.*?```", "", text, flags=re.S)
    for target in re.findall(r"\]\(([^)\s]+)\)", text_nocode):
        if re.match(r"[a-z]+:", target): continue
        path, _, anchor = target.partition("#")
        dest = os.path.normpath(os.path.join(os.path.dirname(f), path)) if path else f
        if not os.path.exists(dest): broken.append(f"{f} -> {target}"); continue
        if anchor and dest.endswith(".md"):
            heads = [slug(h) for h in re.findall(r"^#+\s+(.*)$", open(dest).read(), re.M)]
            if anchor not in heads: broken.append(f"{f} -> {target} (no such heading)")
if broken: err("broken internal links:\n      " + "\n      ".join(broken))
else: ok("internal markdown links resolve")

# Every {{PLACEHOLDER}} used anywhere is documented in the README Placeholders section.
pm = re.search(r"^## Placeholders\n(.*?)(?=^## )", readme, re.S | re.M)
documented = set(re.findall(r"\{\{([A-Z_]+)", pm.group(1))) if pm else set()
used = set()
for f in glob.glob("**/*.md", recursive=True):
    used |= set(re.findall(r"\{\{([A-Z_]+)", open(f).read()))
undoc = sorted(used - documented)
if undoc: err("placeholders used but not in README Placeholders: " + ", ".join(undoc))
else: ok(f"all {len(used)} placeholder names documented")

# License present and mentioned.
if not os.path.exists("LICENSE") or "Apache License" not in open("LICENSE").read(): err("LICENSE missing or not Apache-2.0")
elif "LICENSE" not in readme: err("README doesn't mention the license")
else: ok("LICENSE present and referenced in README")

sys.exit(bad)
PY

echo
if [ "$fail" -ne 0 ]; then echo "Checks FAILED"; exit 1; fi
echo "All checks passed"
