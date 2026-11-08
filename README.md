# Active Directory Home Lab

A small Windows domain built in VirtualBox to practice the day-to-day work of an IT help desk and systems support role: domain setup, users and groups, Group Policy, account support, and PowerShell automation.

**Status: work in progress.** I'm building this one lab at a time. Write-ups and screenshots are added as each lab is completed, and the status table below is kept honest.

## Environment
| Item | Detail |
|---|---|
| Hypervisor | Oracle VirtualBox |
| Domain controller | `DC01`, Windows Server 2022 Evaluation, `10.10.10.10` |
| Client | `WS01`, Windows 10/11 Enterprise Evaluation, `10.10.10.20` |
| Domain | `corp.lab` |
| Network | VirtualBox Internal Network `labnet` (isolated from the home network) |

## Lab status
| # | Lab | Status |
|---|---|---|
| 1 | Build the domain (DC01) | Planned |
| 2 | OUs, groups, and users | Planned |
| 3 | Join a client to the domain | Planned |
| 4 | Group Policy (password policy, mapped drive, restrictions) | Planned |
| 5 | Help desk tasks (password reset, unlock, disable leaver, shared-folder permissions) | Planned |
| 6 | PowerShell reporting (inactive accounts) | Planned |
| 7 | DHCP and remote support (RDP) | Planned |
| 8 | Cloud identity basics (Microsoft Entra ID, MFA) | Planned |

## Repository layout
- `docs/runbook.md`: step-by-step build instructions
- `scripts/`: PowerShell scripts for VM creation, domain setup, and user creation
- `data/users.csv`: fictional users for the lab

## Notes
- All names and data are fictional. No real credentials, IP addresses outside the isolated lab network, or personal data are stored here.
- Scripts are written for a lab and have not yet been run end to end. Treat them as drafts until the matching lab is marked complete.
