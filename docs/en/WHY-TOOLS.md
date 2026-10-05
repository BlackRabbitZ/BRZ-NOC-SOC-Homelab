# Why these tools?

The project intentionally favors tools that are free, open-source-oriented, locally hostable and understandable.

## Selection criteria

Preferred tools should:

- be free or provide the required base functionality for free,
- be open source or have a usable community edition,
- support local/self-hosted operation,
- avoid mandatory cloud dependencies,
- support Linux/ARM64,
- be actively maintained,
- be documented,
- integrate well with other monitoring tools.

## NOC

- **Uptime Kuma** – availability checks.
- **LibreNMS** – SNMP-based network monitoring.
- **Netdata** – real-time host metrics.
- **NetAlertX** – device discovery.
- **ntopng** – traffic and flow visibility; physically runs on the SOC sensor in this design.

## SOC

- **Suricata** – open-source IDS/IPS.
- **EveBox** – Suricata event viewer.
- **CrowdSec** – log-based attack detection.
- **OpenCanary** – lightweight honeypot.
- **ntopng** – adds traffic/flow visibility.

## Central server

- **Prometheus** – metrics.
- **Loki** – logs.
- **Grafana** – dashboards and visualization.
