#!/usr/bin/env bash
set -euo pipefail

SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/systemd/opencanary.service"

if [[ ! -x /opt/opencanary/venv/bin/opencanaryd ]]; then
  echo "OpenCanary venv not found. Run install-opencanary.sh first." >&2
  exit 1
fi

if [[ ! -f /etc/opencanaryd/opencanary.conf ]]; then
  echo "/etc/opencanaryd/opencanary.conf not found. Configure OpenCanary first." >&2
  exit 1
fi

sudo install -m 0644 "$SOURCE" /etc/systemd/system/opencanary.service
sudo touch /var/log/opencanary.log
sudo chown nobody:nogroup /var/log/opencanary.log
sudo systemctl daemon-reload
sudo systemctl enable --now opencanary.service

sudo systemctl --no-pager --full status opencanary.service
