#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo " BRZ SOC - Base Installer"
echo "=========================================="
echo
echo "This script does NOT change:"
echo " - IP addresses"
echo " - VLANs"
echo " - firewall rules"
echo " - switch/mirror settings"
echo
echo "Verify management and sensor interface names manually."
echo

sudo apt update
sudo apt full-upgrade -y

sudo apt install -y \
  curl wget git ca-certificates gnupg jq \
  htop nano vim tcpdump ethtool \
  pciutils usbutils \
  python3 python3-venv python3-pip \
  suricata

sudo mkdir -p /opt/brz-soc
sudo chown -R "$USER":"$USER" /opt/brz-soc

echo
echo "Detected interfaces:"
ip -br link || true

echo
echo "Base installation complete."
echo "IMPORTANT: Do not configure Suricata until the mirror/SPAN interface has been verified."
echo "Next: read docs/de/SOC.md or docs/en/SOC.md"
