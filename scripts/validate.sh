#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "[1/4] Bash syntax"
while IFS= read -r -d '' script; do
  bash -n "$script"
done < <(find . -type f -name '*.sh' -print0)

echo "[2/4] JSON syntax"
python3 - <<'PY'
import json
from pathlib import Path
for p in Path(".").rglob("*.json"):
    json.loads(p.read_text())
    print("OK", p)
PY

echo "[3/4] YAML parse"
python3 - <<'PY'
try:
    import yaml
except ImportError:
    print("PyYAML not installed; skipping YAML parser.")
    raise SystemExit(0)
from pathlib import Path
for p in list(Path(".").rglob("*.yml")) + list(Path(".").rglob("*.yaml")):
    if ".github" in p.parts and p.name.endswith(".yml"):
        pass
    with p.open() as f:
        list(yaml.safe_load_all(f))
    print("OK", p)
PY

echo "[4/4] Docker Compose config"
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  for dir in noc/compose soc/compose server/compose; do
    echo "Checking $dir"
    (
      cd "$dir"
      if [[ -f .env.example && ! -f .env ]]; then cp .env.example .env; fi
      if [[ "$dir" == "server/compose" ]]; then
        sed -i 's/CHANGE-ME-NOW/validation-only-password/' .env
      fi
      docker compose config >/dev/null
    )
  done
else
  echo "Docker Compose unavailable; skipping compose validation."
fi

echo "Validation complete."
