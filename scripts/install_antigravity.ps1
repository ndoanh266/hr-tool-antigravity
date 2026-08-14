# install_antigravity.ps1 - Checks and installs Antigravity IDE + AG Auto Click & Scroll extension
$installerUrl = "https://edgedl.me.gvt1.com/edgedl/release2/j0qc3/antigravity/stable/2.5.5-4923483625488384/windows-x64/Antigravity%20IDE.exe"
$tempInstaller = "$env:TEMP\AntigravitySetup.exe"

function Write-Message {
    param([string]$msg, [string]$type="INFO")
    $color = "Cyan"
    if ($type -eq "SUCCESS") { $color = "Green" }
    elseif ($type -eq "WARNING") { $color = "Yellow" }
    elseif ($type -eq "ERROR") { $color = "Red" }
    Write-Host "[$type] $msg" -ForegroundColor $color
}

# 0. Check System Specifications (RAM, Architecture, OS)
$is64 = [Environment]::Is64BitOperatingSystem
$ramGB = 0
try {
    $ramBytes = (Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory
    $ramGB = [Math]::Round($ramBytes / 1GB)
} catch {
    try {
        $ramBytes = (Get-CimInstance Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum
        $ramGB = [Math]::Round($ramBytes / 1GB)
    } catch {}
}

$os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
if (-not $os) { $os = Get-WmiObject Win32_OperatingSystem -ErrorAction SilentlyContinue }
$osVer = if ($os) { $os.Version } else { "Unknown" }
$osName = if ($os) { $os.Caption } else { "Unknown" }

if (-not $is64) {
    Write-Message "He dieu hanh 32-bit KHONG duoc ho tro boi Antigravity IDE va Google Drive." "ERROR"
    exit 1
}

$warn = $false
if ($ramGB -gt 0 -and $ramGB -lt 4) { $warn = $true }
if ($osVer -ne "Unknown" -and $osVer.Split('.')[0] -lt 10) { $warn = $true }

if ($warn) {
    Write-Message "========================================================" "WARNING"
    Write-Message " PHAT HIEN CAU HINH MAY YEU HOAC HE DIEU HANH CU!" "WARNING"
    Write-Message "========================================================" "WARNING"
    Write-Message " - He dieu hanh: $osName" "WARNING"
    Write-Message " - RAM: $ramGB GB (Khuyen nghi tu 8GB tro len)" "WARNING"
    Write-Message " - Qua trinh cai dat van co the tiep tuc, nhung hieu nang su dung" "WARNING"
    Write-Message "   se bi anh huong nang hoac mot so tinh nang co he khong hoat dong." "WARNING"
    Write-Message "========================================================" "WARNING"
    Start-Sleep -Seconds 5
} else {
    Write-Message "Cau hinh he thong dat yeu cau khuyen nghi: $osName, RAM $ramGB GB." "SUCCESS"
}

# 1. Find installed Antigravity path
$appPath = ""
$installedApp = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "*Antigravity*" }

if ($installedApp) {
    $iconValue = $installedApp.DisplayIcon
    if ($iconValue) {
        $appPath = $iconValue.Split(",")[0].Trim('"')
    }
}

if (-not $appPath -or -not (Test-Path $appPath)) {
    # Check default paths
    $defaultPaths = @(
        "$env:LOCALAPPDATA\Programs\Antigravity\Antigravity.exe",
        "D:\Users\dell\AppData\Local\Programs\Antigravity\Antigravity.exe"
    )
    foreach ($p in $defaultPaths) {
        if (Test-Path $p) {
            $appPath = $p
            break
        }
    }
}

# 2. Install Antigravity if not found
if (-not $appPath -or -not (Test-Path $appPath)) {
    Write-Message "Khong tim thay Antigravity IDE. Bat dau tai bo cai dat..."
    
    if (Test-Path $tempInstaller) { Remove-Item $tempInstaller -Force -ErrorAction SilentlyContinue }
    
    try {
        # Try BITS Transfer
        Import-Module BitsTransfer -ErrorAction SilentlyContinue
        Start-BitsTransfer -Source $installerUrl -Destination $tempInstaller -ErrorAction Stop
    } catch {
        # Fallback to Net.WebClient
        try {
            Write-Message "BitsTransfer that bai, dang chuyen sang WebClient..." "WARNING"
            [Net.ServicePointManager]::SecurityProtocol = 3072
            (New-Object System.Net.WebClient).DownloadFile($installerUrl, $tempInstaller)
        } catch {
            Write-Message "Khong the tai bo cai dat Antigravity IDE: $_" "ERROR"
            exit 1
        }
    }
    
    if (Test-Path $tempInstaller) {
        Write-Message "Dang chay cai dat am tham Antigravity IDE..."
        $process = Start-Process -FilePath $tempInstaller -ArgumentList "/VERYSILENT", "/NORESTART", "/SP-" -Wait -PassThru
        if ($process.ExitCode -eq 0) {
            Write-Message "Cai dat Antigravity IDE thanh cong!" "SUCCESS"
            # Refresh app path
            $appPath = "$env:LOCALAPPDATA\Programs\Antigravity\Antigravity.exe"
            if (-not (Test-Path $appPath)) {
                $appPath = "D:\Users\dell\AppData\Local\Programs\Antigravity\Antigravity.exe"
            }
        } else {
            Write-Message "Cai dat that bai voi ma loi: $($process.ExitCode)" "ERROR"
            exit 1
        }
        Remove-Item $tempInstaller -Force -ErrorAction SilentlyContinue
    }
} else {
    Write-Message "Da phat hien Antigravity IDE tai: $appPath" "SUCCESS"
}

# 3. Install AG Auto Click & Scroll extension
if (Test-Path $appPath) {
    $binDir = Join-Path (Split-Path $appPath) "bin"
    $cmdPath = Join-Path $binDir "antigravity.cmd"
    if (Test-Path $cmdPath) {
        Write-Message "Dang kiem tra danh sach extension..."
        $installed = & $cmdPath --list-extensions 2>$null
        if ($installed -notcontains "zixfel.ag-auto-click-scroll") {
            Write-Message "Dang tien hanh cai dat extension AG Auto Click & Scroll..."
            & $cmdPath --install-extension zixfel.ag-auto-click-scroll
            Write-Message "Da cai dat extension AG Auto Click & Scroll thanh cong!" "SUCCESS"
        } else {
            Write-Message "Extension AG Auto Click & Scroll da duoc cai dat tu truoc." "SUCCESS"
        }
    } else {
        Write-Message "Khong tim thay file lenh CLI: $cmdPath" "WARNING"
    }
} else {
    Write-Message "Khong the xac dinh thu muc cai dat Antigravity de cai extension." "ERROR"
}
