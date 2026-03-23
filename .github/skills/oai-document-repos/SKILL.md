---
name: oai-document-repos
description: "Skill for generating and updating documentation for OpenAirInterface repositories. Use when: documenting oai repos, creating oai reference doc, writing oai repository guide, updating oai repo documentation, generating oai markdown docs, creating repo summary for openairinterface5g or cn5g repos."
---

# OAI Repository Documentation Skill

This skill guides the creation and maintenance of comprehensive documentation for OAI repositories.

## Document Types

| Document | Purpose | Location |
|---|---|---|
| `OAI_RAN_REPOSITORIES.md` | Complete RAN repo reference | `OAI_RAN_code/` |
| `OAI_CN5G_REPOSITORIES.md` | Complete CN5G repo reference | `OAI_CN_code/` |
| `OAI_CN5G_CLONE_LINKS.md` | Quick clone reference for CN5G | `OAI_CN_code/` |
| `<REPO>_REFERENCE.md` | Single-repo deep dive | Inside repo |

---

## Required Sections for Any OAI Document

Every OAI repo document MUST include:

1. **Header block** — project name, organisation, license, date, GitLab URL
2. **Repository summary table** — repo name, URL, branch, tag/version, commit hash
3. **Clone command** — exact `git clone` command
4. **Directory structure** — annotated tree with one-line descriptions
5. **Detailed component descriptions** — purpose of each major directory
6. **Supported standards table** — 3GPP releases, O-RAN specs
7. **Deployment modes** (for RAN) or **3GPP interfaces** (for CN5G NFs)
8. **Related repositories** — links to companion repos
9. **Footer** — generation date and tool used

---

## Standard Header Template

```markdown
# <TITLE> — Repository Reference Document

**Project:** <Full Project Name>
**Organisation:** OpenAirInterface Software Alliance / Eurecom
**License:** OAI Public License V1.1
**Document generated:** <YYYY-MM-DD>

---

## Overview
<2-4 sentence project description>

---
```

---

## Standard Repository Table Format

```markdown
| Repository | GitLab URL | Branch | Tag / Version | Latest Commit Hash |
|---|---|---|---|---|
| `repo-name` | [gitlab.eurecom.fr/...](https://gitlab.eurecom.fr/...) | `develop` | `2026.w12` | `0ba31c0f89dd` |
```

---

## Directory Structure Format

Use a code block with inline comments:
```
repo-root/
├── src/           Source code — core implementation
├── include/       Public header files
├── docker/        Dockerfiles for Ubuntu/RHEL/Rocky
├── scripts/       Build and deployment helpers
├── charts/        Helm charts for Kubernetes
├── doc/           Technical documentation
└── ci-scripts/    CI/CD pipeline scripts
```

---

## Version String Format

Always use `git describe --tags --always` output, not just a version number.  
Example: `v2.1.9-191-g4d9b0d3d` breaks down as:
- `v2.1.9` — nearest tag
- `191` — commits since that tag
- `g4d9b0d3d` — short commit hash with `g` prefix

---

## Gathering Data for Documentation

Run these commands to gather all required info:

```python
# Python3 — works in fish AND bash
import subprocess, os

repo = '/home/lourens/Documents/OAI/OAI_STANDARD_SETUP/OAI_RAN_code/openairinterface5g'
env = dict(os.environ, GIT_DIR=f'{repo}/.git', GIT_WORK_TREE=repo)

tag = subprocess.check_output(['git','describe','--tags','--always'], env=env, text=True).strip()
commit = subprocess.check_output(['git','log','--format=%H','-1'], env=env, text=True).strip()
date = subprocess.check_output(['git','log','--format=%ai','-1'], env=env, text=True).strip()
url = subprocess.check_output(['git','remote','get-url','origin'], env=env, text=True).strip()
branch = subprocess.check_output(['git','branch','--show-current'], env=env, text=True).strip()

print(f"Tag: {tag}\nCommit: {commit}\nDate: {date}\nURL: {url}\nBranch: {branch}")
```

---

## Document Update Procedure

When updating an existing document:
1. Read the current document first
2. Run data gathering script to get fresh version info
3. Update only the version/commit fields — preserve the rest
4. Update "Document generated" date

When creating a new document:
1. Gather all data (structure, versions, README)
2. Follow the template sections in order
3. Save to the correct path (see Document Types table above)
4. Update `/memories/oai_repositories.md` to reference the new document

---

## Quality Checklist

Before finalizing any document:
- [ ] All GitLab URLs are HTTPS (not SSH)
- [ ] GitLab URL in table is a live markdown link `[text](url)`
- [ ] Version includes tag string from `git describe`, not just branch name
- [ ] Commit hash present (at least 8 chars)
- [ ] Clone command is verbatim-copyable
- [ ] Directory tree has single-line description for every major directory
- [ ] Standards table has Status column (Production-ready / Experimental / Partial)
- [ ] "Document generated" date is at the top
- [ ] Footer credits GitHub Copilot and clone date

---

## Reference Documents

Use these existing documents as style references:
- `/home/lourens/Documents/OAI/OAI_STANDARD_SETUP/OAI_RAN_code/OAI_RAN_REPOSITORIES.md`
- `/home/lourens/Documents/OAI/OAI_STANDARD_SETUP/OAI_CN_code/OAI_CN5G_REPOSITORIES.md`
