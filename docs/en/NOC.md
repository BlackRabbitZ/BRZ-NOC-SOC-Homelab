# 🟦 NOC Installation

Software:

```text
Uptime Kuma
LibreNMS
Netdata
NetAlertX
```

Recommended hardware:

```text
Raspberry Pi 4
4 GB RAM
64-bit OS
SSD
1× Ethernet
```

The NOC does **not** require a mirror port.

## Base setup

```bash
sudo apt update
sudo apt full-upgrade -y
sudo reboot
```

Then:

```bash
cd noc/scripts
chmod +x install-noc-base.sh
./install-noc-base.sh
```

The script does not change IP addresses, VLANs, firewall rules or switch configuration.

## Docker services

```bash
cd noc/compose
docker compose up -d
```

Includes:

- Uptime Kuma
- NetAlertX

## LibreNMS

Use the official container documentation:

```text
https://github.com/librenms/docker
```

Prefer SNMPv3.

## Netdata

```bash
wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh
sudo sh /tmp/netdata-kickstart.sh
```

## Central server

NOC metrics/logs can feed:

```text
Prometheus
Loki
Grafana
```
