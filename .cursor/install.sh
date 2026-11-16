#!/usr/bin/env bash
# Cursor cloud-agent install script: makes sure bash, git and gitleaks are present.
# Idempotent. gitleaks version and checksum match .github/workflows/checks.yml.
set -euo pipefail

GITLEAKS_VERSION=8.30.1
GITLEAKS_SHA256=551f6fc83ea457d62a0d98237cbad105af8d557003051f41f3e7ca7b3f2470eb

command -v git >/dev/null || { echo "git missing from base image" >&2; exit 1; }

if command -v gitleaks >/dev/null && gitleaks version 2>/dev/null | grep -q "${GITLEAKS_VERSION}"; then
  echo "gitleaks ${GITLEAKS_VERSION} already installed"
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
curl -sSfL -o "$tmp/gitleaks.tgz" \
  "https://github.com/gitleaks/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz"
echo "${GITLEAKS_SHA256}  $tmp/gitleaks.tgz" | sha256sum -c -
tar -xzf "$tmp/gitleaks.tgz" -C "$tmp" gitleaks
if [ -w /usr/local/bin ]; then
  install -m 0755 "$tmp/gitleaks" /usr/local/bin/gitleaks
else
  sudo install -m 0755 "$tmp/gitleaks" /usr/local/bin/gitleaks
fi
gitleaks version
