param (
    [switch]$Success,
    [string]$RepoDir = "C:\mkt",
    [string]$CvDir = "",
    [string]$DriveLetter = ""
)

# Dynamically correct RepoDir if it points to a directory without the installation scripts
if ($RepoDir -eq "C:\mkt" -and -not (Test-Path "$RepoDir\scripts\install\installer_gui.ps1")) {
    $RepoDir = [System.IO.Path]::GetFullPath("$PSScriptRoot\..\..")
}

function Write-Log {
    param([string]$message)
    $logFile = "C:\mkt\installer_debug.log"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[GUI][$timestamp] $message" | Out-File -FilePath $logFile -Append -Encoding utf8
}

Write-Log "Khoi dong GUI. Parameters: Success=$Success, RepoDir=$RepoDir, CvDir=$CvDir, DriveLetter=$DriveLetter"

try {
    Write-Log "Dang add Assembly Forms/Drawing"
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    Write-Log "Dang khoi tao Form"
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "HR Tool Antigravity v1.6 - Installer Wizard"
    $form.Size = New-Object System.Drawing.Size(550, 500)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.BackColor = [System.Drawing.Color]::FromArgb(248, 249, 250)
    # Shared global state across panels
    $globalState = @{
        RepoDir = $RepoDir
        CvDir = $CvDir
        DriveLetter = $DriveLetter
        Success = $Success
        Form = $form
        ShowPanel = {
            param($panel)
            $globalState.Panel1.Visible = $false
            $globalState.Panel2_1.Visible = $false
            $globalState.Panel2_2.Visible = $false
            $globalState.Panel3.Visible = $false
            $panel.Visible = $true
        }
    }

    # Load panel definitions from modular files
    Write-Log "Dang load cac panels tu scripts..."
    $panel1 = . "$PSScriptRoot\gui\step1_panel.ps1" -form $form -globalState $globalState
    $panel2_1 = . "$PSScriptRoot\gui\step2_1_panel.ps1" -form $form -globalState $globalState
    $panel2_2 = . "$PSScriptRoot\gui\step2_2_panel.ps1" -form $form -globalState $globalState
    $panel3 = . "$PSScriptRoot\gui\step3_panel.ps1" -form $form -globalState $globalState

    # Map panels in globalState
    $globalState.Panel1 = $panel1
    $globalState.Panel2_1 = $panel2_1
    $globalState.Panel2_2 = $panel2_2
    $globalState.Panel3 = $panel3

    # Hide all panels initially to prevent overlapping in z-order
    $panel1.Visible = $false
    $panel2_1.Visible = $false
    $panel2_2.Visible = $false
    $panel3.Visible = $false

    $form.Controls.Add($panel1)
    $form.Controls.Add($panel2_1)
    $form.Controls.Add($panel2_2)
    $form.Controls.Add($panel3)

    # Initialize Wizard visibility
    if ($Success) {
        Write-Log "Hien thi Panel 3 (Success)"
        $panel3.Visible = $true
    } else {
        Write-Log "Hien thi Panel 1 (Start)"
        $panel1.Visible = $true
    }

    Write-Log "ShowDialog..."
    $result = $form.ShowDialog()
    Write-Log "ShowDialog ket thuc voi ket qua: $result"

    if ($result -ne [System.Windows.Forms.DialogResult]::OK -and !$Success) {
        $tempFile = "$env:TEMP\hr_tool_setup_paths.txt"
        $utf8NoBOM = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($tempFile, "CANCEL|CANCEL", $utf8NoBOM)
        Write-Log "Ghi file tam CANCEL do nguon dung dong Form"
    }
} catch {
    Write-Log "ERROR: $_"
    Write-Log "STACK TRACE: $($_.ScriptStackTrace)"
    Write-Error $_
    $logFile = "$env:TEMP\hr_tool_setup_error.txt"
    $_ | Out-File -FilePath $logFile -Encoding utf8
    exit 1
}
