# OAI Standard Setup — Engineer's Workspace Guide

**Author:** L-vd-M  
**Last Updated:** 2026-03-25  
**Audience:** Masters-degree researcher working on OpenAirInterface 5G

---

## What This Workspace Is

This workspace is a fully assembled 5G software lab. It brings together three large open-source projects — the OAI 5G Radio Access Network (RAN), the OAI 5G Core Network (5GC), and official OAI hands-on training tutorials — into one structured directory tree, with GitHub Copilot AI agents pre-configured to assist with code analysis, documentation, and development.

Every network function (NF) and RAN component is its own standalone C++ or Python project. The workspace does not impose any framework on top of them; it is simply a well-organised container that makes it easy to navigate, build, and modify any part of the 5G stack from a single VS Code window.

---

## Background: What is OpenAirInterface?

**OpenAirInterface (OAI)** is an open-source initiative founded in 2014 by EURECOM (Sophia Antipolis, France). It is governed by the OpenAirInterface Software Alliance (OSA), a French non-profit organisation supported by corporate sponsors including Ericsson, Nokia, and many others.

OAI's mission is to democratise wireless innovation by providing a complete, 3GPP-standards-compliant, open-source cellular software stack that runs on commodity off-the-shelf (COTS) hardware — standard x86 servers and widely available Software-Defined Radio (SDR) platforms. This makes it possible to build a fully functional 5G network in a lab without any proprietary hardware.

The platform is used by:
- **Academic research groups** worldwide studying novel scheduling algorithms, channel estimation, interference management, network slicing, and AI-driven network optimisation
- **Industrial R&D teams** at major vendors using it as a testbed for new 5G features before standardisation
- **Standardisation bodies** referencing OAI implementations as proof-of-concept for 3GPP and O-RAN specifications
- **Startups and integrators** building 5G private network products

The OSA publishes the code under the **OAI Public License V1.1** — a custom open-source licence derived from Apache 2.0 that allows free academic use, but requires commercial users to become OSA members and contribute back to the codebase.

### OAI within the 5G Ecosystem

OAI is one of the few implementations that covers the **complete end-to-end 5G stack** in a single open-source ecosystem:

| Layer | OAI Component | Alternative open-source |
|---|---|---|
| User Equipment (UE) | `nr-uesoftmodem` (software) or COTS UE | srsUE |
| gNB / base station | `openairinterface5g` | srsRAN |
| 5G Core Network | OAI CN5G (18 NF repos) | free5GC, Open5GS |
| nearRT-RIC | FlexRIC | O-RAN SC (OSC) Near-RT RIC |
| SDR hardware driver | UHD (USRP), RFsim, FHI 7.2 | — |

OAI's primary advantage over alternatives is the **depth of 3GPP compliance**: it targets actual Rel-15/16/17 procedures end-to-end, and can interoperate with COTS UEs (commercial smartphones) and COTS base station hardware.

### Relationship to 3GPP Standards

Every component in this workspace maps directly to a 3GPP Technical Specification (TS):

