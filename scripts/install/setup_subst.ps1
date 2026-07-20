param (
    [string]$CvDir,
    [string]$RepoDir,
    [string]$DriveLabel = "Google Shared with me",
    [string]$DriveIcon = "default"
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
        
        $regKeyClasses = "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\$($driveLetter)\DefaultLabel"
        $null = New-Item -Path $regKeyClasses -Force -Value $DriveLabel
    } catch {}
    
    # Set custom icon in Windows Registry
    try {
        $iconPath = ""
        if ($DriveIcon -eq "gdrive") {
            # Find Google Drive executable
            $gdfs = Get-ChildItem -Path "C:\Program Files\Google\Drive File Stream" -Filter "GoogleDriveFS.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty FullName
            if ($gdfs) {
                $iconPath = "$gdfs,0"
            } else {
                $iconPath = "imageres.dll,198"
            }
        } elseif ($DriveIcon -eq "folder") {
            $iconPath = "shell32.dll,3"
        } elseif ($DriveIcon -eq "cloud") {
            $iconPath = "imageres.dll,198"
        } elseif ($DriveIcon -ne "default" -and $DriveIcon) {
            $iconPath = $DriveIcon
        }

        if ($iconPath) {
            $regIconKey1 = "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\$($driveLetter)\DefaultIcon"
            $null = New-Item -Path $regIconKey1 -Force -Value $iconPath
            
            $regIconKey2 = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\$($driveLetter)\DefaultIcon"
            $null = New-Item -Path $regIconKey2 -Force -Value $iconPath
        } else {
            Remove-Item -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\$($driveLetter)\DefaultIcon" -Force -ErrorAction SilentlyContinue | Out-Null
            Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\DriveIcons\$($driveLetter)\DefaultIcon" -Force -ErrorAction SilentlyContinue | Out-Null
        }
    } catch {}

    # Notify Windows Shell to refresh labels and icons in Explorer
    try {
        if (-not ([System.Management.Automation.PSTypeName]"WinAPI.ShellNotify").Type) {
            $code = @'
            [System.Runtime.InteropServices.DllImport("Shell32.dll")]
            public static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);
'@
            Add-Type -MemberDefinition $code -Name ShellNotify -Namespace WinAPI -ErrorAction SilentlyContinue | Out-Null
        }
        $null = [WinAPI.ShellNotify]::SHChangeNotify(0x8000000, 0x1000, [IntPtr]::Zero, [IntPtr]::Zero)
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
