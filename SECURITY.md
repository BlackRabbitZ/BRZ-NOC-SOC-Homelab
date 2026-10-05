# Security Policy

Never commit:

- passwords
- API tokens
- private keys
- RADIUS secrets
- SNMP credentials
- certificates containing private keys
- real public IP data unless intentionally shared

Recommended:

- keep management interfaces on trusted networks,
- keep the SOC sensor interface passive,
- prefer SNMPv3,
- do not expose dashboards directly to the Internet,
- restrict access using firewall rules or VPN.
