# Warum diese Tools?

Dieses Projekt verfolgt bewusst ein einfaches Ziel:

> Möglichst viel Monitoring und Security mit frei verfügbaren, lokal betreibbaren und nachvollziehbaren Werkzeugen umsetzen.

## Auswahlkriterien

Ein Tool wird bevorzugt, wenn es:

- kostenlos oder in der benötigten Grundfunktion kostenlos ist,
- Open Source ist oder eine frei nutzbare Community-Variante bietet,
- lokal betrieben werden kann,
- keine zwingende Cloud-Verbindung benötigt,
- ARM64/Linux unterstützt,
- aktiv gepflegt wird,
- dokumentiert ist,
- sich in bestehende Monitoring-Stacks integrieren lässt.

## NOC

### Uptime Kuma
Für einfache Verfügbarkeitsprüfungen.

Geeignet für:

- Ping
- HTTP/S
- TCP
- DNS
- Zertifikatsablauf
- Service-Verfügbarkeit

### LibreNMS
Für Netzwerkgeräte.

Geeignet für:

- SNMP
- Router
- Switches
- Access Points
- Interfaces
- Traffic
- Fehlerzähler
- Temperatur/CPU, sofern per SNMP verfügbar

### Netdata
Für lokale Echtzeit-Systemmetriken.

Geeignet für:

- CPU
- RAM
- Load
- Storage
- Netzwerk
- Temperatur
- Prozesse

### NetAlertX
Für Geräteerkennung.

Geeignet für:

- neue Geräte
- bekannte/unbekannte MAC-Adressen
- Online/Offline
- IP-/MAC-Änderungen
- Subnetz-Scans

### ntopng
Für Netzwerkverkehr.

Geeignet für:

- Top-Talker
- Protokolle
- Flows
- Hosts
- Bandbreite

Im Projekt läuft ntopng physisch auf dem SOC-Sensor, weil dort der Mirror-/SPAN-Traffic anliegt.

## SOC

### Suricata
Open-Source IDS/IPS.

Geeignet für:

- Signaturen
- Scans
- verdächtige DNS-/TLS-Muster
- bekannte Exploit-Muster
- Netzwerk-Metadaten
- Security Events über `eve.json`

### EveBox
Visualisiert Suricata-Ereignisse und erleichtert die Untersuchung.

### CrowdSec
Logbasierte Angriffserkennung.

Geeignet für:

- Brute Force
- Scanner
- Bots
- Web-Angriffe
- auffällige Login-Muster

### OpenCanary
Leichtgewichtiger Honeypot.

Kann Köderdienste bereitstellen, z. B.:

- SSH
- HTTP
- FTP
- SMB

## Zentral

### Prometheus
Metrik-Speicher.

```text
CPU
RAM
Traffic
Drops
Latenz
Uptime
```

### Loki
Log-Speicher.

```text
Suricata Events
OpenCanary Logs
System Logs
Firewall Logs
```

### Grafana
Zentrale Oberfläche.

Grafana kann Prometheus und Loki als Datenquellen verwenden und NOC/SOC-Daten gemeinsam anzeigen.
