<div align="right">

[🇩🇪 Deutsch](README.md) | [🇬🇧 English](README-EN.md)

</div>

<div align="center">

# 🛡️ BRZ NOC / SOC Homelab

### Open-source network & security monitoring with Raspberry Pi, mirror/SPAN and central dashboards

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Platform](https://img.shields.io/badge/Platform-Raspberry%20Pi%204%20%7C%205-C51A4A)
![OS](https://img.shields.io/badge/OS-Raspberry%20Pi%20OS%2064--bit-A22846)
![NOC](https://img.shields.io/badge/NOC-Uptime%20Kuma%20%7C%20LibreNMS%20%7C%20Netdata%20%7C%20NetAlertX-blue)
![SOC](https://img.shields.io/badge/SOC-Suricata%20%7C%20ntopng%20%7C%20EveBox%20%7C%20CrowdSec%20%7C%20OpenCanary-red)

</div>

---

## 📑 Table of Contents

- [What is this project?](#-what-is-this-project)
- [Why these tools?](#-why-these-tools)
- [Why Raspberry Pi 4 for NOC and Raspberry Pi 5 for SOC?](#-why-raspberry-pi-4-for-noc-and-raspberry-pi-5-for-soc)
- [Architecture](#-architecture)
- [What runs where?](#-what-runs-where)
- [NOC Guide](#-noc-guide)
- [SOC Guide](#-soc-guide)
- [Network principle](#-network-principle)
- [Quick Start](#-quick-start)
- [Repository structure](#-repository-structure)
- [Additional documentation](#-additional-documentation)
- [Security principles](#-security-principles)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🚀 What is this project?

**BRZ NOC / SOC Homelab** is a modular, low-cost and open-source-oriented monitoring and security stack for home networks, labs and small environments.

The project deliberately separates two roles:

- 🟦 **NOC – Network Operations Center**  
  Monitors availability, network devices, systems and known/unknown devices.

- 🟥 **SOC – Security Operations Center / Network Sensor**  
  Analyzes mirrored network traffic, detects attacks, processes security events and provides honeypot/log events.

A separate central server is used for:

```text
Grafana     = dashboards
Prometheus  = metrics
Loki        = logs
```

---

## 💡 Why these tools?

📘 **More details:** [Why these tools?](docs/en/WHY-TOOLS.md)

The selection intentionally favors tools that:

- are **free to use**,
- are **open source** or provide the required base functionality for free,
- work well on Linux/Raspberry Pi,
- do not require a mandatory cloud dependency,
- can be self-hosted locally,
- are well documented,
- can be combined with each other,
- and do not require expensive enterprise licenses for homelab use.

> The goal is a stack that many users can self-host, understand and adapt.

### NOC

| Tool | Why it is included |
|---|---|
| **Uptime Kuma** | simple, modern and free availability monitoring |
| **LibreNMS** | powerful SNMP monitoring for routers, switches, APs and servers |
| **Netdata** | excellent real-time system metrics with little setup effort |
| **NetAlertX** | detects new/unknown devices and network changes |
| **ntopng** | shows network traffic, hosts, protocols and top talkers; physically runs on the SOC sensor |

### SOC

| Tool | Why it is included |
|---|---|
| **Suricata** | established open-source IDS/IPS engine for packet and signature analysis |
| **EveBox** | clear presentation of Suricata events |
| **CrowdSec** | community-driven log-based attack detection |
| **OpenCanary** | lightweight open-source honeypot |
| **ntopng** | adds traffic/flow visibility alongside Suricata security signatures |

### Zentraler Server

| Tool | Why it is included |
|---|---|
| **Grafana** | central visualization and dashboards |
| **Prometheus** | widely adopted metrics collection platform |
| **Loki** | lightweight log storage/search tightly integrated with Grafana |

More: [Why these tools?](docs/en/WHY-TOOLS.md)

---

## 🍓 Why Raspberry Pi 4 for NOC and Raspberry Pi 5 for SOC?

📘 **More details:** [Hardware & Raspberry Pi roles](docs/en/HARDWARE.md)

The two roles have very different requirements.

### Raspberry Pi 4 → NOC

The NOC Pi mainly runs light to medium workloads:

```text
Uptime Kuma
LibreNMS
Netdata
NetAlertX
```

These services:

- mainly use HTTP, SNMP, ping, APIs or periodic scans,
- do not need to inspect every packet continuously,
- normally need only **one regular Ethernet port**,
- and therefore run well on a Raspberry Pi 4 with 4 GB RAM.

### Raspberry Pi 5 → SOC / Network Sensor

The SOC Pi processes significantly more data:

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

In particular, **Suricata and ntopng** can continuously analyze large volumes of network traffic.

Therefore, the SOC benefits from:

- the faster Raspberry Pi 5 CPU,
- higher memory/I/O performance,
- better SSD/NVMe connectivity,
- active cooling,
- and additional network ports.

### Why multiple network ports?

For a clean passive sensor, management and packet capture should be separated:

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
    ├── no regular IP
    ├── Suricata
    └── ntopng

Port 3+
└── reserve / future expansion
```

A compatible **multi-port Ethernet adapter for Raspberry Pi 5** is ideal for this.

> The repository does not require a specific adapter model. The important part is that Linux reliably detects the ports and that at least one management port and one separate sensor port are available.

More: [Hardware and role selection](docs/en/HARDWARE.md)

---

## 🧩 Architecture

📘 **More details:** [Architecture overview](docs/en/ARCHITECTURE.md)

```text
                              INTERNET
                                 │
                        Router / Firewall
                                 │
                       LAN / optional VLANs
                                 │
                          Managed switch
                 ┌───────────────┼────────────────┐
                 │               │                │
                 │               │                │
             NOC Pi 4        SOC Pi 5        Clients/servers/
                 │            │    │          IoT/other networks
                 │            │    │
                 │            │    └── Mirror / SPAN
                 │            │
                 │            └── Management
                 │
                 └──────────────┐
                                │
                                ▼
                     Central monitoring
                       / dashboard server
                    ┌─────────────────────┐
                    │ Grafana             │
                    │ Prometheus          │
                    │ Loki                │
                    └─────────────────────┘
```

---

## 📦 What runs where?

| System | Software |
|---|---|
| 🟦 **NOC Pi 4** | Uptime Kuma, LibreNMS, Netdata, NetAlertX |
| 🟥 **SOC Pi 5** | Suricata, ntopng, EveBox, CrowdSec, OpenCanary |
| 🟪 **Central server** | Grafana, Prometheus, Loki |

> `ntopng` functionally belongs to the NOC, but runs on the SOC Pi because the mirror/SPAN traffic is already available there.

### 🟦 NOC Guide

➡️ [**Install & configure the NOC**](docs/en/NOC.md)

Includes:

- Uptime Kuma
- LibreNMS
- Netdata
- NetAlertX
- Docker
- ports
- updates
- troubleshooting

### 🟥 SOC Guide

➡️ [**Install & configure the SOC / network sensor**](docs/en/SOC.md)

Includes:

- Suricata
- ntopng
- EveBox
- CrowdSec
- OpenCanary
- mirror/SPAN
- multi-port NIC
- troubleshooting
---

## 🌐 Network principle

The project assumes **no fixed VLAN IDs or IP networks**.

It works:

- in a flat LAN,
- with a few VLANs,
- or in highly segmented networks.

The only recommendation is:

```text
Monitoring network → monitored networks
ALLOW only required connections

monitored networks → monitoring network
DENY by default
```

VLAN examples: [network/VLAN-PLAN.md](network/VLAN-PLAN.md)

Firewall concept: [network/FIREWALL-EXAMPLE.md](network/FIREWALL-EXAMPLE.md)

---


---

## 🚀 Quick Start

### Prepare NOC base

```bash
git clone https://github.com/BlackRabbitZ/BRZ-NOC-SOC.git
cd BRZ-NOC-SOC/noc/scripts
chmod +x install-noc-base.sh
./install-noc-base.sh
```

### Prepare SOC base

```bash
git clone https://github.com/BlackRabbitZ/BRZ-NOC-SOC.git
cd BRZ-NOC-SOC/soc/scripts
chmod +x install-soc-base.sh
./install-soc-base.sh
```

### Start central server

```bash
cd BRZ-NOC-SOC/server/compose
docker compose up -d
```

> The scripts change **no VLANs, no firewall rules, no IP addresses and no switch configuration**.

---

## 📁 Repository structure

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

## 📚 Additional documentation

- [Why these tools?](docs/en/WHY-TOOLS.md)
- [Hardware & Raspberry Pi roles](docs/en/HARDWARE.md)
- [Architecture](docs/en/ARCHITECTURE.md)
- [VLAN example](network/VLAN-PLAN.md)
- [Firewall example](network/FIREWALL-EXAMPLE.md)
- [Configuration template](network/CONFIGURATION-TEMPLATE.md)

For German, use the linked [README.md](README.md).
---

## 🔐 Security principles

- Keep the SOC sensor **passive** whenever possible.
- Do not use the mirror/SPAN port as a regular management interface.
- Separate management and sensor traffic onto different interfaces.
- Prefer SNMPv3.
- Do not expose web UIs directly to the Internet.
- Never commit secrets.
- Avoid blanket `ANY → ANY` firewall rules.

More: [SECURITY.md](SECURITY.md)

---

## 🗺️ Roadmap

- [x] NOC documentation
- [x] SOC documentation
- [x] Pi 4 / Pi 5 role split
- [x] Grafana / Prometheus / Loki
- [x] Compose examples
- [x] base installers
- [ ] ready-to-import Grafana dashboards
- [ ] alerting examples
- [ ] FreeRADIUS / 802.1X
- [ ] Wazuh integration
- [ ] Tactical RMM integration
- [ ] automated setup assistants

Mehr: [ROADMAP.md](ROADMAP.md)

---

## 🤝 Contributing

Issues, pull requests and improvement suggestions are welcome.

See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 📜 License

MIT License – see [LICENSE](LICENSE).
