# Home Lab Runbook: Active Directory (Labs 1–3)
Host: HP Envy x360 | Hypervisor: VirtualBox | Domain: corp.lab

## 0. Get the ISOs (free evaluation copies)
- Windows Server 2022 Evaluation (180 days): Microsoft Evaluation Center, "Windows Server 2022" ISO (64-bit, English).
- Windows 10 or 11 Enterprise Evaluation (90 days) for the client. Windows 10 is easier in VirtualBox (no TPM/Secure Boot setup).
- Download from Microsoft's site only. Confirm the file is an .iso from microsoft.com.

## 1. Create the VMs in VirtualBox
| VM | Name | RAM | CPUs | Disk | Notes |
|---|---|---|---|---|---|
| Server | DC01 | 4096 MB | 2 | 50 GB | Choose "Desktop Experience" at install |
| Client | WS01 | 4096 MB (min 3072) | 2 | 50 GB | |

Network (both VMs): Settings > Network > Adapter 1 > Attached to: **Internal Network**, name **labnet**.
(This keeps the lab isolated. Both VMs use only this adapter, which also avoids multi-NIC problems on a domain controller.)

Install Windows on each, set a local Administrator password, and take a VirtualBox snapshot named "Clean install".

## 2. Lab 1: Build the domain (DC01)
1. Copy the scripts into DC01 (drag and drop, a shared folder, or paste into PowerShell ISE).
2. Open PowerShell as Administrator. Run `01a_DC_Network_Rename.ps1`. The server restarts as DC01.
3. Log in again. Run `01b_DC_Promote.ps1`. Set a DSRM password and let it restart.
4. Log in as **CORP\Administrator**.
5. Verify: run `Get-ADDomain`, `Get-Service NTDS, DNS` (both Running), and `dcdiag /q` (no errors). Screenshot each.
6. Snapshot: "Domain ready".

## 3. Lab 2: OUs, groups, users (DC01)
1. Put `02_Create_OUs_Groups_Users.ps1` and `users.csv` in the same folder.
2. Run the script as Administrator. Enter an initial password (for example 12+ characters with upper, lower, number, symbol).
3. Open **Active Directory Users and Computers** and confirm: OU CorpLab with Users, Computers, Groups; 10 users; groups GG_Sales, GG_HR, GG_IT, GG_Finance. Screenshot.
4. Snapshot: "OUs and users".

## 4. Lab 3: Join the client (WS01)
1. Run `03_Client_Join_Domain.ps1` as Administrator, entering CORP\Administrator when prompted.
2. After restart, choose **Other user** and sign in as `CORP\ana.rivera` (set a new password at first login).
3. Verify: `whoami`, `echo %USERDOMAIN%`, and `nslookup corp.lab`. Screenshot.
4. On DC01, move the WS01 computer object from "Computers" to OU CorpLab > Computers.
5. Snapshot: "Client joined".

## 5. Document each lab (this is what goes on the resume)
Write 5–8 lines per lab: goal, what you did, how you verified it, one problem you hit and how you fixed it. Add screenshots. Save as Google Docs or a GitHub repo.

## 6. Up next
- Lab 4: Group Policy (password policy, mapped drive, restrictions)
- Lab 5: helpdesk tasks (password reset, account unlock, disable a leaver, shared-folder permissions)
- Lab 6: more PowerShell (inactive-accounts report)

## Troubleshooting
- Client can't find the domain: confirm both VMs use Internal Network "labnet" and the client's DNS is 10.10.10.10.
- Script blocked: run `Set-ExecutionPolicy -Scope Process Bypass` first.
- Evaluation copies expire (180 or 90 days). Fine for lab use.
