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

# Check if there are modified rules/scripts in RepoDir via git status
$hasLocalModifications = $false
if (Get-Command git -ErrorAction SilentlyContinue) {
    if (Test-Path "$RepoDir\.git") {
        Push-Location $RepoDir
        $gitStatus = git status --porcelain
        Pop-Location
        if ($gitStatus) {
            $hasLocalModifications = $true
            Write-Log "[INFO] Phat hien cac rule/script da duoc nguoi dung chinh sua/cai tien."
        }
    }
}

if ($hasLocalModifications) {
    if ($UpdateMode -eq "Ask") {
        Write-Host ""
        Write-Host "=========================================================" -ForegroundColor Yellow
        Write-Host " PHAT HIEN RULE / SCRIPT DA DUOC NGUOI DUNG CAI TIEN!" -ForegroundColor Yellow
        Write-Host "=========================================================" -ForegroundColor Yellow
        Write-Host "1. Reset/Cap nhat toan bo (Xoa bo rule/script da sua de dung phien ban moi nhat tu repo)"
        Write-Host "2. Giu nguyen rule da sua (Chi cap nhat cac file cau hinh va GEMINI.md)"
        Write-Host ""
        $choice = Read-Host "Nhap lua chon cua ban (1 hoac 2) [Mac dinh: 2]"
        if ($choice -eq "1") {
            $UpdateMode = "Overwrite"
        } else {
            $UpdateMode = "Keep"
        }
    }

    if ($UpdateMode -eq "Overwrite") {
        Write-Log "[INFO] Nguoi dung chon OVERWRITE toàn bo rule/script."
        Write-Host "[INFO] Dang khoi phuc toan bo rule & script theo ban goc moi nhat..." -ForegroundColor Cyan
        Push-Location $RepoDir
        git reset --hard HEAD
        git pull origin main
        Pop-Location
        Write-Host "[OK] Da cap nhat va khoi phuc thanh cong!" -ForegroundColor Green
    } else {
        Write-Log "[INFO] Nguoi dung chon KEEP cac rule/script da sua."
        Write-Host "[INFO] Giu nguyen cac file rule/script da duoc ban cai tien. Tien hanh cap nhat file cau hinh..." -ForegroundColor Yellow
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

