<div align="right">

[🇩🇪 Deutsch](README.md) | [🇬🇧 English](README-EN.md)

</div>

<div align="center">

# 🛡️ BRZ NOC / SOC Homelab

### Open-source network & security monitoring for Raspberry Pi, mirror/SPAN and central dashboards

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Platform](https://img.shields.io/badge/Platform-Raspberry%20Pi%204%20%7C%205-C51A4A)
![OS](https://img.shields.io/badge/OS-Raspberry%20Pi%20OS%2064--bit-A22846)
![NOC](https://img.shields.io/badge/NOC-Uptime%20Kuma%20%7C%20LibreNMS%20%7C%20Netdata%20%7C%20NetAlertX-blue)
![SOC](https://img.shields.io/badge/SOC-Suricata%20%7C%20ntopng%20%7C%20EveBox%20%7C%20CrowdSec%20%7C%20OpenCanary-red)

</div>

---

## 📑 Table of Contents

- [Project](#-project)
- [Goal](#-goal)
- [Why these tools?](#-why-these-tools)
- [Why Pi 4 for NOC and Pi 5 for SOC?](#-why-pi-4-for-noc-and-pi-5-for-soc)
- [Architecture](#-architecture)
- [NOC](#-noc)
- [SOC](#-soc)
- [Central monitoring server](#-central-monitoring-server)
- [Docker & Docker Compose](#-docker--docker-compose)
- [Network principle](#-network-principle)
- [Quick Start](#-quick-start)
- [Repository structure](#-repository-structure)
- [Status](#-status)
- [Security](#-security)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🚀 Project

**BRZ NOC / SOC Homelab** is a modular, self-hosted monitoring and security stack for home networks, labs and small environments.

The project deliberately separates monitoring and security:

- 🟦 **NOC on Raspberry Pi 4**
- 🟥 **SOC / network sensor on Raspberry Pi 5**
- 🟪 **Grafana + Prometheus + Loki on a separate server**
- 🌐 **Router/firewall + managed switch + optional VLANs**
- 🔎 **Port mirroring / SPAN only for the SOC sensor**

The stack is designed so that as many components as possible are **free, open source and locally self-hosted**.

---

## 🎯 Goal

A clean homelab stack that can:

- Geräte und Dienste überwacht
- Switches, Router und Interfaces per SNMP überwacht
- neue oder unbekannte Geräte erkennt
- CPU, RAM, Storage und Temperatur visualisiert
- Netzwerkverkehr analysiert
- IDS-Alarme erkennt
- Brute-Force-Angriffe erkennt
- Honeypot-Ereignisse meldet
- Logs und Metriken zentral in Grafana zusammenführt
- möglichst ohne kostenpflichtige Enterprise-Produkte auskommt

---

## 💡 Why these tools?

Bei der Auswahl wurden bewusst Tools bevorzugt, die:

- kostenlos nutzbar sind
- Open Source oder in der benötigten Basisfunktion frei verfügbar sind
- lokal betrieben werden können
- keine zwingende Cloud-Abhängigkeit haben
- Linux / ARM64 gut unterstützen
- gut dokumentiert sind
- sich miteinander kombinieren lassen
- für Homelabs keine teuren Enterprise-Lizenzen benötigen

### NOC

| Tool | Purpose | Warum |
|---|---|---|
| **Uptime Kuma** | Verfügbarkeit | einfach, modern und kostenlos |
| **LibreNMS** | SNMP-Monitoring | stark für Router, Switches, APs und Server |
| **Netdata** | Systemmetriken | sehr gute Echtzeitwerte |
| **NetAlertX** | Geräteerkennung | erkennt neue/unbekannte Geräte |
| **ntopng** | Traffic-Analyse | Hosts, Protokolle, Flows, Top-Talker |

### SOC

| Tool | Purpose | Warum |
|---|---|---|
| **Suricata** | IDS/IPS | etablierte Open-Source-Engine |
| **EveBox** | Suricata-Events | übersichtliche Detailansicht |
| **CrowdSec** | Log Detection | Brute Force, Scanner, Bots |
| **OpenCanary** | Honeypot | leichtgewichtig und Open Source |
| **ntopng** | Traffic-Sicht | ergänzt Suricata um Flow-/Traffic-Analyse |

### Central

| Tool | Purpose |
|---|---|
| **Grafana** | Dashboards |
| **Prometheus** | Metriken |
| **Loki** | Logs |

📘 [Mehr Details: Warum diese Tools?](docs/en/WHY-TOOLS.md)

---

## 🍓 Why Pi 4 for NOC and Pi 5 for SOC?

### Raspberry Pi 4 → NOC

Der NOC-Pi führt hauptsächlich leichtere Monitoring-Purposen aus:

```text
Uptime Kuma
LibreNMS
Netdata
NetAlertX
```

Diese Dienste arbeiten überwiegend mit:

- Ping
- HTTP/S
- SNMP
- APIs
- periodischen Scans

Sie müssen nicht dauerhaft jedes Netzwerkpaket inspizieren. Deshalb reicht ein **Raspberry Pi 4 mit 4 GB RAM** für diese Rolle gut aus.

### Raspberry Pi 5 → SOC

Der SOC-Pi verarbeitet wesentlich mehr Daten:

```text
Suricata
ntopng
EveBox
CrowdSec
OpenCanary
```

Vor allem **Suricata + ntopng** analysieren kontinuierlich Netzwerkverkehr.

Darum ist der Pi 5 sinnvoller:

- stärkere CPU
- höhere I/O-Leistung
- bessere SSD/NVMe-Anbindung
- mehr Reserven für parallele Analyse
- aktive Kühlung sinnvoll
- Multi-Port-Netzwerkadapter nutzbar

### Warum der Port-Adapter?

Ein sauberer passiver Sensor trennt Management und Packet Capture:

```text
SOC Pi 5

Port 1
└── Management
    ├── SSH
    ├── Web-UIs
    ├── Updates
    └── Verbindung zum zentralen Server

Port 2
└── Mirror / SPAN
    ├── keine normale IP
    ├── Suricata
    └── ntopng

Port 3+
└── Reserve
```

Das Repository setzt **kein bestimmtes Adaptermodell** voraus.

📘 [Mehr Details: Hardware & Rollen](docs/en/HARDWARE.md)

---

## 🧩 Architecture

```text
                              INTERNET
                                 │
                        Router / Firewall
                                 │
                       LAN / optionale VLANs
                                 │
                          Managed Switch
                 ┌───────────────┼────────────────┐
                 │               │                │
             NOC Pi 4        SOC Pi 5        Clients / Server /
                 │            │    │          IoT / weitere Netze
                 │            │    │
                 │            │    └── Mirror / SPAN
                 │            │
                 │            └── Management
                 │
                 └──────────────┐
                                │
                                ▼
                     Centraler Monitoring-
                       / Dashboard-Server
                    ┌─────────────────────┐
                    │ Grafana             │
                    │ Prometheus          │
                    │ Loki                │
                    └─────────────────────┘
```

📘 [Mehr Details: Architektur](docs/en/ARCHITECTURE.md)

---

## 🟦 NOC

| Tool | Purpose |
|---|---|
| **Uptime Kuma** | Verfügbarkeit von Hosts und Diensten |
| **LibreNMS** | SNMP, Router, Switches, APs, Interfaces |
| **Netdata** | CPU, RAM, Storage, Temperatur, Prozesse |
| **NetAlertX** | Geräteerkennung, IP/MAC, Online/Offline |

### Runs in Docker

```text
Uptime Kuma
NetAlertX
Node Exporter
Grafana Alloy
```

### Runs natively / separately

```text
Netdata
LibreNMS
```

📘 [NOC installieren & konfigurieren](docs/en/NOC.md)  
🐳 [NOC Docker Compose](noc/compose/compose.yaml)

---

## 🟥 SOC

| Tool | Purpose |
|---|---|
| **Suricata** | IDS / Netzwerkangriffe / Signaturen |
| **ntopng** | Traffic, Hosts, Protokolle, Top-Talker |
| **EveBox** | Suricata-Alarme übersichtlich darstellen |
| **CrowdSec** | logbasierte Angriffserkennung |
| **OpenCanary** | Honeypot / Köderdienste |

### Runs in Docker

```text
CrowdSec
EveBox
Node Exporter
Grafana Alloy
```

### Runs natively

```text
Suricata
ntopng
OpenCanary
```

> `ntopng` gehört funktional zum NOC, läuft aber physisch auf dem SOC-/Sensor-Pi, weil dort der Mirror-/SPAN-Traffic bereits anliegt.

📕 [SOC / Network Sensor installieren & konfigurieren](docs/en/SOC.md)  
🐳 [SOC Docker Compose](soc/compose/compose.yaml)

---

## 🟪 Central monitoring server

```text
Grafana     = Dashboards
Prometheus  = Metriken
Loki        = Logs
```

Der zentrale Server kann ein Linux-Server, Mini-PC, VM, NAS oder ein anderer dauerhaft laufender Host sein.

### Datenfluss

```text
NOC Pi ── Node Exporter ───────────► Prometheus ─┐
                                                │
SOC Pi ── Node Exporter ───────────► Prometheus ─┤
                                                ├──► Grafana
NOC Logs ── Grafana Alloy ─────────► Loki ───────┤
SOC Logs ── Grafana Alloy ─────────► Loki ───────┘

Mirror / SPAN
       │
       ├──► Suricata ─► eve.json ─► Alloy ─► Loki
       │                    │
       │                    └────► EveBox
       │
       └──► ntopng
```

📘 [Datenpipelines](docs/en/PIPELINES.md)  
🐳 [Server Docker Compose](server/compose/compose.yaml)

---

## 🐳 Docker & Docker Compose

Ein Teil des Projekts läuft in Docker. Netzwerknahe Sensoren wie Suricata und ntopng werden bewusst nativ betrieben.

### 1. Docker installieren

Für Debian / Raspberry Pi OS:

```bash
sudo apt update
sudo apt install -y ca-certificates curl

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
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

sudo usermod -aG docker "$USER"
```

Danach einmal ab- und wieder anmelden.

Prüfen:

```bash
docker --version
docker compose version
```

### 2. Repository klonen

```bash
git clone https://github.com/BlackRabbitZ/BRZ-NOC-SOC-Homelab.git
cd BRZ-NOC-SOC-Homelab
```

### 3. NOC starten

```bash
cd noc/compose
cp .env.example .env
nano .env
```

Anpassen:

```text
LOKI_URL=http://IP-DES-ZENTRALEN-SERVERS:3100/loki/api/v1/push
SENSOR_NAME=noc-pi
```

Start:

```bash
docker compose up -d
```

### 4. SOC starten

```bash
cd ../../soc/compose
cp .env.example .env
nano .env
```

Anpassen:

```text
LOKI_URL=http://IP-DES-ZENTRALEN-SERVERS:3100/loki/api/v1/push
SENSOR_NAME=soc-pi
```

Start:

```bash
docker compose up -d
```

### 5. Centralen Server starten

```bash
cd ../../server/compose

cp .env.example .env
nano .env
```

Mindestens ändern:

```text
GF_SECURITY_ADMIN_PASSWORD=EIN-SEHR-STARKES-PASSWORT
```

Prometheus-Ziele:

```bash
cp prometheus/targets.json.example prometheus/targets.json
nano prometheus/targets.json
```

Dann:

```bash
chmod +x setup.sh
./setup.sh
```

Weboberflächen:

```text
Grafana:    http://SERVER-IP:3000
Prometheus: http://SERVER-IP:9090
Loki:       http://SERVER-IP:3100
```

### Wichtige Docker-Befehle

```bash
docker compose ps
docker compose logs -f
docker compose pull
docker compose up -d
docker compose down
docker compose config
```

---

## 🌐 Network principle

VLANs sind **optional**.

Beispiel:

| VLAN | Zweck |
|---:|---|
| 10 | Management |
| 20 | Clients |
| 30 | Server |
| 40 | IoT |
| 50 | Cameras |
| 60 | Guests |
| 100 | Monitoring |
| 999 | Quarantine |

Grundidee:

```text
Monitoring-Netz → überwachte Netze
ALLOW nur benötigte Verbindungen

überwachte Netze → Monitoring-Netz
DENY standardmäßig
```

Der SOC-Pi nutzt zusätzlich einen dedizierten Mirror-/SPAN-Port.

📘 [VLAN-Beispiel](network/VLAN-PLAN.md)  
📘 [Firewall-Beispiel](network/FIREWALL-EXAMPLE.md)  
📘 [Konfigurationsvorlage](network/CONFIGURATION-TEMPLATE.md)

---

## 🚀 Quick Start

### NOC

```bash
git clone https://github.com/BlackRabbitZ/BRZ-NOC-SOC-Homelab.git
cd BRZ-NOC-SOC-Homelab/noc/scripts
chmod +x install-noc-base.sh
./install-noc-base.sh
```

### SOC

```bash
git clone https://github.com/BlackRabbitZ/BRZ-NOC-SOC-Homelab.git
cd BRZ-NOC-SOC-Homelab/soc/scripts
chmod +x install-soc-base.sh
./install-soc-base.sh
```

> Die Installer verändern **keine VLANs, keine IP-Adressen, keine Firewall-Regeln und keine Switch-Konfiguration**.

---

## 📁 Repository structure

```text
BRZ-NOC-SOC-Homelab/
├── README.md
├── README-EN.md
├── LICENSE
├── SECURITY.md
├── CONTRIBUTING.md
├── ROADMAP.md
├── CHANGELOG.md
├── VERSIONS.md
│
├── docs/
│   ├── de/
│   │   ├── NOC.md
│   │   ├── SOC.md
│   │   ├── WHY-TOOLS.md
│   │   ├── HARDWARE.md
│   │   ├── ARCHITECTURE.md
│   │   └── PIPELINES.md
│   └── en/
│       ├── NOC.md
│       ├── SOC.md
│       ├── WHY-TOOLS.md
│       ├── HARDWARE.md
│       ├── ARCHITECTURE.md
│       └── PIPELINES.md
│
├── noc/
│   ├── compose/
│   │   ├── compose.yaml
│   │   └── .env.example
│   ├── alloy/
│   └── scripts/
│
├── soc/
│   ├── compose/
│   │   ├── compose.yaml
│   │   └── .env.example
│   ├── alloy/
│   ├── crowdsec/
│   ├── opencanary/
│   ├── systemd/
│   ├── config/
│   └── scripts/
│
├── server/
│   └── compose/
│       ├── compose.yaml
│       ├── .env.example
│       ├── prometheus/
│       ├── loki/
│       └── grafana/
│
├── network/
│   ├── VLAN-PLAN.md
│   ├── FIREWALL-EXAMPLE.md
│   └── CONFIGURATION-TEMPLATE.md
│
├── scripts/
│   └── validate.sh
│
└── .github/
    ├── workflows/
    ├── dependabot.yml
    └── ISSUE_TEMPLATE/
```

---

## 🛠️ Status

### NOC
- [x] Uptime Kuma
- [x] LibreNMS
- [x] Netdata
- [x] NetAlertX
- [x] Node Exporter
- [x] Grafana Alloy

### SOC
- [x] Suricata
- [x] ntopng
- [x] EveBox
- [x] CrowdSec
- [x] OpenCanary
- [x] Node Exporter
- [x] Grafana Alloy

### Central
- [x] Grafana
- [x] Prometheus
- [x] Loki
- [x] automatische Grafana-Datenquellen
- [x] Starter-Dashboard
- [x] Prometheus Target-Datei

### Repository
- [x] gepinnte Versionen
- [x] GitHub Actions
- [x] Dependabot
- [x] Validierungsskript
- [x] DE / EN Dokumentation

---

## 🔐 Security

- Mirror-/SPAN-Port nicht als normales Management-Interface verwenden.
- SOC-Sensor-NIC möglichst ohne IP betreiben.
- SNMPv3 bevorzugen.
- Web-UIs nur aus vertrauenswürdigen Netzen erreichbar machen.
- Dashboards nicht direkt ins Internet veröffentlichen.
- Keine pauschalen `ANY → ANY`-Firewall-Regeln verwenden.
- Passwörter, Tokens und Secrets niemals committen.

More: [SECURITY.md](SECURITY.md)

---

## 🤝 Contributing

Fehler, Verbesserungen und Pull Requests sind willkommen.

See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 📜 License

MIT License – see [LICENSE](LICENSE).
