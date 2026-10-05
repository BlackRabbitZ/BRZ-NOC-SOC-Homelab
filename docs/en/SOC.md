# 🟥 SOC / Network Sensor Installation

Software:

```text
Suricata
ntopng
EveBox
CrowdSec
OpenCanary
```

Recommended hardware:

```text
Raspberry Pi 5
4 GB or more
SSD/NVMe
active cooling
at least 2 Ethernet ports
```

## Interface split

Example:

```text
eth0 = Management
eth1 = Mirror/SPAN
```

Always verify interface names:

```bash
ip -br link
ip -br addr
```

## Base installer

```bash
cd soc/scripts
chmod +x install-soc-base.sh
./install-soc-base.sh
```

The script does not change VLANs, IPs, firewall rules or switch settings.

## Suricata

```bash
sudo apt install -y suricata
sudo suricata-update
```

Example:

```yaml
af-packet:
  - interface: eth1
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
```

## ntopng

Use the appropriate ARM64/Debian package repository:

```text
https://packages.ntop.org/
```

## CrowdSec

```bash
cd soc/compose
docker compose up -d
```

## EveBox

```text
https://github.com/jasonish/evebox
```

## OpenCanary

Use a Python virtual environment.

## Central server

```text
Metrics ─► Prometheus
Logs ────► Loki
            │
            ▼
         Grafana
```