| Component | Primary 3GPP TS | What the spec defines |
|---|---|---|
| NR PHY | [TS 38.211](https://www.3gpp.org/DynaReport/38211.htm), [38.212](https://www.3gpp.org/DynaReport/38212.htm), [38.213](https://www.3gpp.org/DynaReport/38213.htm), [38.214](https://www.3gpp.org/DynaReport/38214.htm) | Physical channels, coding, scheduling |
| NR MAC | [TS 38.321](https://www.3gpp.org/DynaReport/38321.htm) | Medium access control |
| NR RLC | [TS 38.322](https://www.3gpp.org/DynaReport/38322.htm) | Radio link control |
| NR PDCP | [TS 38.323](https://www.3gpp.org/DynaReport/38323.htm) | Packet data convergence |
| NR SDAP | [TS 37.324](https://www.3gpp.org/DynaReport/37324.htm) | QoS flow-to-bearer mapping |
| NR RRC | [TS 38.331](https://www.3gpp.org/DynaReport/38331.htm) | Radio resource control |
| NGAP (N2) | [TS 38.413](https://www.3gpp.org/DynaReport/38413.htm) | gNB–AMF interface |
| F1AP | [TS 38.473](https://www.3gpp.org/DynaReport/38473.htm) | CU–DU split |
| E1AP | [TS 38.463](https://www.3gpp.org/DynaReport/38463.htm) | CU-CP / CU-UP split |
| E2AP | [O-RAN WG3](https://www.o-ran.org/specifications) | nearRT-RIC interface |
| NAS | [TS 24.501](https://www.3gpp.org/DynaReport/24501.htm) | UE–AMF signalling |
| 5GC SBA | [TS 23.501](https://www.3gpp.org/DynaReport/23501.htm), [23.502](https://www.3gpp.org/DynaReport/23502.htm) | Service-based architecture |
| AMF | [TS 23.501](https://www.3gpp.org/DynaReport/23501.htm) §6.2.1 | Access management |
| SMF | [TS 23.501](https://www.3gpp.org/DynaReport/23501.htm) §6.2.2 | Session management |
| UPF | [TS 23.501](https://www.3gpp.org/DynaReport/23501.htm) §6.2.3 | User plane forwarding |
| NRF | [TS 23.501](https://www.3gpp.org/DynaReport/23501.htm) §6.2.6 | NF registry and discovery |
| PFCP (N4) | [TS 29.244](https://www.3gpp.org/DynaReport/29244.htm) | SMF–UPF control-plane |
| GTPv1-U (N3) | [TS 29.281](https://www.3gpp.org/DynaReport/29281.htm) | User-plane tunnelling |

When you encounter code that is difficult to understand, looking up the corresponding 3GPP TS section is often the fastest way to understand the intent.

---

---

## The 5G System — What All the Code Does Together

The full end-to-end 5G system looks like this:

```
┌─────────────────────────────────────────────────────────────────────┐
│  User Equipment (UE)                                                │
│  Physical device or software simulation (nr-uesoftmodem)           │
└────────────┬────────────────────────┬───────────────────────────────┘
             │ Uu (radio — NR air interface)
             │
┌────────────▼─────────────────────────────────────────────────────────┐
│  gNB — 5G Base Station  (openairinterface5g / nr-softmodem)         │
│                                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐           │
│  │  L1/PHY  │  │  L2/MAC  │  │ L2/RLC   │  │ L2/PDCP  │           │
│  │openair1/ │  │NR_MAC_gNB│  │  nr_rlc/ │  │ nr_pdcp/ │           │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘           │
│                    ┌───────────┐  ┌──────────────┐                  │
│                    │  RRC      │  │  SDAP (QoS)  │                  │
│                    │openair2/  │  │  openair2/   │                  │
│                    └───────────┘  └──────────────┘                  │
│                                                                      │
│  F1─────────────── CU/DU split (F1AP) ─────────────────────────────│
│  E1─────────────── CU-CP/CU-UP split (E1AP) ───────────────────────│
│  E2─────────────── O-RAN nearRT-RIC interface (E2AP / FlexRIC) ────│
│                                                                      │
│      N2 (NGAP/SCTP)       N3 (GTPv1-U / user-plane data)           │
└────────────┬──────────────────────────┬──────────────────────────────┘
             │ N2                        │ N3
             │                           │
┌────────────▼──────────── 5G Core ──────▼──────────────────────────────┐
│                                                                        │
│  ┌─────────┐    ┌─────────┐    ┌────────────────────────────────┐    │
│  │  AMF    │────│  SMF    │────│       UPF (User Plane)         │    │
│  │ N1,N2,  │ N11│ N4,N7,  │ N4 │ GTPv1-U • PFCP • eBPF/VPP    │    │
│  │ N8,N11  │    │ N10,N11 │    └────────────────┬───────────────┘    │
│  └────┬────┘    └────┬────┘                     │ N6                  │
│       │N12           │N10                        ▼ Data Network        │
│  ┌────▼────┐    ┌────▼────┐    ┌─────────┐  ┌──────────────────┐    │
│  │  AUSF   │    │  UDM    │────│  UDR    │  │  NRF (Registry)  │    │
│  │  5G-AKA │    │  N8,N13 │N35 │ MySQL   │  │  N27, OAuth2     │    │
│  └─────────┘    └─────────┘    └─────────┘  └──────────────────┘    │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌──────────┐  │
│  │  PCF    │  │  NSSF   │  │  NEF    │  │  LMF    │  │  NWDAF   │  │
│  │ AM/SM   │  │ Slicing │  │ AF expo │  │ Location│  │Analytics │  │
│  │ policy  │  │  N22    │  │ N29,N33 │  │ NLs,LPP │  │Go+Python │  │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘  └──────────┘  │
└────────────────────────────────────────────────────────────────────────┘
```

### What each part actually does

| Component | What it does in plain language |
|---|---|
| **UE** | The device a user connects with. In software, `nr-uesoftmodem` simulates this. |
| **gNB (base station)** | Handles radio transmission to/from UEs; transports user data to the core via GTP tunnels; signals registration and session events to the AMF and SMF. |
| **AMF** | The front door of the core. Manages UE registration, authentication, mobility, and paging. All signalling from the gNB enters here first. |
| **AUSF + UDM** | Security duo. UDM holds subscriber profiles and generates authentication vectors. AUSF runs 5G-AKA or EAP-AKA' to authenticate the UE. |
| **UDR** | The database. Stores subscriber data, policy data, and exposure data in MySQL. All other NFs that need persistent data query UDR (usually via UDM or NRF). |
| **SMF** | Session manager. Creates and manages PDU sessions (the equivalent of IP connections). Configures the UPF with forwarding rules via PFCP. |
| **UPF** | Carries the actual user data packets between the gNB and the Internet (or data network). The only NF that touches user-plane traffic. |
| **NRF** | Service registry. Every NF registers here on startup and queries here to find other NFs. Also issues OAuth2 tokens for NF-to-NF security. |
| **PCF** | Policy engine. Tells the AMF what access-and-mobility restrictions apply per UE, and tells the SMF what QoS/charging rules apply per PDU session. |
| **NSSF** | Slice selector. Decides which S-NSSAI (network slice) a UE should use during registration, enabling network slicing. |
| **NEF** | External exposure. Allows third-party Application Functions to interact with the 5G core over a standardised northbound API. |
| **LMF** | Location service. Calculates UE position using LPP (LTE Positioning Protocol) and NRPPA (NR Positioning Protocol A) messages with the gNB. |
| **NWDAF** | Analytics. Collects data from other NFs, runs ML models, and provides analytics results (e.g. load prediction, anomaly detection) as a service. |
| **FlexRIC** | nearRT-RIC. Sits alongside the gNB and connects via E2AP. Allows xApps to read KPIs and send control messages to the RAN in near-real-time. |

---

## Workspace Directory Map

```
OAI_STANDARD_SETUP/
│
├── .github/                    AI assistant configuration (agents + skills)
│   ├── agents/                 All Copilot agent files (invoke with @Agent-Name)
│   └── skills/                 Reusable skill definitions (loaded by agents)
│
├── docs/                       Generated workspace documentation
│   ├── WORKSPACE_GUIDE.md      ← This file
│   ├── project-overview.md     Auto-generated project overview
│   └── code-map.md             Auto-generated source code map
│
├── OAI_RAN_code/               RAN workspace (git submodule)
│   ├── OAI_RAN_REPOSITORIES.md RAN reference document
│   ├── .github/                10 RAN protocol-layer AI agents
│   └── openairinterface5g/     OAI gNB + NR-UE + FlexRIC source (C/C++)
│
├── OAI_CN_code/                CN5G workspace (git submodule)
│   ├── OAI_CN5G_REPOSITORIES.md  CN5G reference document
│   ├── OAI_CN5G_CLONE_LINKS.md   Git clone commands for all 18 NF repos
│   ├── .github/                  19 CN5G AI agents (one per NF + shared infra)
│   ├── oai-cn5g-amf/
│   ├── oai-cn5g-ausf/
│   ├── oai-cn5g-smf/
│   ├── oai-cn5g-upf/
│   ├── oai-cn5g-nrf/
│   ├── oai-cn5g-udm/
│   ├── oai-cn5g-udr/
│   ├── oai-cn5g-nssf/
│   ├── oai-cn5g-pcf/
│   ├── oai-cn5g-lmf/
│   ├── oai-cn5g-nef/
│   ├── oai-cn5g-nwdaf/
│   ├── oai-cn5g-upf-vpp/
│   ├── oai-cn5g-upf-sdfabric/
│   ├── oai-cn5g-common-src/    Shared C++ libraries (used by all NFs)
│   ├── oai-cn5g-common-build/  Shared CMake + dependency install scripts
│   └── oai-cn5g-common-ci/     Shared CI/CD pipeline scripts
│
└── OAI_HandsOn_Workshops/      Workshop training material
    ├── OAI_WORKSHOPS_REFERENCE.md
    └── oai-workshops/
        ├── cn/                 5G Core Docker Compose tutorial
        ├── ran/                RAN build-from-source tutorial
        └── oam/                O-RAN / FlexRIC xApp tutorial
```

---

## What the OAI RAN Can Actually Do — Confirmed Feature Set

This section summarises the verified capabilities of the `openairinterface5g` codebase at version `2026.w12`. This is important for your research: it defines what is already implemented and what you would need to add yourself.

### 5G NR gNB Capabilities

#### PHY Layer
- **Frequency ranges:** FR1 (sub-6 GHz, 15 kHz and 30 kHz SCS) and FR2 (mmWave, 120 kHz SCS)
- **Bandwidths:** 5 – 100 MHz (FR1), 100 and 200 MHz (FR2)
- **MIMO:** 4-layer DL, 2-layer UL (SU-MIMO); up to 4 TX/RX antennas
- **Modulation:** up to 256-QAM on both DL and UL
- **Channel coding:** 3GPP-compliant LDPC encoder/decoder (BG1 and BG2), Polar codes for control
- **Reference signals:** DMRS (config type 1 and 2), PTRS, CSI-RS, SSB, SRS, PRS (positioning)
- **Duplexing:** Static TDD (configurable multi-pattern) and static FDD
- **Channels supported:** PDSCH, PUSCH, PDCCH (DCI formats 0-0, 1-0, 0-1, 1-1), PBCH, PUCCH (formats 0, 2), PRACH (formats 0/1/2/3, A1–A3, B1–B3), NR-PSS/SSS
- **NTN (Non-Terrestrial Networks):** Rel-17 NTN support: TA adjustment, Doppler compensation/pre-compensation, 32 HARQ processes

#### MAC Layer
- **Random Access:** 4-Step RA (contention-free and contention-based) and 2-Step RA
- **DL Scheduler:** Dynamic proportionally-fair allocation with MCS adaptation from HARQ BLER or SSB-SINR
- **UL Scheduler:** Dynamic proportionally-fair allocation with HARQ procedures and MCS adaptation from HARQ BLER or PUSCH SINR
- **HARQ:** Full UL and DL HARQ procedure support
- **Handover (intra-frequency and inter-frequency):** Measurement-gap-based inter-frequency handover; DUs must be synchronised
- **SRS:** Periodic SRS, channel rank computation (up to 2×2), TPMI computation (up to 4 antennas, 2 layers)
- **RedCap (Rel-17):** SIB1 v17 IEs, coexistence of RedCap and Normal UEs
- **Maximum UEs:** 16 by default; up to 64 with sufficient bandwidth (≥40 MHz)

#### Higher Layers
- **RLC:** AM (ARQ-based retransmission), UM, TM modes per TS 38.322 Rel.16
- **PDCP:** Integrity protection and ciphering per TS 38.323 Rel.16, sequence number management
- **SDAP:** QoS flow-to-DRB mapping, reflective QoS per TS 37.324 Rel.15
- **RRC:** TS 38.331 Rel-17 messages; connection setup/reconfiguration/reestablishment; bearer setup; CU/DU split support (F1); CU-CP/CU-UP split (E1); inter-gNB and inter-DU handover; A2/A3 measurement events
- **NGAP:** TS 38.413 Rel-15 — NG-Setup, Initial UE, Context Setup, PDU session setup, all handover procedures
- **F1AP:** TS 38.473 Rel-16 — Full UE context management; intra-CU inter-DU mobility; one CU-CP can manage multiple DUs
- **E1AP:** TS 38.463 Rel-16 — Bearer context setup/modification; one CU-CP can manage multiple CU-UPs
- **GTP-U:** TS 29.281 Rel-15 — N3 and F1-U interfaces; GTP-U optional headers; PDU Session Container

#### Deployment Modes
| Mode | Description |
|---|---|
| `phy-test` | Hardcoded RNTI; gNB schedules all resources even with no attached UE. Used for PHY-layer performance measurement |
| `noS1` | RRC connection setup, but no core network. TUN interface created for user-plane traffic injection |
| **Standalone (SA)** | Full 5G SA mode: UE registers with 5G Core, establishes PDU session, exchanges user-plane data |
| **Non-Standalone (NSA)** | gNB provides user-plane while UE is connected to an LTE eNB; experimental (unstable, one UE only) |
| **CU/DU split** | CU and DU run as separate processes, connected via F1AP |
| **CU-CP / CU-UP split** | Control-plane and user-plane of the CU separated via E1AP |
| **O-RAN FHI 7.2** | gNB CU/DU runs on server; separate O-RU hardware connected via eCPRI/FHI fronthaul |

---

### 5G NR UE Capabilities (`nr-uesoftmodem`)

- Full SA registration: 5GMM Registration → Authentication → Security Mode → PDU Session Establishment
- NAS messages per TS 24.501 Rel-16: Registration, Authentication, Security Mode, PDU Session, Deregistration
- UE PHY: all DL/UL channels (mirrors gNB PHY above); Initial sync (SSB), time/frequency tracking
- MAC: 4-Step and 2-Step RA, DCI processing (formats 0-0, 1-0, 0-1, 1-1), BSR, HARQ, BWP operation
- RLC/PDCP/SDAP per Rel-16
- RRC: connection setup/reestablishment/reconfiguration/release; UE capability report; A2/A3 measurement events
- NTN Rel-17: TA adjustment, Doppler compensation

---

### 5G Core Network — AMF Capability Matrix (example NF)

The AMF implements 3GPP TS 23.501 V16.14.0 §6.2.1:

| # | Feature | Status | Notes |
|---|---|---|---|
| 1 | Termination of N2 (NGAP) | ✔️ | |
| 2 | Termination of NAS (N1) | ✔️ | |
| 3 | NAS ciphering and integrity protection | ✔️ | |
| 4 | Registration management | ✔️ | |
| 5 | Connection management | ✔️ | |
| 6 | Reachability management | ❌ | |
| 7 | Mobility management (N2 handover) | ✔️ | |
| 8 | Lawful intercept | ❌ | |
| 9 | SM message transport (UE↔SMF) | ✔️ | |
| 11 | Access Authentication | ✔️ | |
| 12 | Access Authorization | ✔️ | |
| 14 | SEAF (Security Anchor Function) | ✔️ | |
| 16 | Location services transport (UE↔LMF, RAN↔LMF) | ✔️ | |
| 18 | UE mobility event notification | ✔️ | |
| 21 | Non-3GPP access support | ❌ | |

Every NF has its own `docs/FEATURE_SET.md` in its source directory listing the equivalent matrix for that NF.

---

## Deployment Scenarios

### Scenario I — Minimum Core (with NRF)
```
AMF + SMF + UPF + NRF + UDM + UDR + AUSF + MySQL
```
NRF handles NF service registration and discovery. All NFs register on startup and query NRF to locate each other. This is the recommended scenario because it mirrors a real 5GC deployment.

### Scenario II — Minimal Core (without NRF)
```
AMF + SMF + UPF + UDM + UDR + AUSF + MySQL
```
NF-to-NF addresses are configured statically in each NF's YAML config file. Simpler to configure, but not production-realistic.

### Scenario III — Full Core (research)
```
AMF + SMF + UPF + NRF + UDM + UDR + AUSF + PCF + NSSF + LMF + NEF + NWDAF + MySQL
```
Add-on NFs communicate over the SBI (HTTP/2) and are optional. Useful for experiments involving policy control, network slicing, analytics, or positioning.

### Docker Networking
All NFs are connected on a shared Docker bridge network `demo-oai`:
- Subnet: `192.168.70.128/26`
- NF-to-NF communication uses either **IP addresses** or **FQDNs** (Docker Compose service names act as FQDN)
- The gNB host machine needs a static route to reach the core's bridge subnet

**Prerequisite for user-plane traffic (always required):**
```bash
sudo sysctl net.ipv4.conf.all.forwarding=1
sudo iptables -P FORWARD ACCEPT
```

### Subscriber Provisioning
Subscriber profiles live in the MySQL `AuthenticationSubscription` table. Each row represents one SIM card:

```sql
INSERT INTO `AuthenticationSubscription`
  (`ueid`, `authenticationMethod`, `encPermanentKey`, `protectionParameterId`,
   `sequenceNumber`, `authenticationManagementField`, `algorithmId`,
   `encOpcKey`, `supi`)
VALUES
  ('208950000000031', '5G_AKA',
   '0C0A34601D4F07677303652C0462535B',
   '0C0A34601D4F07677303652C0462535B',
   '{"sqn": "000000000020", "sqnScheme": "NON_TIME_BASED", "lastIndexes": {"ausf": 0}}',
   '8000', 'milenage',
   '63bfa50ee6523365ff14c1f45f88737d',
   '208950000000031');
```

Fields to configure per UE:
- `ueid` / `supi` — IMSI (format: MCC + MNC + subscriber number, e.g. `208950000000001`)
- `encPermanentKey` — 128-bit SIM key K (hex)
- `encOpcKey` — Operator code OPc (hex, derived from OP and K)
- `algorithmId` — `milenage` or `tuak`
- `authenticationMethod` — `5G_AKA` or `EAP_AKA_PRIME`

---

## Packet Capture and Debugging

### Capture all 5GC signalling
```bash
sudo tshark -i demo-oai \
  -f "not arp and not port 53" \
  -Y "ngap || http || pfcp || gtp" \
  -w /tmp/5gcn.pcap
```

### Key protocol filters for Wireshark
| Filter | What you see |
|---|---|
| `ngap` | N2: all gNB–AMF signalling (UE registration, handover) |
| `pfcp` | N4: SMF–UPF session management (PDRs, FARs, URRs) |
| `gtp` | N3: user-plane GTP tunnels (actual data packets) |
| `http2` | SBI: all NF-to-NF REST API calls |
| `nas-5gs` | NAS layer (decoded inside NGAP) |
| `diameter` | Charging (if applicable) |

### Debug logging
Every CN5G NF supports runtime log-level control. To enable debug logs for a specific NF, set in its YAML config:
```yaml
log_level: debug   # options: debug, info, warning, error
```

For RAN, debug output is controlled by the `--log_config` flag at runtime.

---

## Common Research Scenarios and Where to Implement Them

This section maps typical masters/PhD research topics to the specific files you need to modify.

### Implement a custom MAC scheduler
**Goal:** Replace or extend the proportionally-fair DL/UL scheduler  
**Files to modify:**
- `openair2/LAYER2/NR_MAC_gNB/gNB_scheduler_dlsch.c` — DL resource allocation logic
- `openair2/LAYER2/NR_MAC_gNB/gNB_scheduler_ulsch.c` — UL resource allocation logic
- `openair2/LAYER2/NR_MAC_gNB/nr_mac_gNB.h` — Scheduler data structures  
**How schedulers work:** The scheduler is called every slot (0.5ms at 30 kHz SCS). It reads the UE-specific state in `NR_UE_sched_ctrl_t`, assigns PRBs, selects MCS based on reported CQI or HARQ BLER, and fills `nfapi_nr_dl_tti_pdsch_pdu_t` structures for the PHY.

### Add a new xApp for RAN control via E2
**Goal:** Monitor KPIs or send RAN control actions from a nearRT-RIC xApp  
**Files to modify:**
- `openair2/E2AP/flexric/examples/xApp/` — All example xApps live here (Python and C)
- `openair2/E2AP/RAN_FUNCTION/` — E2SM service model implementations on the gNB side  
**How it works:** The gNB E2 agent connects to FlexRIC via TCP. The xApp registers for KPM (Key Performance Metrics) subscriptions, receives `RIC_INDICATION` messages containing MAC/RLC statistics per UE, and optionally sends `RIC_CONTROL` messages to adjust scheduler parameters.

### Implement network slicing policies
**Goal:** Assign different QoS, bandwidth, or policy rules per network slice (S-NSSAI)  
**Files to modify:**
- `OAI_CN_code/oai-cn5g-nssf/src/nssf_app/nssf_app.cpp` — Slice selection logic
- `OAI_CN_code/oai-cn5g-pcf/src/pcf_app/pcf_sm_policy.cpp` — Per-slice SM policy rules
- `OAI_CN_code/oai-cn5g-smf/src/smf_app/smf_context.cpp` — PDU session slice context
- Config: `oai-cn5g-nssf/etc/nssf.yaml` — Define allowed slices and their mappings

### Study the 5G authentication procedure (5G-AKA)
**Goal:** Understand or modify how 5G authentication works  
**Files to read (in order of execution):**
1. `oai-cn5g-amf/src/amf-app/authentication.cpp` — AMF initiates auth
2. `oai-cn5g-ausf/src/ausf_app/ausf_app.cpp` — AUSF executes 5G-AKA
3. `oai-cn5g-ausf/src/5gaka/` — MILENAGE/TUAK f1–f5 functions
4. `oai-cn5g-udm/src/udm_app/udm_app.cpp` — UDM generates AUTH vectors
5. `openairinterface5g/openair3/NAS/` — UE-side NAS authentication handling

### Measure or change UPF packet processing
**Goal:** Modify how user-plane packets are forwarded; add measurement points; modify eBPF programs  
**Files to modify:**
- `oai-cn5g-upf/src/upf_app/SessionManager.cpp` — PFCP session state management
- `oai-cn5g-upf/src/upf_app/SessionProgramManager.cpp` — Installs eBPF forwarding rules
- `oai-cn5g-upf/src/upf_app/bpf/rules/` — eBPF programs: packet detection and action rules
- `oai-cn5g-upf/src/upf_app/bpf/pfcp/` — eBPF PFCP information element parsing  
**Note:** The UPF has two forwarding paths — a slow-path (kernel-space processing) and a fast-path (eBPF). For performance experiments, the eBPF fast path is what matters.

### Add or modify a 5G Core Network Function
**Goal:** Extend an existing NF with new SBI endpoints, or add a new northbound API  
**Pattern to follow:**
1. Modify or add OpenAPI spec to trigger regeneration of `src/api-server/` (or edit the generated files carefully)
2. Implement business logic in `src/<nf>_app/<nf>_app.cpp`
3. Register new service with NRF if it exposes a new service
4. Update `etc/<nf>.yaml` for any new configuration parameters

---

## Where to Make Changes — Outcome-Based Navigation

This section answers the most important engineering question: **"I want to change X — where do I go?"**

---

### RAN / gNB Changes

#### I want to change how the gNB schedules downlink or uplink resources

**Where:** `OAI_RAN_code/openairinterface5g/openair2/LAYER2/NR_MAC_gNB/`  
**Key files:**
- `nr_mac_gNB.h` — MAC state structures, configuration parameters
- `gNB_scheduler.c` — Main DL/UL scheduler loop
- `gNB_scheduler_dlsch.c` — Downlink resource allocation (PDSCH)
- `gNB_scheduler_ulsch.c` — Uplink resource allocation (PUSCH)
- `gNB_scheduler_primitives.c` — Scheduling utility functions
- `nr_mac_scheduler_utils.c` — HARQ, MCS, and slot management
- `gNB_scheduler_RA.c` — Random Access Controller (RACH / RA procedure)

**What drives it:** The scheduler reads per-UE CSI reports, buffer status reports, and HARQ feedback, then fills DCI (Downlink Control Information) messages that tell the UE what resources it has been allocated in each slot.

---

#### I want to change PHY layer signal processing (PDSCH, PUSCH, channel estimation)

**Where:** `OAI_RAN_code/openairinterface5g/openair1/PHY/`  
**Key subdirs:**
| Subdir | What to change there |
|---|---|
| `NR_TRANSPORT/` | PDSCH/PUSCH encoding and decoding (gNB side) |
| `NR_UE_TRANSPORT/` | PDSCH/PUSCH processing (UE side) |
| `NR_ESTIMATION/` | Channel estimation algorithms (gNB side) |
| `NR_UE_ESTIMATION/` | Channel estimation (UE side) |
| `NR_REFSIG/` | Reference signal generation (DMRS, PTRS, CSI-RS, SSB) |
| `CODING/` | LDPC codec (NR) and Polar codes — underlying FEC |
| `MODULATION/` | OFDM modulation/demodulation |
| `SCHED_NR/` | Link-level scheduler that the MAC calls |

**Key headers to understand before diving in:**
- `PHY/defs_gNB.h` — gNB PHY state (`PHY_VARS_gNB`)
- `PHY/defs_nr_common.h` — NR-specific type definitions
- `PHY/impl_defs_nr.h` — NR implementation constants and enums

---

#### I want to change RRC procedures (cell configuration, bearer setup, handover)

**Where:** `OAI_RAN_code/openairinterface5g/openair2/RRC/`  
**Key files:**
- `NR/` — All NR RRC (TS 38.331)
- `NR/nr_rrc_config.c` — Cell and UE context configuration
- `NR/nr_rrc_UE.c` — UE-side RRC state machine
- `NR/rrc_gNB.c` — gNB-side RRC state machine (connection setup, reconfiguration)
- `NR/rrc_gNB_du.c` — RRC interaction with DU via F1AP
- `NR/rrc_gNB_mobility.c` — Handover and mobility management

---

#### I want to change how the gNB connects to the AMF (N2 / NGAP)

**Where:** `OAI_RAN_code/openairinterface5g/openair3/NGAP/`  
- `ngap_gNB.c/h` — Main NGAP state machine on the gNB side
- `ngap_gNB_context.c` — AMF connection management
- `ngap_gNB_nas_procedures.c` — NAS message forwarding (UE registration, PDU session)
- `ngap_gNB_management_procedures.c` — NG-Setup, reset procedures

---

#### I want to change the CU/DU split behavior (F1AP)

**Where:** `OAI_RAN_code/openairinterface5g/openair2/F1AP/`  
Handles the F1 interface between the Central Unit (CU) and Distributed Unit (DU) per 3GPP TS 38.473.

---

#### I want to add or modify an O-RAN xApp / E2 service model

**Where:** `OAI_RAN_code/openairinterface5g/openair2/E2AP/`  
- `RAN_FUNCTION/` — E2 service model implementations (KPM, RC)
- `flexric/` — FlexRIC nearRT-RIC framework (sub-submodule from `gitlab.eurecom.fr/mosaic5g/flexric`)
- For xApps: work inside `flexric/examples/xApp/` 

---

#### I want to change the radio hardware driver (USRP / add a new SDR)

**Where:** `OAI_RAN_code/openairinterface5g/radio/`  
- `USRP/` — Ettus USRP driver
- `rfsimulator/` — Software-only RF simulation (no hardware needed)
- `fhi_72/` — O-RAN FHI 7.2 fronthaul interface
- `COMMON/` — Hardware abstraction layer (HAL) base class — implement a new driver here

---

#### I want to change the gNB configuration file

**Config format:** libconfig (`.conf` files — not YAML)  
**Workshop config:** `OAI_HandsOn_Workshops/oai-workshops/ran/conf/gnb.sa.band78.fr1.106PRB.usrpb210.conf`  
**Config parser:** `openair2/GNB_APP/gnb_config.c`

---

### 5G Core Network Changes

Every CN5G NF follows the same internal layout. Once you know the pattern for one, you know it for all:

```
src/<nf>_app/      ← All the core logic is here
src/api-server/    ← Auto-generated HTTP/2 REST server (do not edit manually)
src/oai_<nf>/      ← main.cpp entry point
src/common-src/    ← Symlink to shared libs (do not modify here)
etc/<nf>.yaml      ← Runtime configuration
```

---

#### I want to change UE registration or authentication behavior

**Component to change:** AMF (controls registration) + AUSF (controls authentication)

**AMF — where to look:**
```
OAI_CN_code/oai-cn5g-amf/src/amf-app/
├── amf_n2.cpp/hpp         ← NGAP handling from gNB (triggers registration)
├── amf_n1.cpp/hpp         ← NAS message processing (UE-to-core signalling)
├── authentication.cpp/hpp ← Drives authentication procedure (calls AUSF)
└── amf_sbi.cpp/hpp        ← NF-to-NF calls (to AUSF, UDM, SMF, NRF)
```

**AUSF — where to look:**
```
OAI_CN_code/oai-cn5g-ausf/src/ausf_app/
└── ausf_app.cpp/hpp    ← 5G-AKA and EAP-AKA' authentication logic

OAI_CN_code/oai-cn5g-ausf/src/5gaka/
└── *.cpp               ← Cryptographic algorithm implementations (f1, f2, f3, f4, f5)
```

---

#### I want to change PDU session establishment or UPF configuration

**Component to change:** SMF (session logic) → UPF (forwarding rules via PFCP)

**SMF — where to look:**
```
OAI_CN_code/oai-cn5g-smf/src/smf_app/
├── smf_context.cpp/hpp         ← PDU session state machine
├── smf_procedure.cpp/hpp       ← SM procedure sequences (create/modify/release)
├── smf_n4.cpp/hpp              ← PFCP session management (calls UPF)
├── smf_pfcp_association.cpp    ← UPF selection and association
├── smf_n11.cpp/hpp             ← N11 interface with AMF
└── smf_sbi.cpp/hpp             ← SBI calls to NRF, PCF, UDM
```

**UPF — where to look:**
```
OAI_CN_code/oai-cn5g-upf/src/upf_app/
├── UserPlaneComponent.cpp/hpp     ← Main user-plane forwarding pipeline
├── SessionManager.cpp/hpp         ← PFCP session management (receives rules from SMF)
├── SessionProgramManager.cpp/hpp  ← Installs forwarding rules into data plane
└── bpf/                           ← eBPF programs for fast-path packet forwarding
    ├── ie/                        ← eBPF information element processing
    ├── pfcp/                      ← eBPF PFCP rule implementation
    └── rules/                     ← eBPF forwarding rule programs
```

---

#### I want to change QoS or policy rules

**Component to change:** PCF (policy) and/or SMF (applies policy to session)

**PCF — where to look:**
```
OAI_CN_code/oai-cn5g-pcf/src/pcf_app/
├── pcf_app.cpp/hpp       ← Policy store and decision engine
├── pcf_am_policy.cpp     ← Access-and-Mobility policy (to AMF via N15)
└── pcf_sm_policy.cpp     ← Session Management policy (to SMF via N7)
```

---

#### I want to change network slice selection

**Component to change:** NSSF

```
OAI_CN_code/oai-cn5g-nssf/src/nssf_app/
└── nssf_app.cpp/hpp    ← S-NSSAI selection logic; consult slice config
```

**Slice configuration:** `OAI_CN_code/oai-cn5g-nssf/etc/nssf.yaml`

---

#### I want to add or modify a subscriber (UE SIM profile)

**Where:** UDR is the database, UDM translates it into 5G-format responses.

- Subscriber records live in the **MySQL database** managed by UDR
- SQL schema and seed data: `OAI_HandsOn_Workshops/oai-workshops/cn/database/oai_db.sql`
- UDR data access layer: `OAI_CN_code/oai-cn5g-udr/src/udr_app/udr_app.cpp`
- Authentication keys (K, OPc): populated per subscriber row in the `AuthenticationSubscription` table

---

#### I want to change NF registration and discovery

**Component to change:** NRF

```
OAI_CN_code/oai-cn5g-nrf/src/nrf_app/
├── nrf_app.cpp/hpp            ← NF registration and subscription handler
├── nrf_profile.cpp/hpp        ← NF profile data model (what a registered NF looks like)
├── nrf_jwt.cpp/hpp            ← OAuth2 JWT token generation and validation
├── nrf_subscription.cpp/hpp   ← Subscribe/notify for NF status change events
└── nrf_search_result.cpp/hpp  ← NF discovery result construction
```

---

#### I want to change how analytics work (NWDAF)

NWDAF is a microservices architecture in **Go** (services) and **Python/FastAPI** (ML analytics). Unlike all other NFs, it does not use CMake.

```
OAI_CN_code/oai-cn5g-nwdaf/components/
│
├── oai-nwdaf-sbi/          ← Go: SBI client/server toward 5GC NFs (subscribes to events)
├── oai-nwdaf-nbi-analytics/← Go: NBI for analytics queries (consumers call this)
├── oai-nwdaf-nbi-events/   ← Go: NBI for event subscription
├── oai-nwdaf-nbi-ml/       ← Go: NBI for ML analytics
├── oai-nwdaf-engine/       ← Go: analytics computation engine
│
└── oai-nwdaf-engine-ads/   ← Python/FastAPI: ML model inference
    ├── run.py              ← FastAPI app entry point
    ├── src/routes.py       ← API routes
    ├── src/functions.py    ← ML model functions (change analytics logic here)
    ├── src/config.py       ← Service configuration
    └── requirements.txt    ← Python dependencies
```

---

#### I want to change UE positioning / location services

**Component to change:** LMF + gNB NRPPA

```
OAI_CN_code/oai-cn5g-lmf/src/lmf_app/   ← Core location logic
OAI_CN_code/oai-cn5g-lmf/src/lpp/       ← LPP (LTE Positioning Protocol) messages
OAI_CN_code/oai-cn5g-lmf/src/nrppa/     ← NR Positioning Protocol A (to gNB)

OAI_RAN_code/openairinterface5g/openair3/NRPPA/  ← gNB side of NR positioning
```

---

#### I want to change how external applications interact with the core (NEF)

```
OAI_CN_code/oai-cn5g-nef/src/nef_app/   ← NEF session and exposure logic
OAI_CN_code/oai-cn5g-nef/src/api-server/ ← Northbound REST API (AF-facing)
```

---

### Shared Infrastructure Changes

#### I want to change something that affects all CN5G NFs (SBI, logging, PFCP)

**Where:** `OAI_CN_code/oai-cn5g-common-src/`  
This directory is a **git submodule included by every NF**. Changes here propagate to all NFs.

| Subdir | What it is |
|---|---|
| `common/` | Shared type definitions, SBI URL helpers, serialization base class |
| `config/` | YAML configuration framework (`config.cpp/hpp`) |
| `http/` | HTTP/2 async SBI client (used for all NF-to-NF calls) |
| `itti/` | Inter-Task Interface — the message bus between async tasks within each NF |
| `logger/` | Logging framework (spdlog-based) — controls log format and levels |
| `model/` | OpenAPI-generated data model classes (all 3GPP SBI types) |
| `pfcp/` | PFCP protocol (shared between SMF and UPF) |
| `ngap/` | Shared NGAP helper functions |
| `nas/` | Shared NAS definitions |
| `utils/` | General utilities (string, networking, threading) |

> **Warning:** Because `common-src` is a shared submodule, changing it affects every NF simultaneously. It is pinned to a specific commit in each NF repo. After modifying `common-src`, each NF must update its submodule pointer.

---

#### I want to add a new C++ dependency to the build

**Where:** `OAI_CN_code/oai-cn5g-common-build/`

- `cmake_modules/` — Add a `Find<Library>.cmake` module
- `installation/build_helper.<libname>` — Add an install script for the dependency
- Then reference it in the target NF's `CMakeLists.txt`

---

### Configuration Changes

#### I want to change how an NF is deployed (IP addresses, ports, interface names)

All CN5G NF runtime configuration is in YAML:
```
OAI_CN_code/oai-cn5g-<nf>/etc/<nf>.yaml
```

For workshop deployments:
```
OAI_HandsOn_Workshops/oai-workshops/cn/conf/<nf>.yaml
```

Key parameters typically found in every NF config:
- Interface names and IP addresses (e.g., `n2`, `sbi` interfaces)
- Other NF SBI endpoints (e.g., where to find NRF, SMF, UPF)
- Slice parameters (MCC, MNC, S-NSSAI)
- Timer values and retry counts

#### I want to change gNB configuration (frequency, bandwidth, cells, AMF address)

```
OAI_HandsOn_Workshops/oai-workshops/ran/conf/gnb.sa.band78.fr1.106PRB.usrpb210.conf
```

Key parameters: `gNB_ID`, `MCC`, `MNC`, `tracking_area_code`, `amf_ip_address`, `GNB_PORT_FOR_S1U` (N3), `NETWORK_INTERFACES`, carrier frequency and bandwidth (`dl_frequencyBand`, `dl_carrierBandwidth`).

---

### If You Want to Run the Full System

#### Prerequisites (one-time host setup)

**Hardware minimum:** 4 CPU cores, 16 GiB RAM, 15 GiB free disk (Docker images alone take ~8 GiB)  
**OS:** Ubuntu 22.04 or 24.04 LTS (recommended); other Linux distros with Docker also work  
**Software:**
- Docker Engine 20.10+ (tested with 29.1.2)
- Docker Compose V2 (the `docker compose` plugin, not the old `docker-compose` binary)
- For packet capture: `tshark` 4.x and `wireshark` 4.x

**Kernel forwarding (required for user-plane data to flow):**
```bash
sudo sysctl net.ipv4.conf.all.forwarding=1
sudo iptables -P FORWARD ACCEPT
```
These settings reset at reboot. For persistence, add to `/etc/sysctl.d/99-oai.conf`.

#### Quickest path — run everything in Docker (no compilation)

```bash
cd OAI_HandsOn_Workshops/oai-workshops/cn/
docker compose up -d mysql oai-nrf oai-udr oai-udm oai-ausf oai-amf oai-smf oai-upf
```

Wait for the core to initialise (watch with `docker compose logs -f oai-amf`; look for `Registered NFs: SMF`).

Then start the gNB and UE in RFsim (software radio — **no SDR hardware needed**):
```bash
docker compose -f docker-compose-ran.yml up -d oai-gnb oai-nr-ue
```

Verify the UE registered successfully:
```bash
docker exec -it oai-nr-ue bash
# Inside the container:
ip addr show oaitun_ue1        # should show 12.1.1.x address
ping -I oaitun_ue1 google.com  # end-to-end user-plane test
```

The workshop reference [OAI_HandsOn_Workshops/OAI_WORKSHOPS_REFERENCE.md](../OAI_HandsOn_Workshops/OAI_WORKSHOPS_REFERENCE.md) contains the full step-by-step procedure with expected log output.

#### Build RAN from source

```bash
cd OAI_RAN_code/openairinterface5g/cmake_targets/
./build_oai -I                        # Install dependencies (first time only, needs sudo)
./build_oai --gNB -w SIMU --ninja     # Build gNB with RFsimulator (software radio)
./build_oai --nrUE -w SIMU --ninja    # Build NR-UE with RFsimulator
```

Other useful build flags:
```bash
./build_oai --gNB -w USRP --ninja     # Build with USRP B210 support
./build_oai --gNB -w USRP --enable-e2 --ninja  # Add FlexRIC E2 agent
./build_oai --eNB -w SIMU --ninja     # Build LTE eNB
./build_oai -c                        # Clean all build artefacts
```

Output binaries: `cmake_targets/ran_build/build/nr-softmodem` (gNB) and `nr-uesoftmodem` (UE)

Run the gNB in SA mode with RFsim:
```bash
cd cmake_targets/ran_build/build/
sudo ./nr-softmodem -O ../../../targets/PROJECTS/GENERIC-NR-5GC/CONF/gnb.sa.band78.fr1.106PRB.usrpb210.conf \
  --rfsim --sa
```

Run the NR-UE in SA mode with RFsim:
```bash
sudo ./nr-uesoftmodem -r 106 --numerology 1 --band 78 \
  --rfsim --sa \
  --uicc0.imsi 208950000000031 \
  --uicc0.key 0C0A34601D4F07677303652C0462535B \
  --uicc0.opc 63bfa50ee6523365ff14c1f45f88737d \
  --rfsimulator.serveraddr 127.0.0.1
```

#### Build a single CN5G NF from source

```bash
cd OAI_CN_code/oai-cn5g-<nf>/
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
```

Debug build (slower but with address sanitizer and debug symbols):
```bash
cmake .. -DCMAKE_BUILD_TYPE=Debug -DENABLE_SANITIZE_ADDR=ON
make -j$(nproc)
```

---

## AI Agents Available in VS Code

When this workspace is open, type `@` in the Copilot Chat window to invoke an agent.

### General Purpose (this workspace)
| Agent | When to use it |
|---|---|
| `@General-Scout-Agent` | Re-scout all docs and regenerate `docs/project-overview.md` |
| `@Code-Scout-Agent` | Re-map source code and regenerate `docs/code-map.md` |
| `@Coding-Agent` | Implement a code change in any NF or RAN component |
| `@Documenting-Agent` | Write or update documentation |
| `@Review-Agent` | Review code for correctness, security, or OAI conventions |
| `@Testing-Agent` | Run builds, tests, or linting |
| `@Research-Agent` | Research 3GPP specs, library docs, or bugs |
| `@Recommendations-Agent` | Get an expert second opinion on a technical design decision |
| `@Memory-Agent` | Record lessons learned or known issues |

### OAI-Specific
| Agent | When to use it |
|---|---|
| `@oai-repo-analyzer` | Deeply analyse any OAI repo's structure and features |
| `@oai-repo-cloner` | Clone any OAI repo from GitLab with the correct local layout |
| `@oai-repo-documenter` | Generate a structured reference document for any OAI repo |

### RAN Protocol Layer Experts (in `OAI_RAN_code/`)
| Agent | Layer |
|---|---|
| `@phy` | L1 — Physical layer (NR transport, LDPC, channel estimation) |
| `@mac` | L2 MAC — Scheduling, HARQ, RACH |
| `@rlc-pdcp` | L2 RLC/PDCP — ARQ, segmentation, ciphering |
| `@rrc` | RRC — Cell config, bearer setup, handover |
| `@ngap-nas` | L3 NGAP/NAS — gNB–AMF signalling |
| `@radio` | Radio HAL — USRP driver, RFsimulator, FHI 7.2 |
| `@cu-du` | CU/DU split — F1AP, E1AP |
| `@oran-e2` | O-RAN E2 — E2AP, E2SM-KPM, FlexRIC xApps |
| `@nfapi` | nFAPI — MAC-PHY split (remote PHY) |

### CN5G NF Experts (in `OAI_CN_code/`)
| Agent | NF |
|---|---|
| `@amf` | AMF — registration, NAS, NGAP |
| `@smf` | SMF — PDU sessions, PFCP |
| `@upf` | UPF — user-plane forwarding, eBPF |
| `@nrf` | NRF — registry, discovery, OAuth2 |
| `@ausf` / `@udm` | Authentication and subscriber data |
| `@udr` | Database (MySQL) |
| `@pcf` | Policy |
| `@nssf` | Slicing |
| `@lmf` | Positioning |
| `@nef` | External exposure |
| `@nwdaf` | Analytics |
| `@upf-vpp` | High-performance VPP/DPDK UPF |
| `@common-src` | Shared C++ libraries |
| `@fed` | Docker Compose deployment |

---

## Key Reference Documents

| Document | Location | What it contains |
|---|---|---|
| RAN repository reference | [OAI_RAN_code/OAI_RAN_REPOSITORIES.md](../OAI_RAN_code/OAI_RAN_REPOSITORIES.md) | RAN versions, GitLab URL, directory structure |
| CN5G repository reference | [OAI_CN_code/OAI_CN5G_REPOSITORIES.md](../OAI_CN_code/OAI_CN5G_REPOSITORIES.md) | All 18 NF repos, versions, 3GPP interfaces |
| CN5G clone commands | [OAI_CN_code/OAI_CN5G_CLONE_LINKS.md](../OAI_CN_code/OAI_CN5G_CLONE_LINKS.md) | One-line git clone command per NF |
| Workshops reference | [OAI_HandsOn_Workshops/OAI_WORKSHOPS_REFERENCE.md](../OAI_HandsOn_Workshops/OAI_WORKSHOPS_REFERENCE.md) | Full CN/RAN/OAM workshop guide |
| RAN build guide | `OAI_RAN_code/openairinterface5g/doc/BUILD.md` | Detailed build instructions |
| RAN feature set | `OAI_RAN_code/openairinterface5g/doc/FEATURE_SET.md` | Supported 3GPP features |
| RAN run guide | `OAI_RAN_code/openairinterface5g/doc/RUNMODEM.md` | How to run gNB and UE |
| Per-NF feature sets | `OAI_CN_code/oai-cn5g-<nf>/docs/FEATURE_SET.md` | Per-NF 3GPP compliance matrix |
| Code map | [docs/code-map.md](code-map.md) | Detailed file-level source map |
| Project overview | [docs/project-overview.md](project-overview.md) | Auto-generated high-level overview |

---

## Versions in This Workspace

| Component | Version |
|---|---|
| openairinterface5g | `2026.w12` (branch `develop`) |
| oai-cn5g-amf | `v2.1.9-191-g4d9b0d3d` |
| oai-cn5g-smf | `v2.2.0-2-g29cfc992` |
| oai-cn5g-upf | `v2.2.0-1-g0d46d59` |
| oai-cn5g-nrf | `v2.1.9-15-g7ed0bc3` |
| oai-cn5g-ausf | `v2.1.9-16-g3ce0281` |
| oai-cn5g-udm | `v2.1.9-12-gc2a21b7` |
| oai-cn5g-udr | `v2.2.0-1-g0b6dc8d8` |
| oai-cn5g-pcf | `v2.2.0-1-g8984579` |
| oai-cn5g-nssf | `v2.1.0-22-g5d3d152` |
| oai-cn5g-lmf | `v2.2.0-1-g4111b2c` |
| oai-cn5g-nef | `v1.5.1` |
| oai-cn5g-nwdaf | `v2.0.0` |
| oai-cn5g-upf-vpp | `v1.5.1` |
| oai-cn5g-common-src | `v2.1.0-347-g2cae1fc1` |

All upstream source repositories are on GitLab Eurecom:  
`https://gitlab.eurecom.fr/oai/openairinterface5g` (RAN)  
`https://gitlab.eurecom.fr/oai/cn5g/<repo>` (each CN5G NF)

---

## Research and Academic Context

### Who Uses OAI and For What

OAI is the standard platform for academic 5G research. It is used by:

- **University labs** building custom schedulers, new PHY algorithms, and xApps
- **Industry R&D** prototyping new 5G features (O-RAN, AI/ML radio, private networks)
- **Standardisation bodies** — researchers writing 3GPP contributions use OAI to validate implementations
- **EU/US government research programmes** — NSF PAWR, Horizon Europe, NATO DIANA use OAI as their baseline platform

Compared to commercial 5G stacks, OAI offers full source access to every layer. This makes it the only platform where a masters or PhD student can, for example, trace exactly what happens from a scheduler decision at L2 down to the transmitted waveform at L1.

### Where OAI Fits in the 5G Open-Source Ecosystem

| Project | Layer | Language | Maturity |
|---|---|---|---|
| **OAI RAN** | PHY–L3 (split or monolithic gNB) | C (mainly), C++ | Production-grade; used in real deployments |
| **OAI CN5G** | All 5GC NFs | C++ | Production-grade; part of operator testbeds |
| **srsRAN Project** | gNB (L1-L3, CU/DU split) | C++ | High performance; less research-friendly |
| **free5GC** | 5G Core | Go | Active; popular in Asia; simpler codebase |
| **Open5GS** | 4G EPC + 5G Core | C | Very stable; widely used for EPC experiments |
| **UERANSIM** | UE + gNB simulator | C++ | Signalling-only; no real radio |
| **OSC Near-RT RIC** | O-RAN RIC + E2 | C++, Python, Go | Reference O-RAN platform |
| **FlexRIC** | nearRT-RIC (embedded in OAI) | C, Python | Fully integrated with OAI gNB; easiest E2 xApp development |

For your masters research, the most common OAI-based experiment setup is:
```
OAI gNB (RFsim) ←→ OAI NR-UE (RFsim) ←→ OAI CN5G (Docker Compose)
```
This runs entirely in software on a single workstation. No SDR hardware is required.

### Typical Research Contributions Using OAI

| Research area | What you implement | Where in the code |
|---|---|---|
| ML-based scheduling | Gym-compatible RL environment + custom scheduler | `openair2/LAYER2/NR_MAC_gNB/gNB_scheduler_*.c` + xApp |
| Physical-layer security | Modified PDCP ciphering or custom NAS auth | `openairinterface5g/openair2/LAYER2/nr_pdcp/` |
| Network slicing QoS | Custom PCF policies + NSSF slice mapping | `oai-cn5g-pcf`, `oai-cn5g-nssf` |
| NTN/satellite 5G | Extended TA compensation, large PD | `openair1/SCHED_NR/` (PHY timing) |
| Positioning (NR Positioning) | Custom LMF algorithms using PRS reports | `oai-cn5g-lmf/src/lmf_app/` |
| AI/ML in RAN (O-RAN) | E2SM-MHO xApp, custom KPM metrics | `openair2/E2AP/flexric/examples/xApp/` |
| Edge computing / MEC | NEF northbound exposure for edge apps | `oai-cn5g-nef/src/nef_app/` |
| Standalone private 5G | Configure PLMN, add subscribers, run gNB | `etc/` YAML + `gnb.conf` |

### 3GPP Specifications Commonly Referenced

When you read OAI source code and encounter an unfamiliar value or procedure, look it up in the corresponding 3GPP spec. 3GPP publishes all specs free of charge at [www.3gpp.org](https://www.3gpp.org/DynaReport/TSG-WG--index.htm); ETSI mirrors them at [portal.etsi.org](https://portal.etsi.org/).

| What you are looking at | Specification |
|---|---|
| NR Physical layer (waveform, channels, procedures) | **[TS 38.211](https://www.3gpp.org/DynaReport/38211.htm)**, **[TS 38.212](https://www.3gpp.org/DynaReport/38212.htm)**, **[TS 38.213](https://www.3gpp.org/DynaReport/38213.htm)**, **[TS 38.214](https://www.3gpp.org/DynaReport/38214.htm)** |
| MAC protocol | **[TS 38.321](https://www.3gpp.org/DynaReport/38321.htm)** |
| RLC protocol | **[TS 38.322](https://www.3gpp.org/DynaReport/38322.htm)** |
| PDCP protocol | **[TS 38.323](https://www.3gpp.org/DynaReport/38323.htm)** |
| SDAP (QoS-to-DRB mapping) | **[TS 37.324](https://www.3gpp.org/DynaReport/37324.htm)** |
| RRC messages | **[TS 38.331](https://www.3gpp.org/DynaReport/38331.htm)** |
| NGAP (gNB–AMF N2) | **[TS 38.413](https://www.3gpp.org/DynaReport/38413.htm)** |
| F1AP (CU–DU split) | **[TS 38.473](https://www.3gpp.org/DynaReport/38473.htm)** |
| E1AP (CU-CP – CU-UP split) | **[TS 38.463](https://www.3gpp.org/DynaReport/38463.htm)** |
| GTP-U (user plane tunnel) | **[TS 29.281](https://www.3gpp.org/DynaReport/29281.htm)** |
| NAS 5GS (UE–AMF N1) | **[TS 24.501](https://www.3gpp.org/DynaReport/24501.htm)** |
| 5G System architecture | **[TS 23.501](https://www.3gpp.org/DynaReport/23501.htm)** |
| AMF procedures | **[TS 23.502](https://www.3gpp.org/DynaReport/23502.htm)** |
| SMF / PDU sessions | **[TS 23.502](https://www.3gpp.org/DynaReport/23502.htm)** §4.3 |
| PFCP (SMF–UPF N4) | **[TS 29.244](https://www.3gpp.org/DynaReport/29244.htm)** |
| SBI (HTTP/2 REST, OpenAPI) | **[TS 29.500](https://www.3gpp.org/DynaReport/29500.htm)**, **[TS 29.501](https://www.3gpp.org/DynaReport/29501.htm)** |
| Authentication (5G-AKA, EAP-AKA') | **[TS 33.501](https://www.3gpp.org/DynaReport/33501.htm)** |
| MILENAGE algorithm | **[TS 35.206](https://www.3gpp.org/DynaReport/35206.htm)** |
| Network slicing | **[TS 23.501](https://www.3gpp.org/DynaReport/23501.htm)** §5.15 |
| O-RAN E2 AP | **[O-RAN.WG3.E2AP](https://www.o-ran.org/specifications)** |
| E2SM-KPM | **[O-RAN.WG3.E2SM-KPM](https://www.o-ran.org/specifications)** |

### Reporting Issues and Getting Help

- **OAI RAN issues:** GitLab issues on `gitlab.eurecom.fr/oai/openairinterface5g`
- **OAI CN5G issues:** `openair5g-cn@lists.eurecom.fr` or per-NF GitLab issue tracker
- **Community forum:** `openairinterface.org/oai-open-source-community/`
- **Workshops and training:** OAI holds multiple hands-on workshops per year (Europe, USA). Workshop materials are in `OAI_HandsOn_Workshops/`
- **OAI Public License:** Commercial use requires joining the OpenAirInterface Software Alliance (OSA). Academic and research use is free under the OAI Public License V1.1 (Apache 2.0 base with an additional commercial use clause).
