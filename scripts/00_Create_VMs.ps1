# Run on the HP in PowerShell (as your normal user). Creates the DC01 and WS01 VMs in VirtualBox 7, ready for Windows setup.
# Edit the two ISO paths below, then run:  powershell -ExecutionPolicy Bypass -File .\00_Create_VMs.ps1
$ServerIso = "$env:USERPROFILE\Downloads\WindowsServer2022_Eval.iso"
$ClientIso = "$env:USERPROFILE\Downloads\Windows10_Enterprise_Eval.iso"
$ClientOs  = "Windows10_64"      # use Windows11_64 only if you have set up TPM/Secure Boot

$vbm = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
if (-not (Test-Path $vbm)) { throw "VBoxManage not found. Check your VirtualBox install path." }
foreach ($iso in $ServerIso, $ClientIso) { if (-not (Test-Path $iso)) { throw "ISO not found: $iso" } }
$dir = Join-Path $env:USERPROFILE "VirtualBox VMs"

function New-LabVm($name, $os, $iso) {
    & $vbm createvm --name $name --ostype $os --register
    & $vbm modifyvm $name --memory 4096 --cpus 2 --vram 128 --graphicscontroller vboxsvga --nic1 intnet --intnet1 labnet --clipboard-mode bidirectional
    $disk = Join-Path $dir "$name\$name.vdi"
    & $vbm createmedium disk --filename $disk --size 51200
    & $vbm storagectl $name --name SATA --add sata --controller IntelAhci
    & $vbm storageattach $name --storagectl SATA --port 0 --device 0 --type hdd --medium $disk
    & $vbm storagectl $name --name IDE --add ide
    & $vbm storageattach $name --storagectl IDE --port 0 --device 0 --type dvddrive --medium $iso
    Write-Host "Created $name"
}
New-LabVm "DC01" "Windows2022_64" $ServerIso
New-LabVm "WS01" $ClientOs $ClientIso
Write-Host "Done. Open VirtualBox, start DC01, and install Windows Server 2022 (Desktop Experience)."
