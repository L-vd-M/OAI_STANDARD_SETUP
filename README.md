# OAI Standard Setup Workspace

**GitHub Repository:** [github.com/L-vd-M/OAI_STANDARD_SETUP](https://github.com/L-vd-M/OAI_STANDARD_SETUP)  
**Organisation:** OpenAirInterface Software Alliance / Eurecom  
**Last Updated:** 2026-03-24  

---

## Overview

**🔗 https://github.com/L-vd-M/OAI_STANDARD_SETUP**

This workspace is the central development environment for working with OpenAirInterface (OAI) 5G source code. It consolidates the OAI 5G RAN, 5G Core Network, and hands-on training material into a single structured workspace, with GitHub Copilot AI agent support for code analysis, cloning, and documentation.

---

## Workspace Structure

```
OAI_STANDARD_SETUP/
├── README.md                         This file — workspace overview
├── .github/                          GitHub Copilot customization files
│   ├── skills/                       Reusable AI skill definitions
│   │   ├── oai-analyze-repos/        Skill: analyse OAI repo structure & architecture
│   │   ├── oai-clone-repos/          Skill: clone OAI repositories from GitLab
│   │   └── oai-document-repos/       Skill: generate OAI repository reference docs
│   └── agents/                       VS Code Copilot agent symlinks (auto-discovery)
│       ├── oai-repo-analyzer.agent.md
│       ├── oai-repo-cloner.agent.md
│       └── oai-repo-documenter.agent.md
├── OAI_RAN_code/                     [git submodule] OAI 5G RAN source code
│   └── openairinterface5g/           OAI gNB / NR-UE implementation
├── OAI_CN_code/                      [git submodule] OAI 5G Core Network source code
│   ├── oai-cn5g-amf/                 Access and Mobility Management Function
│   ├── oai-cn5g-ausf/                Authentication Server Function
│   ├── oai-cn5g-lmf/                 Location Management Function
│   ├── oai-cn5g-nef/                 Network Exposure Function
│   ├── oai-cn5g-nrf/                 Network Repository Function
│   ├── oai-cn5g-nssf/                Network Slice Selection Function
│   ├── oai-cn5g-nwdaf/               Network Data Analytics Function
│   ├── oai-cn5g-pcf/                 Policy Control Function
│   ├── oai-cn5g-smf/                 Session Management Function
│   ├── oai-cn5g-udm/                 Unified Data Management
│   ├── oai-cn5g-udr/                 Unified Data Repository
│   ├── oai-cn5g-upf/                 User Plane Function
│   ├── oai-cn5g-upf-vpp/             UPF — VPP-based data plane
│   ├── oai-cn5g-upf-sdfabric/        UPF — SD-Fabric data plane
│   ├── oai-cn5g-common-build/        Shared CMake build scripts
│   ├── oai-cn5g-common-ci/           Shared CI/CD pipeline scripts
│   └── oai-cn5g-common-src/          Shared C++ source libraries (SBI, logger, PFCP, NGAP, …)
└── OAI_HandsOn_Workshops/            Hands-on workshop training material (local clone)
    └── oai-workshops/                OAI official workshop repository
        ├── cn/                       Core Network hands-on tutorial
        ├── ran/                      RAN hands-on tutorial
        └── oam/                      O-RAN / FlexRIC OAM tutorial
```

---

## Git Submodules

| Submodule | Local Path | GitHub URL |
|---|---|---|
| OAI 5G RAN | `OAI_RAN_code/` | [github.com/L-vd-M/OAI_RAN_code](https://github.com/L-vd-M/OAI_RAN_code) |
| OAI 5G Core | `OAI_CN_code/` | [github.com/L-vd-M/OAI_cn5g](https://github.com/L-vd-M/OAI_cn5g) |

### Clone with submodules

```bash
git clone --recurse-submodules https://github.com/L-vd-M/OAI_STANDARD_SETUP.git
```

### Update submodules after cloning

```bash
git submodule update --init --recursive
```

---

## Key Documentation

| Document | Location | Description |
|---|---|---|
| RAN Repository Reference | [OAI_RAN_code/OAI_RAN_REPOSITORIES.md](OAI_RAN_code/OAI_RAN_REPOSITORIES.md) | RAN repo URLs, versions, structure |
| CN5G Repository Reference | [OAI_CN_code/OAI_CN5G_REPOSITORIES.md](OAI_CN_code/OAI_CN5G_REPOSITORIES.md) | All CN5G NF repo details |
| CN5G Clone Links | [OAI_CN_code/OAI_CN5G_CLONE_LINKS.md](OAI_CN_code/OAI_CN5G_CLONE_LINKS.md) | Quick-reference clone commands |
| Workshops Reference | [OAI_HandsOn_Workshops/OAI_WORKSHOPS_REFERENCE.md](OAI_HandsOn_Workshops/OAI_WORKSHOPS_REFERENCE.md) | Combined CN / RAN / OAM workshop guide |

---

## GitHub Copilot Agents

Three custom AI agents are available in VS Code when this workspace is open:

| Agent | Purpose |
|---|---|
| `@oai-repo-analyzer` | Analyse OAI repo structure, architecture, and features |
| `@oai-repo-cloner` | Clone OAI repositories from GitLab Eurecom with correct layout |
| `@oai-repo-documenter` | Generate structured Markdown reference documents for any OAI repo |

---

## Source Repositories (upstream)

| Component | GitLab URL |
|---|---|
| OAI RAN (openairinterface5g) | `https://gitlab.eurecom.fr/oai/openairinterface5g.git` |
| OAI CN5G namespace | `https://gitlab.eurecom.fr/oai/cn5g/` |
| OAI Workshops | `https://gitlab.eurecom.fr/oai/trainings/oai-workshops.git` |
| FlexRIC (nearRT-RIC) | `https://gitlab.eurecom.fr/mosaic5g/flexric.git` |
