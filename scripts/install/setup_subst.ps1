param (
    [string]$CvDir,
    [string]$RepoDir,
    [string]$DriveLabel = "Google Shared with me"
)

function Write-Log {
    param([string]$message)
    $logFile = "C:\mkt\installer_debug.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[SUBST][$timestamp] $message" | Out-File -FilePath $logFile -Append -Encoding utf8
}

Write-Log "Bat dau setup_subst.ps1. CvDir=$CvDir, RepoDir=$RepoDir, DriveLabel=$DriveLabel"

if ($CvDir -eq 'CANCEL' -or $CvDir -eq 'SKIP' -or [string]::IsNullOrEmpty($CvDir)) {
    Write-Log "[WARNING] Huy/Bo qua chon thu muc CV. Tu dong dung thu muc mac dinh: $RepoDir\CVs"
    Write-Host "[WARNING] Huy/Bo qua chon thu muc CV. Tu dong dung thu muc mac dinh: $RepoDir\CVs"
    $CvDir = "$RepoDir\CVs"
    $ShouldSubst = $false
} else {
    $ShouldSubst = $true
}

$FinalCvDir = $CvDir

if ($ShouldSubst) {
    # Find a free drive letter (scanning backwards from Z to F)
    $letters = @('Z', 'Y', 'X', 'W', 'V', 'U', 'T', 'S', 'R', 'Q', 'P', 'O', 'N', 'M', 'L', 'K', 'J', 'I', 'H', 'G', 'F')
    $driveLetter = $null
    foreach ($l in $letters) {
        if (-not (Test-Path "$($l):")) {
            $driveLetter = $l
            break
        }
    }
    if (-not $driveLetter) { $driveLetter = 'O' }

    Write-Host "[INFO] Dang tu dong anh xa thu muc CV thanh o dia $($driveLetter):..."
    
    # Run subst
    subst "$($driveLetter):" /d 2>$null | Out-Null
    subst "$($driveLetter):" "$CvDir"
    
    # Set custom label in Windows Registry so it displays as custom label
    try {
        $regKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\$($driveLetter)\DefaultLabel"
        $null = New-Item -Path $regKey -Force -Value $DriveLabel
    } catch {}
    
    # Verify if the drive now exists
    if (Test-Path "$($driveLetter):") {
        Write-Log "[SUCCESS] Da tao o dia $($driveLetter): lien ket den CV."
        Write-Host "[SUCCESS] Da tao o dia $($driveLetter): lien ket truc tiep den thu muc CV cua ban."
        
        # Windows Startup persistent script
        $startupDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
        if (-not (Test-Path $startupDir)) {
            New-Item -ItemType Directory -Force -Path $startupDir | Out-Null
        }
        $startupFile = "$startupDir\mount_cv_drive.bat"
        $content = @"
@echo off
subst $($driveLetter): /d >nul 2>nul
subst $($driveLetter): "$CvDir"
"@
        Set-Content -Path $startupFile -Value $content -Encoding Ascii
        Write-Log "Ghi file startup $startupFile thanh cong."
        Write-Host "[INFO] Da cau hinh tu dong khoi dong o dia $($driveLetter): cung Windows."
        
        $FinalCvDir = "$($driveLetter):\"
    } else {
        Write-Log "[WARNING] Khong the anh xa o dia $($driveLetter):"
        Write-Host "[WARNING] Khong the anh xa o dia $($driveLetter):. He thong se dung duong dan goc."
    }
}

# Write config.env
if (-not (Test-Path $RepoDir)) {
    New-Item -ItemType Directory -Force -Path $RepoDir | Out-Null
}
$configFile = "$RepoDir\config.env"
$configContent = @"
REPO_DIR=$RepoDir
CV_DIR=$FinalCvDir
"@
Set-Content -Path $configFile -Value $configContent -Encoding UTF8
Write-Log "Da ghi file config.env voi noi dung: REPO_DIR=$RepoDir, CV_DIR=$FinalCvDir"
Write-Host "[INFO] Da ghi file cau hinh config.env"
