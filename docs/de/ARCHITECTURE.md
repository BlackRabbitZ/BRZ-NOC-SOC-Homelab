# Architektur

## Rollen

```text
NOC
├── Verfügbarkeit
├── SNMP
├── Systemmetriken
└── Geräteerkennung

SOC
├── Packet Capture
├── IDS
├── Flow-/Traffic-Analyse
├── Log Detection
└── Honeypot

Central Server
├── Grafana
├── Prometheus
└── Loki
```

## Datenfluss

```text
                  Netzwerk
                     │
             Managed Switch
              │           │
              │           └── Mirror/SPAN ──► SOC
              │
              └─────────────────────────────► normale Geräte

NOC ───────────────► Monitoring-Abfragen
SOC ───────────────► Security Events / Metrics
                         │
                         ▼
                 Central Monitoring Server
                 ├── Prometheus
                 ├── Loki
                 └── Grafana
```

## Designprinzipien

- SOC nicht inline betreiben.
- NOC und SOC möglichst getrennte Rollen.
- zentrale Visualisierung auf separatem Server.
- keine feste Router-/Firewall-Marke.
- keine festen VLAN-IDs.
- keine automatischen Netzwerkänderungen durch Installationsskripte.
