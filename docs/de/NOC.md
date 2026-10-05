# 🟦 NOC Installation

> NOC = Verfügbarkeit, SNMP, Systemmetriken und Geräteerkennung.

## Software

```text
Uptime Kuma
LibreNMS
Netdata
NetAlertX
```

## Hardware

Empfohlen:

```text
Raspberry Pi 4
4 GB RAM
64-bit OS
SSD
1× Ethernet
```

Der NOC benötigt **keinen Mirror-Port**.

---

## 1. Betriebssystem

Empfohlen:

```text
Raspberry Pi OS Lite 64-bit
```

SSH aktivieren und anschließend:

```bash
sudo apt update
sudo apt full-upgrade -y
sudo reboot
```

---

## 2. Basis-Installer

```bash
cd noc/scripts
chmod +x install-noc-base.sh
./install-noc-base.sh
```

Das Skript:

- installiert Basispakete,
- installiert Docker,
- legt Arbeitsverzeichnisse an.

Es verändert **keine**:

- IP-Adressen
- VLANs
- Firewall-Regeln
- Switch-Konfigurationen

---

## 3. Docker-Dienste

```bash
cd noc/compose
docker compose up -d
```

Enthalten:

- Uptime Kuma
- NetAlertX

---

## 4. LibreNMS

LibreNMS sollte nach offizieller Docker-Dokumentation eingerichtet werden.

Projekt:

```text
https://github.com/librenms/docker
```

Empfohlen:

- SNMPv3
- Geräte einzeln hinzufügen
- Router, Switches, APs und Server erfassen

---

## 5. Netdata

Native Installation ist sinnvoll:

```bash
wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh
sudo sh /tmp/netdata-kickstart.sh
```

---

## 6. Uptime Kuma

Standard im Compose:

```text
TCP 3001
```

Sinnvolle Checks:

- Router
- Firewall
- Switch
- DNS
- Server
- Webseiten
- VPN
- SOC-Sensor
- zentraler Monitoring-Server

---

## 7. NetAlertX

Standard im Compose:

```text
TCP 20211
```

Hinweis:

ARP funktioniert nur im selben Layer-2-Netz.

Für weitere Netze:

- Nmap
- Router-/DHCP-Daten
- SNMP
- weitere Plugins

---

## 8. Zentraler Server

Der NOC sendet bzw. liefert Daten an:

```text
Prometheus
Loki
Grafana
```

Grafana läuft **nicht zwingend auf dem NOC-Pi**.

---

## Ports

| Dienst | Standard |
|---|---:|
| SSH | 22/TCP |
| Uptime Kuma | 3001/TCP |
| Netdata | 19999/TCP |
| NetAlertX | 20211/TCP |
| SNMP | 161/UDP |

---

## Updates

```bash
sudo apt update
sudo apt full-upgrade -y
```

Docker:

```bash
cd noc/compose
docker compose pull
docker compose up -d
```

---

## Troubleshooting

```bash
docker ps
ip -br addr
ip route
ping <gateway>
```

Logs:

```bash
docker compose logs --tail=100
```
