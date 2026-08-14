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

# 1. Find installed Antigravity path
$appPath = ""
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
$key = Get-ChildItem $regPath -ErrorAction SilentlyContinue | Where-Object {
    (Get-ItemProperty $_.PsPath -Name DisplayName -ErrorAction SilentlyContinue).DisplayName -like "*Antigravity*"
}

if ($key) {
    $iconValue = (Get-ItemProperty $key.PsPath -Name DisplayIcon -ErrorAction SilentlyContinue).DisplayIcon
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
    Write-Message "Không tìm thấy Antigravity IDE. Bắt đầu tải bộ cài đặt..."
    
    if (Test-Path $tempInstaller) { Remove-Item $tempInstaller -Force -ErrorAction SilentlyContinue }
    
    try {
        # Try BITS Transfer
        Import-Module BitsTransfer -ErrorAction SilentlyContinue
        Start-BitsTransfer -Source $installerUrl -Destination $tempInstaller -ErrorAction Stop
    } catch {
        # Fallback to Net.WebClient
        try {
            Write-Message "BitsTransfer thất bại, đang chuyển sang WebClient..." "WARNING"
            [Net.ServicePointManager]::SecurityProtocol = 3072
            (New-Object System.Net.WebClient).DownloadFile($installerUrl, $tempInstaller)
        } catch {
            Write-Message "Không thể tải bộ cài đặt Antigravity IDE: $_" "ERROR"
            exit 1
        }
    }
    
    if (Test-Path $tempInstaller) {
        Write-Message "Đang chạy cài đặt âm thầm Antigravity IDE..."
        $process = Start-Process -FilePath $tempInstaller -ArgumentList "/VERYSILENT", "/NORESTART", "/SP-" -Wait -PassThru
        if ($process.ExitCode -eq 0) {
            Write-Message "Cài đặt Antigravity IDE thành công!" "SUCCESS"
            # Refresh app path
            $appPath = "$env:LOCALAPPDATA\Programs\Antigravity\Antigravity.exe"
            if (-not (Test-Path $appPath)) {
                $appPath = "D:\Users\dell\AppData\Local\Programs\Antigravity\Antigravity.exe"
            }
        } else {
            Write-Message "Cài đặt thất bại với mã lỗi: $($process.ExitCode)" "ERROR"
            exit 1
        }
        Remove-Item $tempInstaller -Force -ErrorAction SilentlyContinue
    }
} else {
    Write-Message "Đã phát hiện Antigravity IDE tại: $appPath" "SUCCESS"
}

# 3. Install AG Auto Click & Scroll extension
if (Test-Path $appPath) {
    $binDir = Join-Path (Split-Path $appPath) "bin"
    $cmdPath = Join-Path $binDir "antigravity.cmd"
    if (Test-Path $cmdPath) {
        Write-Message "Đang kiểm tra danh sách extension..."
        $installed = & $cmdPath --list-extensions 2>$null
        if ($installed -notcontains "zixfel.ag-auto-click-scroll") {
            Write-Message "Đang tiến hành cài đặt extension AG Auto Click & Scroll..."
            & $cmdPath --install-extension zixfel.ag-auto-click-scroll
            Write-Message "Đã cài đặt extension AG Auto Click & Scroll thành công!" "SUCCESS"
        } else {
            Write-Message "Extension AG Auto Click & Scroll đã được cài đặt từ trước." "SUCCESS"
        }
    } else {
        Write-Message "Không tìm thấy file lệnh CLI: $cmdPath" "WARNING"
    }
} else {
    Write-Message "Không thể xác định thư mục cài đặt Antigravity để cài extension." "ERROR"
}
