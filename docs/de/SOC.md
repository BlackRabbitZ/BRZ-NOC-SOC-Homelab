# 🟥 SOC / Network Sensor Installation

> SOC = passive Paketinspektion, IDS, Flow-Analyse, Log Detection und Honeypot.

## Software

```text
Suricata
ntopng
EveBox
CrowdSec
OpenCanary
```

## Hardware

Empfohlen:

```text
Raspberry Pi 5
4 GB oder mehr
SSD/NVMe
aktive Kühlung
mindestens 2 Ethernet-Ports
```

---

## 1. Interface-Aufteilung

Beispiel:

```text
eth0 = Management
eth1 = Mirror/SPAN
```

**Nicht blind übernehmen.**

Prüfen:

```bash
ip -br link
ip -br addr
```

---

## 2. Basis-Installer

```bash
cd soc/scripts
chmod +x install-soc-base.sh
./install-soc-base.sh
```

Das Skript verändert keine VLANs, IPs, Firewall- oder Switch-Regeln.

---

## 3. Sensor-Port

Der Mirror-/SPAN-Port sollte möglichst:

```text
keine IPv4
keine IPv6
kein DHCP
kein Gateway
```

besitzen.

Beispiel:

```bash
sudo ip addr flush dev eth1
sudo ip link set eth1 up
```

---

## 4. Suricata

Installation:

```bash
sudo apt install -y suricata
```

Interface-Beispiel:

```yaml
af-packet:
  - interface: eth1
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
```

Test:

```bash
sudo suricata -T -c /etc/suricata/suricata.yaml
```

Rules:

```bash
sudo suricata-update
```

Events:

```text
/var/log/suricata/eve.json
```

---

## 5. ntopng

ntopng soll auf demselben Mirror-/SPAN-Interface lauschen.

Vor Installation das passende ARM64/Debian-Repository unter:

```text
https://packages.ntop.org/
```

prüfen.

Beispielkonfiguration:

```text
-i=eth1
-w=3000
```

---

## 6. CrowdSec

```bash
cd soc/compose
docker compose up -d
```

Das Compose-Beispiel enthält CrowdSec.

CrowdSec analysiert Logs.

Zum aktiven Blockieren ist zusätzlich ein Remediation Component/Bouncer nötig.

---

## 7. EveBox

EveBox visualisiert Suricata-Events.

Projekt:

```text
https://github.com/jasonish/evebox
```

Da sich Releases/Backends ändern können, aktuelle ARM64-Dokumentation verwenden.

---

## 8. OpenCanary

Installation in Python-Venv:

```bash
sudo mkdir -p /opt/opencanary
sudo chown "$USER":"$USER" /opt/opencanary

cd /opt/opencanary
python3 -m venv env
source env/bin/activate

pip install --upgrade pip
pip install opencanary
```

Config:

```bash
opencanaryd --copyconfig
```

---

## 9. Mirror/SPAN am Switch

Prinzip:

```text
Source Port(s)
    │
    ▼
Switch Mirror Engine
    │
    ▼
Destination Port
    │
    ▼
SOC Sensor NIC
```

Destination-NIC nicht als normales Management-Interface benutzen.

---

## 10. Zentraler Server

SOC-Daten können zentral gespeichert werden:

```text
Metriken ─► Prometheus
Logs ─────► Loki
              │
              ▼
           Grafana
```

Suricata `eve.json` eignet sich besonders für Log-Pipelines.

---

## Performance

Besonders relevant:

```text
Suricata + ntopng
```

Prüfen:

- CPU
- RAM
- Temperatur
- Disk I/O
- Packet Drops

Mirror-Traffic testen:

```bash
sudo tcpdump -ni eth1
```

---

## Troubleshooting

```bash
sudo systemctl status suricata
sudo journalctl -u suricata -n 100 --no-pager

sudo systemctl status ntopng
sudo journalctl -u ntopng -n 100 --no-pager
```
