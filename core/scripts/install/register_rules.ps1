param (
    [string]$RepoDir,
    [string]$UpdateMode = "Ask" # Options: Ask, Overwrite, Keep
)

function Write-Log {
    param([string]$message)
    $logFile = "C:\mkt\installer_debug.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[RULES][$timestamp] $message" | Out-File -FilePath $logFile -Append -Encoding utf8
}

Write-Log "Bat dau register_rules.ps1. RepoDir=$RepoDir, UpdateMode=$UpdateMode"

# Always auto-update core system scripts (Admin controlled)
if (Get-Command git -ErrorAction SilentlyContinue) {
    if (Test-Path "$RepoDir\.git") {
        Push-Location $RepoDir
        Write-Log "[INFO] Dang tu dong cap nhat cac file he thong Core tu Admin (GitHub)..."
        git checkout origin/main -- core/ *>$null
        Pop-Location
    }
}

# Check if there are modified custom rules/scripts in RepoDir/custom via git status
$hasCustomModifications = $false
if (Get-Command git -ErrorAction SilentlyContinue) {
    if (Test-Path "$RepoDir\.git") {
        Push-Location $RepoDir
        $gitStatus = git status --porcelain custom/
        Pop-Location
        if ($gitStatus) {
            $hasCustomModifications = $true
            Write-Log "[INFO] Phat hien cac rule/script trong thu muc custom/ da duoc nguoi dung chinh sua/cai tien."
        }
    }
}

if ($hasCustomModifications) {
    if ($UpdateMode -eq "Ask") {
        Write-Host ""
        Write-Host "=========================================================" -ForegroundColor Yellow
        Write-Host " PHAT HIEN RULE / SCRIPT CAI TIEN TRONG THU MUC CUSTOM/ !" -ForegroundColor Yellow
        Write-Host "=========================================================" -ForegroundColor Yellow
        Write-Host "1. Reset/Cap nhat custom/ (Xoa bo cai tien de dung phien ban moi nhat tu Admin)"
        Write-Host "2. Giu nguyen custom/ (Giu lai cac rule/script ban da cai tien)"
        Write-Host ""
        $choice = Read-Host "Nhap lua chon cua ban (1 hoac 2) [Mac dinh: 2]"
        if ($choice -eq "1") {
            $UpdateMode = "Overwrite"
        } else {
            $UpdateMode = "Keep"
        }
    }

    if ($UpdateMode -eq "Overwrite") {
        Write-Log "[INFO] Nguoi dung chon OVERWRITE thu muc custom/."
        Write-Host "[INFO] Dang khoi phuc thu muc custom/ theo ban goc moi nhat tu Admin..." -ForegroundColor Cyan
        Push-Location $RepoDir
        git checkout origin/main -- custom/
        Pop-Location
        Write-Host "[OK] Da cap nhat va khoi phuc thanh cong thu muc custom/!" -ForegroundColor Green
    } else {
        Write-Log "[INFO] Nguoi dung chon KEEP cac rule/script trong custom/."
        Write-Host "[INFO] Giu nguyen cac file rule/script ban da cai tien trong custom/. Dang cap nhat file cau hinh..." -ForegroundColor Yellow
    }
}

$targetFile = "$env:USERPROFILE\.gemini\GEMINI.md"
$rulePath = $RepoDir.Replace([char]92, '/') + "/INSTRUCTIONS_FOR_AI.md"
$ruleLine = "@$rulePath"

Write-Host "Dang dang ky luat trong cau hinh Gemini toan cuc ($targetFile)..."

if (-not (Test-Path $targetFile)) {
    Write-Log "[INFO] Thu muc .gemini hoac file GEMINI.md chua duoc khoi tao. Dang tu dong khoi tao..."
    Write-Host "[INFO] Thu muc .gemini hoac file GEMINI.md chua duoc khoi tao. Dang tu dong khoi tao..."
    $parentDir = Split-Path $targetFile
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
    }
    New-Item -ItemType File -Force -Path $targetFile -Value "" | Out-Null
}

# Check if rule already exists
$content = Get-Content -Path $targetFile -Raw
if ($content -match [regex]::Escape($ruleLine)) {
    Write-Log "[INFO] Luat da duoc dang ky truoc do trong GEMINI.md."
    Write-Host "[INFO] Luat da duoc dang ky truoc do trong GEMINI.md."
}
else {
    Add-Content -Path $targetFile -Value ""
    Add-Content -Path $targetFile -Value "# HR Tool Antigravity Rules"
    Add-Content -Path $targetFile -Value "@$rulePath"
    Add-Content -Path $targetFile -Value ""
    Add-Content -Path $targetFile -Value "**Rule:** For any user request that directly involves HR functionality (e.g., CV extraction, JD processing, candidate scoring, email drafting, ad creation, etc.), Antigravity must first load and consult ``$rulePath`` before performing any reasoning or system actions. This ensures consistent adherence to the defined multi-step workflow and prevents bypassing the central instruction set."
    Write-Log "[SUCCESS] Dang ky luat thanh cong vao GEMINI.md: $ruleLine"
    Write-Host "[SUCCESS] Dang ky luat thanh cong vao GEMINI.md."
}

