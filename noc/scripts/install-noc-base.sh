#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo " BRZ NOC - Base Installer"
echo "=========================================="
echo
echo "This script does NOT change:"
echo " - IP addresses"
echo " - VLANs"
echo " - firewall rules"
echo " - switch settings"
echo

sudo apt update
sudo apt full-upgrade -y

sudo apt install -y \
  curl wget git ca-certificates gnupg jq unzip \
  htop nano vim dnsutils iputils-ping snmp

# Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
  sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/debian \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y \
  docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker "$USER"

sudo mkdir -p /opt/brz-noc
sudo chown -R "$USER":"$USER" /opt/brz-noc

echo
echo "Base installation complete."
echo "Log out and back in before using Docker without sudo."
echo "Next: read docs/de/NOC.md or docs/en/NOC.md"
