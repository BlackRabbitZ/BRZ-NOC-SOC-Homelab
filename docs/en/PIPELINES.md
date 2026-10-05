# Data pipelines

## Metrics

Node Exporter runs on NOC and SOC:

```text
NOC:9100 ─┐
          ├──► Prometheus ─► Grafana
SOC:9100 ─┘
```

Configure targets in:

```text
server/compose/prometheus/targets.json
```

## Logs

Grafana Alloy runs as an agent on NOC/SOC and pushes logs to Loki:

```text
System logs ─┐
Auth logs ───┤
Suricata ────┤──► Alloy ─► Loki ─► Grafana
OpenCanary ──┘
```

## EveBox

EveBox also reads Suricata `eve.json` locally.

This provides two views:

- **EveBox** → detailed Suricata investigation
- **Grafana/Loki** → central dashboards and correlation
