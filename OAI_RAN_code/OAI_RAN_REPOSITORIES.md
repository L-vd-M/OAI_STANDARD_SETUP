# OAI RAN — Repository Reference Document

**Project:** OpenAirInterface Radio Access Network (OAI RAN)  
**Organisation:** OpenAirInterface Software Alliance / Eurecom  
**License:** OAI Public License V1.1  
**Document generated:** 2026-03-23  

---

## Overview

OpenAirInterface (OAI) is an open-source software implementation of the **3GPP LTE and 5G NR Radio Access Network (RAN)** stack. Developed primarily by Eurecom and the OpenAirInterface Software Alliance, it provides a complete, standards-compliant RAN stack — from Physical Layer (PHY) upward through L2 and L3 — running on commodity x86/ARM Linux hardware with a variety of commercial and open-source software-defined radio (SDR) frontends.

The single monolithic repository `openairinterface5g` houses all RAN components for both **4G LTE** (Releases 10/12/14) and **5G NR** (Release 15 and beyond), including gNB (next-generation NodeB), eNB (LTE eNodeB), NR-UE and LTE-UE, CU/DU functional splits, O-RAN 7.2 Fronthaul Interface, and simulation environments.

---

## Repository Summary Table

| Repository | GitLab URL | Branch | Tag / Version | Latest Commit Hash |
|---|---|---|---|---|
| `openairinterface5g` | [gitlab.eurecom.fr/oai/openairinterface5g](https://gitlab.eurecom.fr/oai/openairinterface5g) | `develop` | `2026.w12` | `0ba31c0f89dd3162` |

> **Current Release:** Week 12, 2026 (`2026.w12`) — merged 2026-03-20  
> **Clone Date:** 2026-03-23  
> **Default Branch:** `develop`  
> **FlexRIC Submodule:** `openair2/E2AP/flexric` → `https://gitlab.eurecom.fr/mosaic5g/flexric.git`

---

## Clone Command

```bash
# Clone OAI RAN repository
git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git

# Recommended clone location
# /home/<user>/Documents/OAI/OAI_STANDARD_SETUP/OAI_RAN_code/openairinterface5g
```

---

## Repository Structure

```
openairinterface5g/
├── charts/              Helm charts for Kubernetes deployments (4G and 5G phy-sims)
├── ci-scripts/          CI/CD meta-scripts, Jenkins pipelines, configuration files
├── cmake_targets/       Top-level build system; build_oai script and CMake helpers
├── common/              Shared OAI utilities, type definitions, configuration framework
├── doc/                 Comprehensive documentation (features, build, tutorials, ORAN)
├── docker/              Dockerfiles for all components (Ubuntu, RHEL9, Rocky, ARM)
├── executables/         Top-level executable entry points (gNB, eNB, NR-UE, LTE-UE)
├── nfapi/               (n)FAPI MAC-PHY interface implementation (SCF FAPI + OAI extension)
├── openair1/            Layer 1: LTE PHY (Rel-10/12) and NR PHY (Rel-15+)
├── openair2/            Layer 2: MAC, RLC, PDCP, SDAP, RRC; F1AP, E1AP, X2AP, E2AP
├── openair3/            Layer 3: S1AP, NGAP, GTP, NAS, LPP, NRPPA
├── openshift/           OpenShift helm charts for cloud-native deployments
├── radio/               Radio frontend drivers (USRP, AW2S, RFsim, FHI 7.2, IRIS, etc.)
├── targets/             Historical configuration files (legacy, may be removed)
├── tests/               Unit/integration test code (NR-CU, NR-CUUP, NR-PPA)
└── tools/               Developer tools: formatting, IWYU analysis, package scripts
```

---

## Detailed Component Descriptions

### `openair1/` — Layer 1 (Physical Layer)

**Purpose:** Full 3GPP PHY implementation for both 4G LTE and 5G NR.

| Sub-directory | Contents |
|---|---|
| `PHY/` | Core PHY functions: channel estimation, PDSCH/PUSCH encoding/decoding, LDPC, polar codes, DMRS, CSIRS, beamforming, massive MIMO |
| `SCHED/` | LTE uplink/downlink scheduler at PHY layer |
| `SCHED_NR/` | NR gNB PHY scheduler (slot-level, PDCCH, UCI, PUCCH, PRACH) |
| `SCHED_NR_UE/` | NR UE PHY scheduler |
| `SCHED_UE/` | LTE UE PHY scheduler |
| `SIMULATION/` | PHY simulation framework for link-level and system-level testing |

**Key Features (5G NR PHY):**
- Subcarrier spacings: 15/30 kHz (FR1), 120 kHz (FR2)
- Bandwidths: 5–100 MHz (FR1), 100/200 MHz (FR2)
- NR-PDSCH/PUSCH with LDPC (BG1/BG2), NR-PDCCH with polar codes
- NR-PBCH, PSS/SSS, CSIRS, DMRS, PTRS
- Up to 4-layer DL SU-MIMO, 2-layer UL SU-MIMO
- UL transform precoding (SC-FDMA)
- 256-QAM support

---

### `openair2/` — Layer 2

**Purpose:** Full L2 protocol stack for LTE and NR, plus control-plane interfaces.

| Sub-directory | Contents |
|---|---|
| `LAYER2/` | MAC, RLC (AM/UM/TM), PDCP, SDAP implementations for both LTE and NR |
| `RRC/` | Radio Resource Control — cell configuration, UE connection management (LTE and NR) |
| `GNB_APP/` | gNB application layer, task management, configuration parsing |
| `ENB_APP/` | eNB application layer |
| `F1AP/` | F1 Application Protocol — CU/DU split interface (3GPP TS 38.473) |
| `E1AP/` | E1 Application Protocol — CU-CP/CU-UP split interface (3GPP TS 38.463) |
| `X2AP/` | X2 Application Protocol — eNB-to-eNB interface (LTE handover/NSA) |
| `XNAP/` | Xn Application Protocol — gNB-to-gNB interface (NR handover) |
| `M2AP/` | M2 Application Protocol — MCE-eNB interface (eMBMS) |
| `MCE_APP/` | Multi-Cell/Multicast Coordination Entity application |
| `E2AP/` | E2 Application Protocol — RAN Intelligent Controller (RIC) interface (O-RAN); includes **FlexRIC** submodule |
| `NR_PHY_INTERFACE/` | Interface between NR MAC and NR PHY |
| `PHY_INTERFACE/` | Interface between LTE MAC and LTE PHY |
| `NR_UE_PHY_INTERFACE/` | NR UE MAC-PHY interface |
| `SDAP/` | Service Data Adaptation Protocol (NR Rel-15) |
| `UTIL/` | Shared L2 utilities |
| `COMMON/` | Common L2 data structures |

---

### `openair3/` — Layer 3

**Purpose:** Core-facing interfaces, NAS, and transport protocols.

| Sub-directory | Contents |
|---|---|
| `S1AP/` | S1 Application Protocol — eNB to EPC interface (LTE, 3GPP TS 36.413) |
| `NGAP/` | NG Application Protocol — gNB to 5GC AMF interface (3GPP TS 38.413) |
| `NAS/` | Non-Access Stratum — LTE EPS mobility/session management |
| `SECU/` | Security functions (ciphering, integrity protection) |
| `ocp-gtpu/` | GTP-U user plane tunnelling protocol |
| `SCTP/` | SCTP transport layer wrapper |
| `LPP/` | LTE Positioning Protocol |
| `NRPPA/` | NR Positioning Protocol A (3GPP TS 38.455) |
| `M3AP/` | M3 Application Protocol (eMBMS MCE-MME) |
| `MME_APP/` | Minimal integrated MME application (legacy/testing) |
| `UICC/` | UICC/SIM interface abstraction |
| `UTILS/` | L3 utilities |

---

### `radio/` — Radio Frontend Drivers

**Purpose:** Hardware abstraction layer for all supported radio frontends.

| Sub-directory | Radio Hardware | Notes |
|---|---|---|
| `USRP/` | Ettus Research USRP (B2xx, X3xx, N3xx, X4xx) | Via UHD library |
| `AW2SORI/` | AW2S ORI-compliant frontends | Option 7.2 capable |
| `fhi_72/` | O-RAN 7.2 Fronthaul Interface | ORAN FHI library integration (mplane + C-plane) |
| `rfsimulator/` | Software RF simulator | Zero-hardware testing; channel model injection |
| `BLADERF/` | Nuand bladeRF SDR | |
| `LMSSDR/` | LimeMicrosystems LIME SDR | |
| `IRIS/` | Skylark IRIS SDR | |
| `vrtsim/` | Virtual RAN simulation | |
| `ETHERNET/` | Ethernet-based fronthaul (ECPRI, Option 6/7.x) | |
| `emulator/` | Generic radio emulation layer | |
| `iqplayer/` | IQ sample record and playback | |
| `COMMON/` | Shared radio driver utilities | |

---

### `executables/` — Top-Level Executables

**Purpose:** `main()` entry points and top-level orchestration for all OAI processes.

| File | Executable | Description |
|---|---|---|
| `nr-softmodem.c` | `nr-softmodem` | Main gNB (SA, NSA, CU/DU split) |
| `nr-uesoftmodem.c` | `nr-uesoftmodem` | NR UE softmodem |
| `lte-softmodem.c` | `lte-softmodem` | LTE eNB softmodem |
| `lte-uesoftmodem.c` | `lte-uesoftmodem` | LTE UE softmodem |
| `nr-cuup.c` | `nr-cuup` | Standalone NR CU-UP process |
| `nr-gnb.c` | `nr-gnb` | NR gNB entry (alternative) |
| `nr-ru.c` | `nr-ru` | NR Remote Unit (fronthaul) |
| `main_nr_ru.c` | NR O-RU | O-RAN O-RU main loop |
| `lte-ru.c` | LTE RU | LTE Remote Unit |

---

### `nfapi/` — (n)FAPI Interface

**Purpose:** SCF FAPI and nFAPI (network FAPI) implementation for MAC-PHY split across network.

- Based on the **Small Cell Forum FAPI** specification
- Enables distributed MAC/PHY across UDP/IP
- Used in L2 NFAPI simulation (`L2NFAPI`) for multi-UE testing with proxy

---

### `cmake_targets/` — Build System

**Purpose:** Build automation for all targets.

- `build_oai` — Main build script; wraps CMake with convenient presets
- `CPM.cmake` — CMake Package Manager integration
- `cross-arm.cmake` — Cross-compilation toolchain for ARM64  
- `tools/` — Additional build utilities and generated output directory

**Build Examples:**
```bash
# Build gNB
./cmake_targets/build_oai -w USRP --gNB

# Build NR-UE
./cmake_targets/build_oai -w USRP --nrUE

# Build all with RFsimulator (no hardware required)
./cmake_targets/build_oai -w SIMU --gNB --nrUE
```

---

### `common/` — Shared Utilities

**Purpose:** Cross-cutting utilities and type definitions used throughout the stack.

- `config/` — OAI configuration file framework (libconfig / YAML parsing)
- `utils/` — Logging, threading, memory management, time utilities
- Platform type definitions, 5G platform types, RAN context

---

### `doc/` — Documentation

**Purpose:** Comprehensive technical documentation.

Key documents:

| Document | Topic |
|---|---|
| `BUILD.md` | Build system usage and prerequisites |
| `RUNMODEM.md` | How to run gNB, eNB, and UE softmodems |
| `FEATURE_SET.md` | Complete feature set (LTE + NR) |
| `SW_archi.md` | Software architecture overview |
| `NR_SA_Tutorial_OAI_CN5G.md` | End-to-end NR SA with OAI 5GC |
| `NR_SA_Tutorial_OAI_nrUE.md` | NR SA with OAI NR-UE |
| `ORAN_FHI7.2_Tutorial.md` | O-RAN 7.2 Fronthaul setup |
| `F1AP/` | F1AP (CU/DU split) documentation |
| `E1AP/` | E1AP (CU-CP/CU-UP split) documentation |
| `system_requirements.md` | Hardware and OS requirements |
| `TESTBenches.md` | Test bench configurations |
| `handover-tutorial.md` | Handover procedures |

---

### `docker/` — Container Images

**Purpose:** Dockerfiles for building all OAI RAN components as containers.

Supported base OS:
- **Ubuntu 22.04 / 24.04** (`.ubuntu`)
- **RHEL 9** (`.rhel9`)
- **Rocky Linux** (`.rocky`)
- **ARM64 cross-compilation** (`.cross-arm64`)

Container images built:
- `oaisoftwarealliance/oai-gnb` — gNB
- `oaisoftwarealliance/oai-nr-ue` — NR UE
- `oaisoftwarealliance/oai-enb` — eNB
- `oaisoftwarealliance/oai-lte-ue` — LTE UE
- `oaisoftwarealliance/oai-nr-cuup` — NR CU-UP
- gNB variants: standard, FHI7.2, AW2S ORI, Aerial GPU, NVIDIA Aerial

---

### `ci-scripts/` — CI/CD

**Purpose:** Continuous Integration scripts and configuration for the OAI CI pipeline.

- Jenkins pipeline definitions (`Jenkinsfile`, `Jenkinsfile-colosseum`, `Jenkinsfile-GitLab-Container`)
- Python classes for test orchestration, container management, log analysis
- Configuration files for CI environments and test scenarios
- XML/YAML test definitions and result templates
- Colosseum (wireless network emulator) integration scripts

---

### `charts/` — Helm Charts

**Purpose:** Kubernetes Helm charts for cloud-native deployment.

- `physims-4g/` — LTE physical layer simulation chart
- `physims-5g/` — NR physical layer simulation chart

---

### `tools/` — Developer Tools

**Purpose:** Code quality and developer experience tools.

- `formatting/` — clang-format configuration and enforcement scripts
- `iwyu/` — Include-What-You-Use analysis
- `packages/` — Package dependency helpers
- `docker-dev-env/` — Docker-based development environment
- `plots/` — Performance plotting scripts
- `scripts/` — Miscellaneous developer scripts

---

### `tests/` — Tests

**Purpose:** Integration and unit test code.

- `nr-cu-nrppa/` — NR CU with NR Positioning Protocol A tests
- `nr-cuup/` — NR CU-UP unit tests

---

## Deployment Modes

OAI RAN supports the following deployment architectures:

| Mode | Description | Key Interfaces |
|---|---|---|
| **Monolithic gNB** | Full gNB in a single process | NGAP (to AMF), GTP-U (to UPF) |
| **CU/DU Split** | gNB split into CU and DU processes | F1-C (F1AP), F1-U (GTP-U) |
| **CU-CP / CU-UP Split** | CU further split into CP and UP | E1AP |
| **LTE eNB (NSA)** | 4G eNB acting as secondary node | X2AP (to gNB), S1AP (to EPC) |
| **O-RAN 7.2** | gNB DU + O-RU via FHI 7.2 fronthaul | eCPRI / O-RAN FHI |
| **L2 NFAPI** | Distributed MAC/PHY via nFAPI | UDP/IP (nFAPI proxy) |
| **phy-test / noS1** | Standalone testing without core | None (loopback / file-based) |

---

## Hardware Support

| SDR / Radio | Driver | Notes |
|---|---|---|
| Ettus USRP B2xx/X3xx/N3xx/X4xx | `radio/USRP/` | Primary reference hardware |
| AW2S ORI frontends | `radio/AW2SORI/` | O-RAN compliant, high-band 5G |
| O-RAN 7.2 O-RU (generic) | `radio/fhi_72/` | Via OAI FHI library |
| Skylark IRIS | `radio/IRIS/` | |
| Nuand bladeRF | `radio/BLADERF/` | |
| LimeMicrosystems LimeSDR | `radio/LMSSDR/` | |
| RF Simulator (no HW) | `radio/rfsimulator/` | Software loopback for testing |
| IQ Player | `radio/iqplayer/` | Pre-recorded IQ playback |

---

## Supported Standards

| Standard | Release | Status |
|---|---|---|
| 3GPP LTE | Release 10, 12, 14 | Production-ready |
| 3GPP NR (5G SA) | Release 15 | Production-ready |
| 3GPP NR (5G NSA) | Release 15 | Partial / unstable |
| O-RAN 7.2 Fronthaul | O-RAN WG4 | Supported |
| O-RAN E2 (RIC) | O-RAN WG3 | Via FlexRIC submodule |
| SCF FAPI / nFAPI | SCF 222.10.05 | Supported |
| 3GPP eMBMS | Release 14 | M2AP / MCE |

---

## Operating System Support

| OS | Architecture | Status |
|---|---|---|
| Ubuntu 22.04 LTS | x86_64, ARM64 | Fully supported |
| Ubuntu 24.04 LTS | x86_64, ARM64 | Fully supported |
| RHEL 9 | x86_64 | Fully supported |
| Fedora 41+ | x86_64 | Supported |
| Rocky Linux | x86_64 | Supported |

---

## Related Repositories

| Repository | Purpose | Link |
|---|---|---|
| `mosaic5g/flexric` | FlexRIC — O-RAN E2/RIC framework (submodule) | [gitlab.eurecom.fr/mosaic5g/flexric](https://gitlab.eurecom.fr/mosaic5g/flexric) |
| OAI CN5G suite | 5G Core Network functions (AMF, SMF, UPF, etc.) | [gitlab.eurecom.fr/oai/cn5g](https://gitlab.eurecom.fr/oai/cn5g) |
| OAI Docker images | Pre-built container images | [hub.docker.com/u/oaisoftwarealliance](https://hub.docker.com/u/oaisoftwarealliance) |

See also: [OAI_CN5G_REPOSITORIES.md](../cn5g/OAI_CN5G_REPOSITORIES.md) for the 5G Core Network documentation.

---

## Support and Community

- **Mailing list:** https://gitlab.eurecom.fr/oai/openairinterface5g/-/wikis/MailingList  
- **Issues tracker:** https://gitlab.eurecom.fr/oai/openairinterface5g/-/issues  
- **Wiki:** https://gitlab.eurecom.fr/oai/openairinterface5g/-/wikis  
- **OAI Website:** https://openairinterface.org/  

---

*Document auto-generated by GitHub Copilot on 2026-03-23. Repository cloned from `https://gitlab.eurecom.fr/oai/openairinterface5g.git`.*
