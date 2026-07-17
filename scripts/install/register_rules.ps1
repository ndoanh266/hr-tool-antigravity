param (
    [string]$RepoDir
)

function Write-Log {
    param([string]$message)
    $logFile = "C:\mkt\installer_debug.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[RULES][$timestamp] $message" | Out-File -FilePath $logFile -Append -Encoding utf8
}

Write-Log "Bat dau register_rules.ps1. RepoDir=$RepoDir"

$targetFile = "$env:USERPROFILE\.gemini\GEMINI.md"
$rulePath = $RepoDir.Replace('\', '/') + "/INSTRUCTIONS_FOR_AI.md"
$ruleLine = "@$rulePath"

Write-Host "Dang dang ky luat trong cau hinh Gemini toan cuc ($targetFile)..."

if (-not (Test-Path $targetFile)) {
    Write-Log "[ERROR] Khong tim thay file $targetFile!"
    Write-Host "[ERROR] Khong tim thay file $targetFile!"
    Write-Host "Vui long dam bao Antigravity da duoc khoi tao."
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show("Khong tim thay $targetFile! Vui long dam bao Antigravity da duoc khoi tao.", "HR Tool Installer", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    exit 1
}

# Check if rule already exists
$content = Get-Content -Path $targetFile -Raw
if ($content -match [regex]::Escape($ruleLine)) {
    Write-Log "[INFO] Luat da duoc dang ky truoc do trong GEMINI.md."
    Write-Host "[INFO] Luat da duoc dang ky truoc do trong GEMINI.md."
} else {
    Add-Content -Path $targetFile -Value ""
    Add-Content -Path $targetFile -Value "# HR Tool Antigravity Rules"
    Add-Content -Path $targetFile -Value $ruleLine
    Write-Log "[SUCCESS] Dang ky luat thanh cong vao GEMINI.md: $ruleLine"
    Write-Host "[SUCCESS] Dang ky luat thanh cong vao GEMINI.md."
}
