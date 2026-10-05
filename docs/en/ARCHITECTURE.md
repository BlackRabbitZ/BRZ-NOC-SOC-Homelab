# Architecture

```text
NOC
├── Availability
├── SNMP
├── Host metrics
└── Device discovery

SOC
├── Packet capture
├── IDS
├── Traffic/flow analysis
├── Log detection
└── Honeypot

Central Server
├── Grafana
├── Prometheus
└── Loki
```

Design principles:

- keep the SOC passive,
- separate NOC and SOC roles,
- centralize visualization on another server,
- do not depend on one router/firewall vendor,
- do not hard-code VLAN IDs,
- do not let install scripts change network configuration automatically.
