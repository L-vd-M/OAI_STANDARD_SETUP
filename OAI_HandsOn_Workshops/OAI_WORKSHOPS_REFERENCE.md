# OAI Hands-On Workshops — Repository Reference Document

**Project:** OpenAirInterface Training Material  
**Organisation:** OpenAirInterface Software Alliance / Eurecom  
**License:** OAI Public License V1.1  
**Document generated:** 2026-03-24  

---

## Overview

This repository contains all hands-on workshop training material for OpenAirInterface (OAI) 5G NR. It covers three tracks:  
1. **Core Network (CN)** — deploying and testing OAI 5G core network functions via Docker  
2. **RAN** — building and running OAI gNB and NR-UE from source with RFsimulator  
3. **OAM** — integrating the O-RAN E2 agent with FlexRIC nearRT-RIC and xApps  

---

## Repository Summary

| Repository | GitLab URL | Branch | Tag / Version |
|---|---|---|---|
| `oai-workshops` | [gitlab.eurecom.fr/oai/trainings/oai-workshops](https://gitlab.eurecom.fr/oai/trainings/oai-workshops) | `main` | `2025-fall` |

### Clone Command

```bash
git clone https://gitlab.eurecom.fr/oai/trainings/oai-workshops.git
```

### Local Path

```
OAI_HandsOn_Workshops/oai-workshops/
```

---

## Directory Structure

```
oai-workshops/
├── README.md          Top-level prerequisites and tutorial navigation
├── LICENSE            OAI Public License V1.1
├── cn/                Core Network hands-on tutorial
│   ├── README.md      Step-by-step CN5G deployment guide
│   ├── conf/          config.yaml — PLMN, slices, DNN settings
│   ├── resources/     Diagrams and screenshots
│   └── docker-compose.yml
├── ran/               RAN hands-on tutorial
│   ├── README.md      Step-by-step RAN build & run guide
│   ├── conf/          gNB/UE config files (monolithic, CU-DU, CU-CP/UP, HO, nFAPI)
│   ├── resources/     Architecture diagrams and Wireshark screenshots
│   ├── multi-ue.sh    Script for multi-UE testing
│   └── ran.slidy      Pandoc slidy presentation template
└── oam/               OAM / O-RAN E2 + FlexRIC tutorial
    ├── README.md      FlexRIC nearRT-RIC build & xApp guide
    ├── conf/          gNB config files with E2 agent block
    └── resources/     Wireshark E2AP/KPM/RC screenshots
```

---

## Hardware & Software Prerequisites

### Hardware Requirements

| Requirement | CN / OAM | RAN |
|---|---|---|
| vCPU | ≥ 4 | ≥ 8 cores |
| RAM | ≥ 8 GB | ≥ 16 GB |
| Storage | ≥ 4 GB | ≥ 20 GB (Ubuntu pre-installed) |
| AVX2 CPU support | Required | Required (`lscpu \| grep avx2`) |
| OS | Ubuntu 22.04/24.04, RHEL 9/10, Fedora 40+ | Ubuntu 24.04 (recommended) |
| macOS / WSL | Not tested | Not supported |

### Software Prerequisites

| Software | Minimum Version |
|---|---|
| Docker engine | 25.04 |
| tshark | 4.6.0 |
| wireshark | 4.6.0 |
| GCC (OAM only) | gcc-12 (FlexRIC requirement) |
| CMake (OAM only) | 3.15+ |

---

## Track 1 — Core Network Workshop (`cn/`)

> Author: OAI CN5G team (November 2025)

### Objectives

1. Deploy and configure OAI 5G Core Network Functions using Docker Compose  
2. Run an end-to-end 5G SA setup with RF-simulated gNB + NR-UE  
3. Capture and analyse SBI, PFCP, SCTP/NGAP signalling with Wireshark/tshark  
4. Perform data plane traffic tests (ping, iperf3)  

### Core Network Functions Deployed

| NF | Container Image | IP Address |
|---|---|---|
| NRF | `ghcr.io/openairinterface/oai-nrf:develop` | 192.168.70.130 |
| MySQL | `ghcr.io/openairinterface/mysql:8.0` | 192.168.70.131 |
| AMF | `ghcr.io/openairinterface/oai-amf:develop` | 192.168.70.132 |
| SMF | `ghcr.io/openairinterface/oai-smf:develop` | 192.168.70.133 |
| UPF | `ghcr.io/openairinterface/oai-upf:develop` | 192.168.70.134 |
| oai-ext-dn | `ghcr.io/openairinterface/trf-gen-cn5g:latest` | 192.168.70.135 |
| UDR | `ghcr.io/openairinterface/oai-udr:develop` | 192.168.70.136 |
| UDM | `ghcr.io/openairinterface/oai-udm:develop` | 192.168.70.137 |
| AUSF | `ghcr.io/openairinterface/oai-ausf:develop` | 192.168.70.138 |
| IMS | `ghcr.io/openairinterface/ims:latest` | 192.168.70.139 |

### RAN Images (CN workshop)

```bash
docker pull ghcr.io/openairinterface/oai-nr-ue:2025.w45
docker pull ghcr.io/openairinterface/oai-gnb:2025.w45
```

### Key Steps

```bash
# 1. Setup and pull images
git clone https://gitlab.eurecom.fr/oai/trainings/oai-workshops.git
cd oai-workshops/cn && mkdir results && chmod 777 results
docker compose pull

# 2. Start capture (Wireshark interface: oaiworkshop)
# Filter: sctp || icmp || tcp.port == 8080 || udp.port == 8080 || tcp.port == 8805 || udp.port == 8805 || tcp.port == 3306

# 3. Deploy core network
docker compose -f docker-compose.yml up -d
watch docker compose -f docker-compose.yml ps -a

# 4. Deploy gNB + UE (docker, rfsim mode)
docker compose -f docker-compose.yml up -d oai-gnb oai-nr-ue

# 5. Traffic test
ping -I oaitun_ue1 192.168.70.135                           # UL ping
docker exec -it oai-ext-dn ping <UE_IP>                    # DL ping
iperf3 -B <UE_IP> -c 192.168.70.135 -u -b 50M -R          # DL iperf3
iperf3 -B <UE_IP> -c 192.168.70.135 -u -b 20M             # UL iperf3
```

### 3GPP Interfaces Covered

| Interface | Protocol | Between |
|---|---|---|
| N2 | NGAP / SCTP | AMF ↔ gNB |
| N4 | PFCP / UDP | SMF ↔ UPF |
| N8 | HTTP/2 SBI | AMF ↔ UDM |
| N11 | HTTP/2 SBI | AMF ↔ SMF |
| N27 | HTTP/2 SBI | All NFs ↔ NRF |
| N3 | GTP-U / UDP | gNB ↔ UPF |
| N6 | IP | UPF ↔ data network |

---

## Track 2 — RAN Workshop (`ran/`)

> Author: Robert Schmidt, Jaroslava Fiedlerova (November 18, 2025)

### Objectives

1. Understand the OAI RAN code repository structure  
2. Build gNB + NR-UE from source (tag `2025.w46`) with RFsimulator  
3. Run monolithic gNB → CU-DU F1 split → CU-DU/E1 split → nFAPI+F1+E1  
4. Test F1 Handover, connect multiple UEs  
5. Use scope visualizers and configure basic channel modelling  
6. Explore NTN (Non-Terrestrial Network) simulation  

### RAN Repository Used

| Repository | URL | Tag |
|---|---|---|
| openairinterface5g | `https://gitlab.eurecom.fr/oai/openairinterface5g.git` | `2025.w46` |

### Build Steps

```bash
# Clone & install dependencies
cd ~
git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git
cd openairinterface5g && git checkout 2025.w46
cd cmake_targets && ./build_oai --ninja -I

# Compile gNB + nrUE with RFsimulator
./build_oai --ninja --gNB --nrUE -w SIMU -c
```

### Repository Structure (openairinterface5g)

| Directory | Purpose |
|---|---|
| `openair1/` | Layer 1 — LTE Rel-10/12 PHY, NR Rel-15+ PHY |
| `openair2/` | Layer 2 — MAC/RLC/PDCP/SDAP/RRC/X2AP/F1AP/E1AP/E2AP |
| `openair3/` | Layer 3 — NGAP, S1AP, GTP-U |
| `radio/` | SDR frontends — USRP, RFsimulator, FHI 7.2, BladeRF |
| `executables/` | Main entry points: `nr-softmodem`, `nr-uesoftmodem`, `nr-cuup` |
| `nfapi/` | nFAPI split support |
| `cmake_targets/` | Build scripts (`build_oai`), build artifacts |
| `doc/` | BUILD.md, RUNMODEM.md, FEATURE_SET.md, SW_archi.md |
| `docker/` | Dockerfiles for containerised builds |
| `charts/` | Helm charts for Kubernetes/OpenShift |
| `ci-scripts/` | CI/CD test scripts and example configs |

### Deployment Scenarios Covered

| Scenario | Config Files |
|---|---|
| Monolithic gNB | `gnb.sa.band78.106prb.rfsim.conf` |
| CU + DU (F1) | `gnb-cu.sa.f1.conf` + `gnb-du.sa.band78.106prb.rfsim.conf` |
| CU-CP + CU-UP + DU (E1+F1) | `gnb-cucp.sa.f1.rfsim.conf` + `gnb-cuup.sa.f1.rfsim.conf` + DU conf |
| nFAPI + F1 + E1 | `gnb-vnf.sa.band66.u0.25prb.nfapi.conf` + `gnb-pnf.band66.rfsim.conf` |
| F1 Handover | Two DU confs (`pci0` + `pci1`) |
| UE | `ue.conf` |

### RFsimulator Quick Start

```bash
# Start CN first (from cn/ directory)
cd ~/oai-workshops/cn && docker compose up -d

# Monolithic gNB (Band 78, 106 PRB, NR SA)
cd ~/openairinterface5g/cmake_targets/ran_build/build
./nr-softmodem -O ~/oai-workshops/ran/conf/gnb.sa.band78.106prb.rfsim.conf \
  --rfsim --log_config.global_log_options utc_time

# NR-UE
sudo ./nr-uesoftmodem -C 3619200000 -r 106 --numerology 1 --ssb 516 \
  -O ~/oai-workshops/ran/conf/ue.conf --rfsim \
  --log_config.global_log_options utc_time
```

### Supported Standards

| Standard | Details |
|---|---|
| 3GPP NR Rel-15+ | SA mode, FR1 (Band 78, Band 66) |
| Subcarrier spacings | 15 kHz, 30 kHz |
| Channel bandwidths | Up to 106 PRB (20 MHz at 30 kHz SCS) |
| O-RAN FH 7.2 | via `fhi_72` radio frontend |
| O-RAN E2AP | v1.01, v2.03, v3.01 (with `--build-e2`) |
| nFAPI | PNF/VNF split |
| NTN | GEO delay simulation (~238.74 ms one-way) |

---

## Track 3 — OAM / O-RAN Workshop (`oam/`)

> FlexRIC + E2 Agent integration (tag `2024.w26` + FlexRIC `beabdd07`)

### Objectives

1. Build OAI RAN with integrated E2 Agent  
2. Build and deploy FlexRIC nearRT-RIC  
3. Run xApps for KPM monitoring, RC state reporting, and RAN control  
4. Capture and analyse E2AP signalling in Wireshark  

### O-RAN Specification Support

| Specification | Version(s) Supported |
|---|---|
| E2AP | v1.01, v2.03 (default), v3.01 |
| E2SM-KPM | v2.03 (default), v3.00 |
| E2SM-RC | v1.03 |
| Custom SMs | MAC, RLC, PDCP, GTP (plain encoding) |

### Supported KPM Measurements (3GPP TS 28.552)

- `DRB.PdcpSduVolumeDL` / `DRB.PdcpSduVolumeUL`
- `DRB.RlcSduDelayDl`
- `DRB.UEThpDl` / `DRB.UEThpUl`
- `RRU.PrbTotDl` / `RRU.PrbTotUl`

### Build Steps

```bash
# 1. Install prerequisites
sudo apt install -y gcc-12 g++-12 && sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 100
sudo apt install -y libsctp-dev cmake-curses-gui libpcre2-dev

# 2. Build OAI with E2 Agent
cd ~/openairinterface5g/cmake_targets
./build_oai -I && ./build_oai -c --gNB --nrUE --build-e2 --ninja

# 3. Clone and build FlexRIC
git clone https://gitlab.eurecom.fr/mosaic5g/flexric flexric
cd flexric && git checkout beabdd072ca9e381d4d27c9fbc6bb19382817489
mkdir build && cd build && cmake .. && make -j8 && sudo make install
```

### E2 Agent Configuration Block (add to gNB config)

```
e2_agent = {
  near_ric_ip_addr = "127.0.0.1";
  sm_dir = "/usr/local/lib/flexric/"
}
```

### Run Order (OAM stack)

```bash
# 1. Start CN (from cn/ directory)
docker compose up -d

# 2. Start nearRT-RIC
cd flexric && ./build/examples/ric/nearRT-RIC

# 3. Start gNB with E2 agent (monolithic example)
sudo ./nr-softmodem -O ~/oai-workshops/oam/conf/gnb.sa.band78.fr1.106PRB.usrpb210.conf --rfsim --sa -E

# 4. Start xApps (KPM monitor example)
./build/examples/xApp/c/monitor/xapp_kpm_moni
```

---

## Related Repositories

| Repository | URL | Purpose |
|---|---|---|
| openairinterface5g | `https://gitlab.eurecom.fr/oai/openairinterface5g.git` | OAI 5G RAN |
| oai-cn5g-fed | `https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-fed.git` | CN5G deployment federation |
| FlexRIC | `https://gitlab.eurecom.fr/mosaic5g/flexric.git` | nearRT-RIC + xApps |

---

## References

- [OAI Website](http://www.openairinterface.org/)
- [OAI GitLab](https://gitlab.eurecom.fr/oai/)
- [RAN Build Guide](https://gitlab.eurecom.fr/oai/openairinterface5g/-/blob/develop/doc/BUILD.md)
- [RAN Feature Set](https://gitlab.eurecom.fr/oai/openairinterface5g/-/blob/develop/doc/FEATURE_SET.md)
- [O-RAN Specifications](https://orandownloadsweb.azurewebsites.net/specifications)
- [OAI Contributor License Agreement](https://openairinterface.org/legal/oai-license-model/)

---

*Document generated: 2026-03-24 | Tool: GitHub Copilot*
