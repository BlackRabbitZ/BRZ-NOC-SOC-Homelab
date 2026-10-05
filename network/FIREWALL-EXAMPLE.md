# Firewall Example

Vendor-neutral principle:

```text
Monitoring → monitored networks
ALLOW only required services

monitored networks → Monitoring
DENY by default
```

Typical examples:

| Purpose | Direction | Protocol |
|---|---|---|
| Ping | NOC → device | ICMP |
| SNMP | NOC → device | UDP 161 |
| HTTPS/API | NOC → device | TCP 443 |
| SSH | management → server | TCP 22 |
| Syslog | device → log collector | configured port |
| Prometheus | Prometheus → exporter | exporter-specific |

Do not blindly create broad `ANY → ANY` rules.
