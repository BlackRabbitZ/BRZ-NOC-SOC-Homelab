# Central Monitoring Server

This starter stack provides:

```text
Grafana
Prometheus
Loki
```

Start:

```bash
docker compose up -d
```

Default ports:

| Service | Port |
|---|---:|
| Grafana | 3000 |
| Prometheus | 9090 |
| Loki | 3100 |

The provided Grafana provisioning automatically creates Prometheus and Loki datasources.

Production hardening is still required:

- authentication
- reverse proxy/TLS if remote access is needed
- firewall restrictions
- backup
- persistent storage sizing
