# Hardware & Raspberry Pi roles

## Raspberry Pi 4 – NOC

Recommended:

```text
Raspberry Pi 4
4 GB RAM
1× Ethernet
SSD recommended
```

The NOC mainly performs HTTP, SNMP, ping, API and periodic scan workloads.

It normally does not inspect every packet continuously, so a Pi 4 is a good fit.

## Raspberry Pi 5 – SOC

Recommended:

```text
Raspberry Pi 5
4 GB or more
SSD/NVMe
active cooling
at least 2 Ethernet ports
```

Suricata and ntopng can continuously process large amounts of mirrored traffic.

The Pi 5 provides more CPU and I/O headroom.

## Why a multi-port Ethernet adapter?

A passive sensor should separate management and packet capture:

```text
NIC 1 → Management
NIC 2 → Mirror/SPAN
NIC 3+ → Reserve
```

The repository does not require a specific adapter model.

Requirements:

- Linux/ARM64 support,
- stable driver,
- sufficient throughput,
- reliable link detection,
- at least one additional Ethernet port.
