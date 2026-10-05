# Deployment Configuration Template

Fill this out before deployment.

```text
Router / Firewall:
Managed Switch:

NOC management IP:
SOC management IP:
SOC management interface:
SOC mirror/SPAN interface:

Central server IP:
Grafana URL:
Prometheus URL:
Loki URL:
```

Optional networks:

```text
Management:
Clients:
Servers:
IoT:
Guests:
Monitoring:
Quarantine:
```

Mirror/SPAN:

```text
Source port(s):
Destination port:
Direction: RX / TX / Both
```

Important:

- never copy example IP addresses blindly,
- verify interface names before configuring capture,
- do not expose dashboards directly to the Internet,
- do not store secrets in Git.
