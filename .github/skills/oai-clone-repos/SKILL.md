---
name: oai-clone-repos
description: "Skill for cloning OpenAirInterface repositories from GitLab Eurecom. Use when: cloning oai repos, cloning openairinterface5g, cloning cn5g repos, cloning oai 5g core, fetching oai source code. Knows all official OAI repository URLs and the correct local directory layout."
---

# OAI Repository Cloning Skill

This skill guides the complete workflow for cloning any OAI GitLab repository.

## Quick Reference — Official Clone URLs

### OAI RAN
```bash
# Full 5G NR + LTE RAN stack
git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git
```

### OAI 5G Core Network
```bash
# Federation repo (deployment recipes — clone this first for full CN5G setup)
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-fed.git

# All CN5G network function repos
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-amf.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-smf.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-upf.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-nrf.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-ausf.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-udm.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-udr.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-nssf.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-pcf.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-lmf.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-nef.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-nwdaf.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-upf-vpp.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-upf-sdfabric.git

# Shared repos
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-common-build.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-common-ci.git
git clone https://gitlab.eurecom.fr/oai/cn5g/oai-cn5g-common-src.git

# FlexRIC (O-RAN E2/RIC framework - submodule of openairinterface5g)
git clone https://gitlab.eurecom.fr/mosaic5g/flexric.git
```

## Standard Local Directory Layout
```
~/Documents/OAI/OAI_STANDARD_SETUP/
├── OAI_RAN_code/
│   ├── openairinterface5g/       ← RAN repo
│   └── OAI_RAN_REPOSITORIES.md  ← Documentation
└── OAI_CN_code/
    ├── oai-cn5g-amf/
    ├── oai-cn5g-smf/
    ├── oai-cn5g-upf/
    ├── oai-cn5g-nrf/
    ├── ... (other NFs)
    ├── oai-cn5g-fed/
    ├── OAI_CN5G_REPOSITORIES.md
    └── OAI_CN5G_CLONE_LINKS.md
```

## Step-by-Step Procedure

### 1. Create directory structure
```bash
mkdir -p ~/Documents/OAI/OAI_STANDARD_SETUP/OAI_RAN_code
mkdir -p ~/Documents/OAI/OAI_STANDARD_SETUP/OAI_CN_code
```

### 2. Check if already cloned
```bash
# Check for existing clone (skip if .git exists)
ls ~/Documents/OAI/OAI_STANDARD_SETUP/OAI_RAN_code/openairinterface5g/.git 2>/dev/null \
  && echo "Already cloned" || echo "Need to clone"

ls ~/Documents/OAI/OAI_STANDARD_SETUP/OAI_CN_code/.git 2>/dev/null || true
```

### 3. Clone
```bash
cd ~/Documents/OAI/OAI_STANDARD_SETUP/OAI_RAN_code
git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git
```

### 4. Verify
```bash
cd openairinterface5g
git describe --tags --always   # → e.g. 2026.w12
git log --oneline -3
git remote get-url origin
```

### 5. Update memory
After a successful clone, update `/memories/oai_repositories.md` with the new version.

## Important Notes
- **Fish shell:** Fish shell does not support `$(...)` variable assignment. Use Python or `GIT_DIR`/`GIT_WORK_TREE` env vars for git commands outside the repo directory.
- **Default branches:** RAN uses `develop`; most CN5G NF repos use `master`; shared CN5G repos use `develop`.
- **Submodules:** `openairinterface5g` has FlexRIC as a submodule. Initialize with `git submodule update --init` if needed.
- **Large repo:** `openairinterface5g` is large (~500 MB+). Allow ample time for initial clone.
