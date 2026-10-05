# Datenpipelines

## Metriken

Node Exporter läuft auf NOC und SOC:

```text
NOC:9100 ─┐
          ├──► Prometheus ─► Grafana
SOC:9100 ─┘
```

Die Ziele werden in:

```text
server/compose/prometheus/targets.json
```

eingetragen.

## Logs

Grafana Alloy läuft als Agent auf NOC/SOC und pusht Logs nach Loki:

```text
System Logs ─┐
Auth Logs ───┤
Suricata ────┤──► Alloy ─► Loki ─► Grafana
OpenCanary ──┘
```

Auf jedem Pi:

```bash
cd <noc-oder-soc>/compose
cp .env.example .env
nano .env
```

`LOKI_URL` muss auf den zentralen Loki zeigen.

## EveBox

EveBox liest Suricata `eve.json` zusätzlich lokal ein.

Damit gibt es zwei Sichten:

- **EveBox** → detaillierte Suricata-Untersuchung
- **Grafana/Loki** → zentrale Korrelation und Dashboard-Sicht
