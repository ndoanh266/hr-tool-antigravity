# install_rules.ps1 - Unified Installer Orchestrator
$repoUrl = "https://github.com/ndoanh266/hr-tool-antigravity.git"
$tempPathFile = "$env:TEMP\hr_tool_setup_paths.txt"
$logFile = "C:\mkt\installer_debug.log"

function Write-Log {
    param([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[ORCH][$timestamp] $message" | Out-File -FilePath $logFile -Append -Encoding utf8
    Write-Host $message
}

# Initialize Log
"===================================================" | Out-File -FilePath $logFile -Encoding utf8
"  HR Tool Antigravity - Unified Installer Log       " | Out-File -FilePath $logFile -Append -Encoding utf8
"  Time: $(Get-Date)" | Out-File -FilePath $logFile -Append -Encoding utf8
"===================================================" | Out-File -FilePath $logFile -Append -Encoding utf8

# 1. Determine directories
$currentDir = [System.IO.Path]::GetFullPath("$PSScriptRoot\..\..")
$guiScript = "$currentDir\scripts\install\installer_gui.ps1"

Write-Log "[INFO] Khoi dong giao dien cau hinh..."

# Remove old temp file
if (Test-Path $tempPathFile) { Remove-Item $tempPathFile -Force }

# 2. Run GUI Stage 1 (Collection)
$proc = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$guiScript`" -RepoDir `"$currentDir`"" -Wait -NoNewWindow -PassThru
if ($proc.ExitCode -ne 0) {
    Write-Log "[ERROR] GUI Stage 1 thoat voi ma loi $($proc.ExitCode)"
    Read-Host "Nhan Enter de thoat..."
    exit 1
}

# 3. Read Temp File
if (-not (Test-Path $tempPathFile)) {
    Write-Log "[ERROR] Khong tim thay file ket qua cau hinh tu GUI."
    Read-Host "Nhan Enter de thoat..."
    exit 1
}

$content = Get-Content $tempPathFile -Raw
$parts = $content.Split('|')
$repoDir = $parts[0].Trim()
$cvDir = $parts[1].Trim()
$driveLabel = if ($parts.Length -ge 3) { $parts[2].Trim() } else { "Google Shared with me" }
$driveIcon = if ($parts.Length -ge 4) { $parts[3].Trim() } else { "default" }

if ($repoDir -eq "CANCEL") {
    Write-Log "[INFO] Nguoi dung da huy setup."
    exit 0
}

Write-Log "[INFO] Thu muc cai dat: $repoDir"
Write-Log "[INFO] Thu muc CV: $cvDir"
Write-Log "[INFO] Ten hien thi o dia: $driveLabel"

# 4. Sync source via Git if Git is installed
if (Get-Command git -ErrorAction SilentlyContinue) {
    if (-not (Test-Path "$repoDir\.git")) {
        Write-Log "[INFO] Dang tai ma nguon ve $repoDir..."
        git clone $repoUrl $repoDir
    } else {
        Write-Log "[INFO] Dang cap nhat ma nguon tai $repoDir..."
        Push-Location $repoDir
        git pull
        Pop-Location
    }
} else {
    Write-Log "[WARNING] Khong tim thay Git. Bo qua buoc cap nhat ma nguon."
}

# 5. Run setup_subst.ps1
Write-Log "[INFO] Dang cau hinh o dia ao..."
$setupSubstScript = "$repoDir\scripts\install\setup_subst.ps1"
if (Test-Path $setupSubstScript) {
    & $setupSubstScript -CvDir $cvDir -RepoDir $repoDir -DriveLabel $driveLabel -DriveIcon $driveIcon
} else {
    Write-Log "[ERROR] Khong tim thay script setup_subst.ps1"
}

# 6. Run register_rules.ps1
Write-Log "[INFO] Dang dang ky luat he thong..."
$registerRulesScript = "$repoDir\scripts\install\register_rules.ps1"
if (Test-Path $registerRulesScript) {
    & $registerRulesScript -RepoDir $repoDir
} else {
    Write-Log "[ERROR] Khong tim thay script register_rules.ps1"
}

# 7. Get drive letter from config.env
$finalCvDrive = "None"
$configFile = "$repoDir\config.env"
if (Test-Path $configFile) {
    $envContent = Get-Content $configFile
    foreach ($line in $envContent) {
        if ($line -like "CV_DIR=*") {
            $finalCvDrive = $line.Substring(7).Trim()
        }
    }
}

# Strip trailing backslash from drive letter if needed
if ($finalCvDrive.EndsWith("\")) {
    $finalCvDrive = $finalCvDrive.Substring(0, $finalCvDrive.Length - 1)
}

Write-Log "[INFO] Drive Letter to pass: $finalCvDrive"

# 8. Run GUI Stage 3 (Success Screen)
Write-Log "[INFO] Dang khoi dong giao dien thong bao thanh cong..."
$proc = Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$guiScript`" -Success -RepoDir `"$repoDir`" -CvDir `"$cvDir`" -DriveLetter `"$finalCvDrive`"" -Wait -NoNewWindow -PassThru

Write-Log "[SUCCESS] Toan bo qua trinh thiet lap da hoan tat!"
Read-Host "Nhan Enter de dong cua so..."
