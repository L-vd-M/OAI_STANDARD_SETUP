---
name: oai-analyze-repos
description: "Skill for analyzing cloned OpenAirInterface repository structure and contents. Use when: analyzing oai repo, exploring openairinterface5g, understanding oai architecture, mapping oai directory structure, checking oai features, inspecting oai layers, understanding 5g ran stack, understanding 5g core network functions."
---

# OAI Repository Analysis Skill

This skill provides a structured methodology for analyzing any OAI repository at both high and detailed levels.

## Analysis Levels

### Quick Analysis (< 5 minutes)
1. Read `README.md`
2. Run `ls -la` at the repo root
3. Get git version: `GIT_DIR=<repo>/.git GIT_WORK_TREE=<repo> git describe --tags --always`

### Full Analysis (complete understanding)
Follow all phases below.

---

## Phase 1: Identity

```bash
# Get version and branch
GIT_DIR=<repo>/.git GIT_WORK_TREE=<repo> git describe --tags --always
GIT_DIR=<repo>/.git GIT_WORK_TREE=<repo> git log --format="%H %ai %s" -1
GIT_DIR=<repo>/.git GIT_WORK_TREE=<repo> git remote get-url origin
GIT_DIR=<repo>/.git GIT_WORK_TREE=<repo> git branch --show-current

# Check for submodules
cat <repo>/.gitmodules 2>/dev/null
```

## Phase 2: Architecture Mapping

### For `openairinterface5g` (RAN)

```
Key directories to examine:
├── openair1/       → PHY/ SCHED_NR/ SCHED/ SIMULATION/
├── openair2/       → LAYER2/ RRC/ F1AP/ E1AP/ E2AP/ X2AP/ GNB_APP/
├── openair3/       → S1AP/ NGAP/ NAS/ ocp-gtpu/ SECU/
├── radio/          → USRP/ rfsimulator/ fhi_72/ BLADERF/ LMSSDR/
├── executables/    → nr-softmodem.c lte-softmodem.c nr-uesoftmodem.c
├── nfapi/          → open-nFAPI/ oai_integration/
├── doc/            → FEATURE_SET.md SW_archi.md BUILD.md RUNMODEM.md
└── docker/         → Dockerfiles for all components
```

```bash
# Map each layer
ls openair1/ openair2/ openair3/ radio/ executables/ doc/
cat doc/FEATURE_SET.md | head -100
cat doc/SW_archi.md | head -50
```

### For CN5G NF repos (AMF, SMF, UPF, NRF, etc.)

```
Key directories:
├── src/            → Core NF implementation (C++)
├── include/        → Public headers
├── build/          → Generated build artifacts
├── scripts/        → helpers and deployment scripts
├── charts/         → Helm charts
└── docker/         → Dockerfiles
```

```bash
ls src/ include/ 2>/dev/null | head -30
cat README.md
```

## Phase 3: Feature Extraction

### For RAN — key questions to answer:
1. Which 3GPP releases are supported? (LTE Rel-10/12, NR Rel-15+)
2. Which frequency ranges? (FR1: sub-6 GHz, FR2: mmWave)
3. Which subcarrier spacings? (15/30/120 kHz)
4. What deployment modes? (SA, NSA, CU/DU, O-RAN)
5. Which radio frontends are supported?
6. Are Docker images available?

```bash
grep -r "FR1\|FR2\|subcarrier\|SCS" doc/FEATURE_SET.md | head -20
grep -r "Standalone\|Non-standalone\|NSA\|SA mode" doc/FEATURE_SET.md | head -10
ls docker/Dockerfile.* | sed 's/docker\/Dockerfile\.//' | sort
```

### For CN5G NF — key questions:
1. Which 3GPP TS interfaces are implemented?
2. What's the current version?
3. What Docker base image is used?
4. Does it support containerized deployment?

## Phase 4: Version Summary

Always produce:
```
Repository:  <name>
GitLab:      <url>
Version:     <git describe output>
Commit:      <first 12 chars of SHA> (<date>)
Branch:      <branch>
Cloned:      <date cloned>
```

## OAI Architecture Quick Reference

### RAN Functional Mapping
| Layer | Protocols | Directory |
|---|---|---|
| PHY (L1) | PUSCH/PDSCH/PUCCH/PRACH, LDPC, Polar | `openair1/PHY/` |
| MAC (L2) | NR MAC scheduler, HARQ, RACH | `openair2/LAYER2/NR_MAC_gNB/` |
| RLC (L2) | AM/UM/TM modes | `openair2/LAYER2/RLC/` |
| PDCP (L2) | Ciphering, ROHC, SN | `openair2/LAYER2/PDCP_v10.1.0/` |
| RRC (L2/L3) | Cell cfg, UE connection, handover | `openair2/RRC/` |
| NGAP (L3) | gNB-AMF N2 interface | `openair3/NGAP/` |
| GTP-U (L3) | User-plane tunnelling | `openair3/ocp-gtpu/` |
| F1AP | CU-DU split | `openair2/F1AP/` |
| E1AP | CU-CP / CU-UP split | `openair2/E1AP/` |
| E2AP | O-RAN RIC interface | `openair2/E2AP/` |

### CN5G NF Interfaces
| NF | Key 3GPP TS | SBI Port (default) |
|---|---|---|
| AMF | 38.413 (NGAP), 29.518 | 8080 |
| SMF | 29.502, 29.244 (PFCP) | 8080 |
| UPF | 29.244 (PFCP), GTP-U | — |
| NRF | 29.510 | 8000 |
| AUSF | 29.509 | 8080 |
| UDM | 29.503 | 8080 |
| UDR | 29.504 | 8080 |

## Shell Compatibility Note (Fish Shell)
When running git commands in fish shell, use Python3 for variable assignment in loops:
```python
import subprocess, os
env = dict(os.environ, GIT_DIR='/path/to/repo/.git', GIT_WORK_TREE='/path/to/repo')
result = subprocess.check_output(['git', 'describe', '--tags', '--always'], env=env, text=True)
```
