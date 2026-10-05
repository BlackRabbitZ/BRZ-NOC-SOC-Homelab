# VLAN / Network Segmentation Plan

This repository does not require VLANs.

The following layout is only an example:

| VLAN | Purpose | Example network |
|---:|---|---|
| 10 | Management | `10.10.10.0/24` |
| 20 | Clients | `10.10.20.0/24` |
| 30 | Servers | `10.10.30.0/24` |
| 40 | IoT | `10.10.40.0/24` |
| 50 | Cameras | `10.10.50.0/24` |
| 60 | Guests | `10.10.60.0/24` |
| 100 | Monitoring | `10.10.100.0/24` |
| 999 | Quarantine | `10.10.99.0/24` |

Use any VLAN IDs and subnets that match your environment.
