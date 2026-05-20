# CVEReaper-Skill

<p align="center">        <img src="https://img.shields.io/badge/tools-IDA%20MCP%20%7C%20angr%20%7C%20SaTC-orange.svg" alt="Tools">   <img src="https://img.shields.io/badge/targets-D--Link%20%7C%20TP--Link%20%7C%20Netgear-green.svg" alt="Targets"> </p>

A Claude skill for automated end-to-end 1-day vulnerability discovery in extracted IoT firmware filesystems. Given an unpacked firmware root, CVEReaper orchestrates attack surface mapping, CVE knowledge base correlation, triage risk scoring, SaTC-style frontend-to-backend parameter tracing, and angr symbolic execution verification — outputting a structured Markdown vulnerability report.

------

## Overview

CVEReaper-Skill is a [Claude Code](https://claude.ai/code) skill (`SKILL.md`) that automates the full IoT firmware vulnerability mining pipeline. It is designed for MIPS router firmware (D-Link, TP-Link, Netgear, TOTOLINK) and assumes the firmware filesystem has already been extracted (e.g., via `binwalk -eM`).

The skill drives Claude through 5 structured phases, enforcing a triage-first discipline: no function is deeply analyzed without a risk score, and no vulnerability is confirmed without angr verification.

------

## Pipeline

```
Extracted Firmware FS
        │
        ▼
┌─────────────────────┐
│  Phase 0            │  CVE Knowledge Base init (NVD API, one-time)
│  CVE KB             │
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  Phase 1            │  Find MIPS ELF binaries, CGI handlers,
│  Attack Surface     │  dangerous imports (strcpy, system, popen…)
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  Phase 2            │  Score every CGI function (7 signals).
│  Triage Scoring     │  Top-8 HIGH-risk functions advance only.
└────────┬────────────┘
         │  Top-8 only
         ▼
┌─────────────────────┐
│  Phase 3            │  Frontend key extraction (HTML/JS grep) +
│  SaTC Correlation   │  IDA MCP backend tracing + decompile confirm
└────────┬────────────┘
         │  confirmed / suspected paths
         ▼
┌─────────────────────┐
│  Phase 4            │  angr symbolic execution per finding.
│  angr Verification  │  REACHABLE → confirmed vuln. NOT REACHABLE → excluded.
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│  Phase 5            │  Structured Markdown report with PoC,
│  Report             │  call chains, CVE references, remediation.
└─────────────────────┘
```

------

## Triage Scoring Signals

| Signal                                                       | IDA MCP Tool  | Score   |
| ------------------------------------------------------------ | ------------- | ------- |
| Direct call to `strcpy` / `sprintf` / `gets` / `system` / `popen` / `execve` | `callees`     | +4 each |
| Indirect call (≤ 2 hops) to dangerous function               | `callgraph`   | +2 each |
| Name contains `cmd` / `exec` / `upload` / `ping` / `debug` / `tftp` / `set_` | name match    | +3      |
| Stack buffer < 512 bytes                                     | `stack_frame` | +2      |
| CVE KB match (same binary / version)                         | local KB      | +5      |
| Directly reachable from main / dispatch                      | `xrefs_to`    | +2      |
| Function body > 100 instructions                             | `list_funcs`  | +1      |

**Thresholds:** ≥ 6 → HIGH (→ Phase 3) · 3–5 → MEDIUM (logged) · < 3 → LOW (excluded)

------

## Dependencies

| Tool                                                     | Role                                               |
| -------------------------------------------------------- | -------------------------------------------------- |
| [IDA Pro + ida-mcp](https://github.com/mrexodia/ida-mcp) | Static analysis, decompilation, call graph tracing |
| [angr](https://angr.io/)                                 | Symbolic execution & reachability verification     |
| Python 3 + `sqlite3` + `requests`                        | CVE KB bootstrap (NVD API v2)                      |
| `binwalk`                                                | Firmware extraction (pre-skill, not automated)     |
| `strings`, `file`, `find`                                | Attack surface mapping (Phase 1)                   |

------

## Usage

1. Extract the firmware filesystem with `binwalk -eM <firmware.bin>`.
2. Open Claude Code and load this skill (`SKILL.md`).
3. Point Claude at the extracted filesystem:

```
Analyze the firmware at ~/firmware/squashfs-root for vulnerabilities.
```

1. Claude will run all 5 phases and write a report to:

```
./iotreaper_report_<YYYYMMDD_HHMMSS>.md
```

------

## Sample Report

[`iotreaper_report_20260518_021903.md`](https://claude.ai/chat/iotreaper_report_20260518_021903.md) — analysis of a **TOTOLINK CS810R** firmware (MIPS32 big-endian, lighttpd 1.4.30).

**Findings summary:**

| #    | Function                  | Type                | CVSS | Confidence            |
| ---- | ------------------------- | ------------------- | ---- | --------------------- |
| 1    | `NTPSyncWithHost`         | Command Injection   | 9.8  | High (CVE-2021-45733) |
| 2    | `setPasswordCfg`          | Command Injection   | 9.8  | High (CVE-2018-13315) |
| 3    | `WPSSingleTriggerHandler` | Command Injection   | 9.8  | High (CVE-2021-45740) |
| 4    | `setTelnetCfg`            | Unauthorized Telnet | 9.8  | High (CVE-2021-35327) |
| 5    | `setUpgradeFW`            | Path Injection      | —    | Medium                |

------

## Repository Structure

```
CVEReaper-Skill/
├── SKILL.md                              # The Claude skill definition (5-phase workflow)
├── rootfs/squashfs-root/                 # Sample extracted firmware filesystem (TOTOLINK CS810R)
└── iotreaper_report_20260518_021903.md   # Sample output report
```

------

## Hard Rules

The skill enforces three non-negotiable constraints:

1. **Always run Triage (Phase 2) before deep analysis.** Never analyze all CGI functions without scoring first.
2. **Always run angr verification (Phase 4) before declaring a confirmed vulnerability.** IDA decompile alone is not sufficient.
3. **Always check CVE KB (Phase 0) before Phase 1.** Prior CVEs shape what you look for and contribute +5 to triage scores.

------

## Contact

For questions or issues, open an [Issue](https://github.com/VodkaVortex/CVEReaper-Skill/issues) or reach out: realyangshuangning@gmail.com
