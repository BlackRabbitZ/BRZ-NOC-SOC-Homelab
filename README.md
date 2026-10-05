<div align="right">

[🇩🇪 Deutsch](README.md) | [🇬🇧 English](README-EN.md)

</div>

<div align="center">

# 🛡️ BRZ NOC / SOC Homelab

### Open-Source Network & Security Monitoring mit Raspberry Pi, Mirror/SPAN und zentralen Dashboards

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Platform](https://img.shields.io/badge/Platform-Raspberry%20Pi%204%20%7C%205-C51A4A)
![OS](https://img.shields.io/badge/OS-Raspberry%20Pi%20OS%2064--bit-A22846)
![NOC](https://img.shields.io/badge/NOC-Uptime%20Kuma%20%7C%20LibreNMS%20%7C%20Netdata%20%7C%20NetAlertX-blue)
![SOC](https://img.shields.io/badge/SOC-Suricata%20%7C%20ntopng%20%7C%20EveBox%20%7C%20CrowdSec%20%7C%20OpenCanary-red)

</div>

---

## 📑 Inhaltsverzeichnis

- [Was ist dieses Projekt?](#-was-ist-dieses-projekt)
- [Warum genau diese Tools?](#-warum-genau-diese-tools)
- [Warum Raspberry Pi 4 für NOC und Raspberry Pi 5 für SOC?](#-warum-raspberry-pi-4-für-noc-und-raspberry-pi-5-für-soc)
- [Architektur](#-architektur)
- [Was läuft wo?](#-was-läuft-wo)
- [NOC-Anleitung](#-noc-anleitung)
- [SOC-Anleitung](#-soc-anleitung)
- [Netzwerkprinzip](#-netzwerkprinzip)
- [Quick Start](#-quick-start)
- [Repository-Struktur](#-repository-struktur)
- [Weitere Dokumentation](#-weitere-dokumentation)
- [Sicherheitsprinzipien](#-sicherheitsprinzipien)
- [Roadmap](#-roadmap)
- [Mitmachen](#-mitmachen)
- [Lizenz](#-lizenz)

---

## 🚀 Was ist dieses Projekt?

**BRZ NOC / SOC Homelab** ist ein modularer, möglichst kostenloser und Open-Source-orientierter Monitoring- und Security-Stack für Heimnetzwerke, Labs und kleine Umgebungen.

Das Projekt trennt zwei Aufgaben bewusst:

- 🟦 **NOC – Network Operations Center**  
  Überwacht Verfügbarkeit, Netzwerkgeräte, Systeme und bekannte/unbekannte Geräte.

- 🟥 **SOC – Security Operations Center / Network Sensor**  
  Analysiert gespiegelten Netzwerkverkehr, erkennt Angriffe, wertet Security-Events aus und stellt Honeypot-/Log-Ereignisse bereit.

Zusätzlich gibt es einen separaten zentralen Server für:

```text
Grafana     = Dashboards
Prometheus  = Metriken
Loki        = Logs
```

---

## 💡 Warum genau diese Tools?

📘 **Mehr Details:** [Warum diese Tools?](docs/de/WHY-TOOLS.md)

Bei der Auswahl wurden bewusst Werkzeuge bevorzugt, die:

- **kostenlos nutzbar** sind,
- **Open Source** oder zumindest in der benötigten Basisfunktion frei verfügbar sind,
- auf Linux/Raspberry Pi gut funktionieren,
- keine zwingende Cloud-Abhängigkeit haben,
- lokal betrieben werden können,
- gut dokumentiert sind,
- miteinander kombinierbar sind,
- und für Homelabs keine teuren Enterprise-Lizenzen voraussetzen.

> Ziel ist ein Stack, den möglichst viele Nutzer selbst hosten und nachvollziehen können.

### NOC

| Tool | Warum wir es nehmen |
|---|---|
| **Uptime Kuma** | einfache, moderne und kostenlose Verfügbarkeitsüberwachung |
| **LibreNMS** | leistungsfähiges SNMP-Monitoring für Router, Switches, APs und Server |
| **Netdata** | sehr gute Echtzeit-Systemmetriken bei geringem Einrichtungsaufwand |
| **NetAlertX** | erkennt neue/unbekannte Geräte und Netzwerkänderungen |
| **ntopng** | zeigt Netzwerkverkehr, Hosts, Protokolle und Top-Talker; läuft physisch auf dem SOC-Sensor |

### SOC

| Tool | Warum wir es nehmen |
|---|---|
| **Suricata** | etablierte Open-Source IDS/IPS-Engine für Paket- und Signaturanalyse |
| **EveBox** | übersichtliche Darstellung von Suricata-Ereignissen |
| **CrowdSec** | Community-basierte, logbasierte Angriffserkennung |
| **OpenCanary** | leichtgewichtiger Open-Source-Honeypot |
| **ntopng** | ergänzt Suricata um Verkehrs-/Flow-Sicht statt reiner Security-Signaturen |

### Zentraler Server

| Tool | Warum wir es nehmen |
|---|---|
| **Grafana** | zentrale Visualisierung und Dashboards |
| **Prometheus** | de-facto Standard für frei verfügbare Metrik-Erfassung |
| **Loki** | leichtgewichtige Log-Speicherung und Suche, eng mit Grafana integriert |

Mehr dazu: [Warum diese Tools?](docs/de/WHY-TOOLS.md)

---

## 🍓 Warum Raspberry Pi 4 für NOC und Raspberry Pi 5 für SOC?

📘 **Mehr Details:** [Hardware & Raspberry-Pi-Rollen](docs/de/HARDWARE.md)

Die Rollen haben sehr unterschiedliche Anforderungen.

### Raspberry Pi 4 → NOC

Der NOC-Pi führt überwiegend leichte bis mittlere Dienste aus:

```text
Uptime Kuma
LibreNMS
Netdata
NetAlertX
```

Diese Dienste:

- arbeiten hauptsächlich mit HTTP, SNMP, Ping, APIs oder periodischen Scans,
- müssen nicht dauerhaft jedes Netzwerkpaket inspizieren,
- benötigen normalerweise nur **einen normalen Ethernet-Port**,
- und laufen daher gut auf einem Raspberry Pi 4 mit 4 GB RAM.

### Raspberry Pi 5 → SOC / Network Sensor

Der SOC-Pi verarbeitet deutlich mehr Daten:

```text
Suricata
+
ntopng
+
EveBox
+
CrowdSec
+
OpenCanary
```

Vor allem **Suricata und ntopng** können permanent große Mengen Netzwerkverkehr analysieren.

Darum profitiert der SOC deutlich von:

- stärkerer CPU des Raspberry Pi 5,
- höherer Speicher-/I/O-Leistung,
- besserer SSD/NVMe-Anbindung,
- aktiver Kühlung,
- und zusätzlichen Netzwerkports.

### Warum mehrere Netzwerkports?

Für einen sauberen passiven Sensor sollten Management und Paketmitschnitt getrennt sein:

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
└── Reserve / spätere Erweiterungen
```

Ein kompatibler **Multi-Port-Ethernet-Adapter für den Raspberry Pi 5** ist dafür ideal.

> Das Repository setzt kein bestimmtes Adaptermodell voraus. Entscheidend ist nur, dass Linux die Ports zuverlässig erkennt und mindestens ein separater Management- und ein separater Sensor-Port verfügbar sind.

Mehr dazu: [Hardware- und Rollenwahl](docs/de/HARDWARE.md)

---

## 🧩 Architektur

📘 **Mehr Details:** [Architekturübersicht](docs/de/ARCHITECTURE.md)

```text
                              INTERNET
                                 │
                        Router / Firewall
                                 │
                       LAN / optional VLANs
                                 │
                          Managed Switch
                 ┌───────────────┼────────────────┐
                 │               │                │
                 │               │                │
             NOC Pi 4        SOC Pi 5        Clients/Server/
                 │            │    │          IoT/weitere Netze
                 │            │    │
                 │            │    └── Mirror / SPAN
                 │            │
                 │            └── Management
                 │
                 └──────────────┐
                                │
                                ▼
                     Zentraler Monitoring-
                       / Dashboard-Server
                    ┌─────────────────────┐
                    │ Grafana             │
                    │ Prometheus          │
                    │ Loki                │
                    └─────────────────────┘
```

---

## 📦 Was läuft wo?

| System | Software |
|---|---|
| 🟦 **NOC Pi 4** | Uptime Kuma, LibreNMS, Netdata, NetAlertX |
| 🟥 **SOC Pi 5** | Suricata, ntopng, EveBox, CrowdSec, OpenCanary |
| 🟪 **Zentraler Server** | Grafana, Prometheus, Loki |

> `ntopng` gehört funktional zum NOC, läuft aber auf dem SOC-Pi, weil dort der Mirror-/SPAN-Traffic bereits anliegt.

### 🟦 NOC-Anleitung

➡️ [**NOC installieren & konfigurieren**](docs/de/NOC.md)

Enthält unter anderem:

- Uptime Kuma
- LibreNMS
- Netdata
- NetAlertX
- Docker
- Ports
- Updates
- Troubleshooting

### 🟥 SOC-Anleitung

➡️ [**SOC / Network Sensor installieren & konfigurieren**](docs/de/SOC.md)

Enthält unter anderem:

- Suricata
- ntopng
- EveBox
- CrowdSec
- OpenCanary
- Mirror/SPAN
- Multi-Port-NIC
- Troubleshooting
---

## 🌐 Netzwerkprinzip

Das Projekt setzt **keine festen VLAN-IDs oder IP-Netze voraus**.

Es funktioniert:

- in einem flachen LAN,
- mit wenigen VLANs,
- oder in stärker segmentierten Netzwerken.

Empfohlen wird lediglich:

```text
Monitoring-Netz → überwachte Netze
ALLOW nur benötigte Verbindungen

überwachte Netze → Monitoring-Netz
DENY standardmäßig
```

VLAN-Beispiele: [network/VLAN-PLAN.md](network/VLAN-PLAN.md)

Firewall-Grundidee: [network/FIREWALL-EXAMPLE.md](network/FIREWALL-EXAMPLE.md)

---


---

## 🚀 Quick Start

### NOC Basis vorbereiten

```bash
git clone https://github.com/BlackRabbitZ/BRZ-NOC-SOC.git
cd BRZ-NOC-SOC/noc/scripts
chmod +x install-noc-base.sh
./install-noc-base.sh
```

### SOC Basis vorbereiten

```bash
git clone https://github.com/BlackRabbitZ/BRZ-NOC-SOC.git
cd BRZ-NOC-SOC/soc/scripts
chmod +x install-soc-base.sh
./install-soc-base.sh
```

### Zentralen Server starten

```bash
cd BRZ-NOC-SOC/server/compose
docker compose up -d
```

> Die Skripte ändern **keine VLANs, keine Firewall-Regeln, keine IP-Adressen und keine Switch-Konfiguration**.

---

## 📁 Repository-Struktur

```text
BRZ-NOC-SOC/
├── README.md
├── README-EN.md
├── LICENSE
├── SECURITY.md
├── CONTRIBUTING.md
├── ROADMAP.md
│
├── docs/
│   ├── de/
│   │   ├── NOC.md
│   │   ├── SOC.md
│   │   ├── WHY-TOOLS.md
│   │   ├── HARDWARE.md
│   │   └── ARCHITECTURE.md
│   └── en/
│       ├── NOC.md
│       ├── SOC.md
│       ├── WHY-TOOLS.md
│       ├── HARDWARE.md
│       └── ARCHITECTURE.md
│
├── noc/
│   ├── compose/
│   │   └── compose.yaml
│   └── scripts/
│       └── install-noc-base.sh
│
├── soc/
│   ├── compose/
│   │   └── compose.yaml
│   ├── config/
│   │   └── suricata-interface.example.yaml
│   └── scripts/
│       └── install-soc-base.sh
│
├── server/
│   └── compose/
│       ├── compose.yaml
│       ├── prometheus/
│       ├── loki/
│       └── grafana/
│
├── network/
│   ├── VLAN-PLAN.md
│   ├── FIREWALL-EXAMPLE.md
│   └── CONFIGURATION-TEMPLATE.md
│
└── .github/
    └── ISSUE_TEMPLATE/
```

---

## 📚 Weitere Dokumentation

- [Warum diese Tools?](docs/de/WHY-TOOLS.md)
- [Hardware & Raspberry-Pi-Rollen](docs/de/HARDWARE.md)
- [Architektur](docs/de/ARCHITECTURE.md)
- [VLAN-Beispiel](network/VLAN-PLAN.md)
- [Firewall-Beispiel](network/FIREWALL-EXAMPLE.md)
- [Konfigurationsvorlage](network/CONFIGURATION-TEMPLATE.md)

Für Englisch siehe die verlinkte [README-EN.md](README-EN.md).
---

## 🔐 Sicherheitsprinzipien

- SOC-Sensor möglichst **passiv** betreiben.
- Mirror-/SPAN-Port nicht als normales Management-Interface verwenden.
- Management und Sensor-Traffic auf getrennte Interfaces legen.
- SNMPv3 bevorzugen.
- Web-UIs nicht direkt ins Internet veröffentlichen.
- Secrets niemals committen.
- Keine pauschalen `ANY → ANY`-Firewall-Regeln.

Mehr: [SECURITY.md](SECURITY.md)

---

## 🗺️ Roadmap

- [x] NOC-Dokumentation
- [x] SOC-Dokumentation
- [x] Rollenaufteilung Pi 4 / Pi 5
- [x] Grafana / Prometheus / Loki
- [x] Compose-Beispiele
- [x] Basis-Installer
- [ ] fertige Grafana-Dashboards
- [ ] Alerting-Beispiele
- [ ] FreeRADIUS / 802.1X
- [ ] Wazuh-Integration
- [ ] Tactical-RMM-Integration
- [ ] automatisierte Setup-Assistenten

Mehr: [ROADMAP.md](ROADMAP.md)

---

## 🤝 Mitmachen

Issues, Pull Requests und Verbesserungsvorschläge sind willkommen.

Siehe [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 📜 Lizenz

MIT License – siehe [LICENSE](LICENSE).
