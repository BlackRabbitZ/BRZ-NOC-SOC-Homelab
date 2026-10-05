# Hardware & Raspberry-Pi-Rollen

## Warum zwei getrennte Geräte?

NOC und SOC haben unterschiedliche Lastprofile.

Das NOC fragt Systeme aktiv ab.

Das SOC verarbeitet passiv kopierten Netzwerkverkehr und kann dadurch deutlich mehr CPU-/I/O-Last erzeugen.

---

## Raspberry Pi 4 – NOC

Empfohlen:

```text
Raspberry Pi 4
4 GB RAM
1× Ethernet
SSD empfohlen
```

Typische Dienste:

- Uptime Kuma
- LibreNMS
- Netdata
- NetAlertX

Warum reicht das?

Diese Dienste arbeiten hauptsächlich mit:

- SNMP
- HTTP
- ICMP
- APIs
- periodischen Scans

Es findet normalerweise keine permanente Paketinspektion des gesamten Netzwerkverkehrs statt.

---

## Raspberry Pi 5 – SOC

Empfohlen:

```text
Raspberry Pi 5
4 GB oder mehr
SSD/NVMe
aktive Kühlung
mindestens 2 Netzwerkports
```

Typische Dienste:

- Suricata
- ntopng
- EveBox
- CrowdSec
- OpenCanary

### Warum Pi 5?

Suricata und ntopng können kontinuierlich sehr viele Pakete verarbeiten.

Der Pi 5 bietet:

- mehr CPU-Leistung
- bessere I/O-Leistung
- bessere SSD/NVMe-Möglichkeiten
- mehr Reserven für parallele Analyse

---

## Warum ein Multi-Port-Netzwerkadapter?

Ein passiver Sensor sollte Management und Packet Capture trennen.

Empfohlen:

```text
NIC 1 → Management
NIC 2 → Mirror/SPAN
NIC 3+ → Reserve
```

### Management-Port

Hat eine normale IP-Adresse und dient für:

- SSH
- Updates
- Web-UIs
- Grafana/Prometheus/Loki-Anbindung

### Sensor-Port

Soll möglichst keine normale IP-Adresse besitzen.

Er empfängt:

- kopierten Switch-Traffic
- Mirror/SPAN-Frames

Darauf hören:

- Suricata
- ntopng

## Adapter

Das Projekt setzt **kein bestimmtes Modell** voraus.

Anforderungen:

- Linux-/ARM64-Unterstützung
- stabiler Treiber
- ausreichend Durchsatz
- zuverlässige Link-Erkennung
- mindestens ein zusätzlicher Ethernet-Port

Ein Adapter mit mehreren Ports ist praktisch, weil Reserve für spätere Sensoren oder getrennte Capture-Quellen bleibt.
