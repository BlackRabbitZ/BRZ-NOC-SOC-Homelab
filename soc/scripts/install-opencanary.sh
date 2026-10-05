#!/usr/bin/env bash
set -euo pipefail

VERSION="0.9.9"
VENV="/opt/opencanary/venv"
CONFIG_DIR="/etc/opencanaryd"

sudo apt update
sudo apt install -y python3 python3-venv python3-pip

sudo mkdir -p /opt/opencanary "$CONFIG_DIR"
sudo python3 -m venv "$VENV"
sudo "$VENV/bin/pip" install --upgrade pip
sudo "$VENV/bin/pip" install "opencanary==${VERSION}"

if [[ ! -f "$CONFIG_DIR/opencanary.conf" ]]; then
  sudo "$VENV/bin/opencanaryd" --copyconfig || true
fi

echo
echo "OpenCanary ${VERSION} installed."
echo "Copy soc/opencanary/opencanary.conf.example to:"
echo "  /etc/opencanaryd/opencanary.conf"
echo "and review enabled services/ports before starting it."
