#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f .env ]]; then
  cp .env.example .env
  echo "Created .env."
  echo "Edit GF_SECURITY_ADMIN_PASSWORD before starting the stack."
fi

if grep -q 'CHANGE-ME-NOW' .env; then
  echo "ERROR: Change GF_SECURITY_ADMIN_PASSWORD in server/compose/.env first." >&2
  exit 1
fi

docker compose config >/dev/null
docker compose up -d

echo
echo "Grafana:    http://<server-ip>:3000"
echo "Prometheus: http://<server-ip>:9090"
echo "Loki:       http://<server-ip>:3100"
