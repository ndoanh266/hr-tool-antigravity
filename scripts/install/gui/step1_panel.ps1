param($form, $globalState)

$panel = New-Object System.Windows.Forms.Panel
$panel.Size = New-Object System.Drawing.Size(520, 440)
$panel.Location = New-Object System.Drawing.Point(10, 10)

# Progress
$p1Progress = New-Object System.Windows.Forms.Label
$p1Progress.Text = "Bước 1/3: Chọn thư mục cài đặt"
$p1Progress.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$p1Progress.ForeColor = [System.Drawing.Color]::Gray
$p1Progress.Location = New-Object System.Drawing.Point(10, 10)
$p1Progress.Size = New-Object System.Drawing.Size(400, 20)
$panel.Controls.Add($p1Progress)

# Title
$p1Title = New-Object System.Windows.Forms.Label
$p1Title.Text = "Nơi lưu trữ HR Tool"
$p1Title.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$p1Title.ForeColor = [System.Drawing.Color]::FromArgb(30, 61, 89)
$p1Title.Location = New-Object System.Drawing.Point(10, 35)
$p1Title.Size = New-Object System.Drawing.Size(500, 30)
$panel.Controls.Add($p1Title)

# Desc
$p1Desc = New-Object System.Windows.Forms.Label
$p1Desc.Text = "Đây là nơi lưu trữ mã nguồn, các file quy tắc (Rules) va các file thiết đặt của ứng dụng."
$p1Desc.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
$p1Desc.ForeColor = [System.Drawing.Color]::FromArgb(108, 117, 125)
$p1Desc.Location = New-Object System.Drawing.Point(10, 75)
$p1Desc.Size = New-Object System.Drawing.Size(500, 40)
$panel.Controls.Add($p1Desc)

# Input Label
$p1InputLabel = New-Object System.Windows.Forms.Label
$p1InputLabel.Text = "Thư mục cài đặt (Mặc định: C:\mkt):"
$p1InputLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$p1InputLabel.Location = New-Object System.Drawing.Point(10, 140)
$p1InputLabel.Size = New-Object System.Drawing.Size(400, 20)
$panel.Controls.Add($p1InputLabel)

# Textbox
$p1Txt = New-Object System.Windows.Forms.TextBox
$p1Txt.Text = $globalState.RepoDir
$p1Txt.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$p1Txt.Location = New-Object System.Drawing.Point(10, 165)
$p1Txt.Size = New-Object System.Drawing.Size(370, 25)
$panel.Controls.Add($p1Txt)

# Browse Button
$p1BtnBrowse = New-Object System.Windows.Forms.Button
$p1BtnBrowse.Text = "Duyệt..."
$p1BtnBrowse.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$p1BtnBrowse.Location = New-Object System.Drawing.Point(390, 164)
$p1BtnBrowse.Size = New-Object System.Drawing.Size(100, 27)
$p1BtnBrowse.add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Chọn thư mục cài đặt HR Tool"
    $dialog.SelectedPath = $p1Txt.Text
    if ($dialog.ShowDialog() -eq "OK") {
        $p1Txt.Text = $dialog.SelectedPath
    }
})
$panel.Controls.Add($p1BtnBrowse)

# Next Button
$p1BtnNext = New-Object System.Windows.Forms.Button
$p1BtnNext.Text = "Tiếp tục"
$p1BtnNext.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$p1BtnNext.Location = New-Object System.Drawing.Point(180, 260)
$p1BtnNext.Size = New-Object System.Drawing.Size(150, 40)
$p1BtnNext.BackColor = [System.Drawing.Color]::FromArgb(0, 123, 255)
$p1BtnNext.ForeColor = [System.Drawing.Color]::White
$p1BtnNext.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$p1BtnNext.add_Click({
    if ([string]::IsNullOrEmpty($p1Txt.Text.Trim())) {
        [System.Windows.Forms.MessageBox]::Show($form, "Vui lòng nhập đường dẫn cài đặt.", "Cảnh báo", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    $globalState.RepoDir = $p1Txt.Text.Trim()
    
    # Check Google Drive app status and update Panel 2.1 state
    $isInstalled = Test-Path "C:\Program Files\Google\Drive File Stream"
    $statusLbl = $globalState.P2_1Status
    $btnInst = $globalState.P2_1BtnInstall
    $btnNxt = $globalState.P2_1BtnNext
    
    if ($isInstalled) {
        $statusLbl.Text = "Trạng thái: ĐÃ PHÁT HIỆN ứng dụng Google Drive trên máy tính."
        $statusLbl.ForeColor = [System.Drawing.Color]::FromArgb(40, 167, 69)
        $btnInst.Visible = $false
        $btnNxt.Text = "Tiếp tục"
    } else {
        $statusLbl.Text = "Trạng thái: CHƯA CÀI ĐẶT ứng dụng Google Drive."
        $statusLbl.ForeColor = [System.Drawing.Color]::FromArgb(220, 53, 69)
        $btnInst.Visible = $true
        $btnNxt.Text = "Tiếp tục (Không dùng GDrive)"
    }
    
    & $globalState.ShowPanel $globalState.Panel2_1
})
$panel.Controls.Add($p1BtnNext)

return $panel
