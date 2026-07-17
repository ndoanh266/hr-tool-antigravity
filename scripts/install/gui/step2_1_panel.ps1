param($form, $globalState)

$panel = New-Object System.Windows.Forms.Panel
$panel.Size = New-Object System.Drawing.Size(520, 440)
$panel.Location = New-Object System.Drawing.Point(10, 10)

# Progress
$p2_1Progress = New-Object System.Windows.Forms.Label
$p2_1Progress.Text = "Bước 2/3: Kiểm tra Google Drive"
$p2_1Progress.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$p2_1Progress.ForeColor = [System.Drawing.Color]::Gray
$p2_1Progress.Location = New-Object System.Drawing.Point(10, 10)
$p2_1Progress.Size = New-Object System.Drawing.Size(400, 20)
$panel.Controls.Add($p2_1Progress)

# Title
$p2_1Title = New-Object System.Windows.Forms.Label
$p2_1Title.Text = "Ứng dụng Google Drive"
$p2_1Title.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$p2_1Title.ForeColor = [System.Drawing.Color]::FromArgb(30, 61, 89)
$p2_1Title.Location = New-Object System.Drawing.Point(10, 35)
$p2_1Title.Size = New-Object System.Drawing.Size(500, 30)
$panel.Controls.Add($p2_1Title)

# Status Label
$p2_1Status = New-Object System.Windows.Forms.Label
$p2_1Status.Text = "Trạng thái: Đang kiểm tra..."
$p2_1Status.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$p2_1Status.Location = New-Object System.Drawing.Point(10, 80)
$p2_1Status.Size = New-Object System.Drawing.Size(500, 25)
$panel.Controls.Add($p2_1Status)
$globalState.P2_1Status = $p2_1Status

# Explanation Label
$p2_1Explanation = New-Object System.Windows.Forms.Label
$p2_1Explanation.Text = "Mục đích: Khi có ứng dụng Google Drive trên Windows, HR Tool có thể tự động lấy link chia sẻ của file CV trực tiếp trên máy tính của bạn mà KHÔNG cần phải sử dụng hay cấu hình bất kỳ file khóa JSON bảo mật phức tạp nào."
$p2_1Explanation.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
$p2_1Explanation.ForeColor = [System.Drawing.Color]::FromArgb(108, 117, 125)
$p2_1Explanation.Location = New-Object System.Drawing.Point(10, 115)
$p2_1Explanation.Size = New-Object System.Drawing.Size(500, 65)
$panel.Controls.Add($p2_1Explanation)

# Install Button
$p2_1BtnInstall = New-Object System.Windows.Forms.Button
$p2_1BtnInstall.Text = "Tự động Tải & Cài đặt Google Drive"
$p2_1BtnInstall.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$p2_1BtnInstall.Location = New-Object System.Drawing.Point(100, 195)
$p2_1BtnInstall.Size = New-Object System.Drawing.Size(320, 45)
$p2_1BtnInstall.BackColor = [System.Drawing.Color]::FromArgb(40, 167, 69)
$p2_1BtnInstall.ForeColor = [System.Drawing.Color]::White
$p2_1BtnInstall.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$p2_1BtnInstall.add_Click({
    $p2_1Status.Text = "Trạng thái: Đang tải trình cài đặt Google Drive (khoảng 300MB)..."
    $p2_1Status.ForeColor = [System.Drawing.Color]::Blue
    $form.Refresh()
    try {
        Import-Module BitsTransfer
        Start-BitsTransfer -Source "https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe" -Destination "$env:TEMP\GoogleDriveSetup.exe"
        $p2_1Status.Text = "Trạng thái: Đang chạy trình cài đặt..."
        $form.Refresh()
        $process = Start-Process -FilePath "$env:TEMP\GoogleDriveSetup.exe" -Wait -PassThru
        
        $isInstalled = Test-Path "C:\Program Files\Google\Drive File Stream"
        if ($isInstalled) {
            $p2_1Status.Text = "Trạng thái: CÀI ĐẶT Google Drive THÀNH CÔNG!"
            $p2_1Status.ForeColor = [System.Drawing.Color]::FromArgb(40, 167, 69)
            $p2_1BtnInstall.Visible = $false
            $p2_1BtnNext.Text = "Tiếp tục"
        } else {
            $p2_1Status.Text = "Trạng thái: Chưa phát hiện Google Drive (có thể bạn đã hủy cài đặt)."
            $p2_1Status.ForeColor = [System.Drawing.Color]::Red
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show($form, "Lỗi khi tải/cài đặt Google Drive: $_", "Lỗi", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        $p2_1Status.Text = "Trạng thái: Lỗi khi tải về. Vui lòng cài đặt thủ công."
        $p2_1Status.ForeColor = [System.Drawing.Color]::Red
    }
})
$panel.Controls.Add($p2_1BtnInstall)
$globalState.P2_1BtnInstall = $p2_1BtnInstall

# Back Button
$p2_1BtnBack = New-Object System.Windows.Forms.Button
$p2_1BtnBack.Text = "Quay lại"
$p2_1BtnBack.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
$p2_1BtnBack.Location = New-Object System.Drawing.Point(50, 350)
$p2_1BtnBack.Size = New-Object System.Drawing.Size(120, 35)
$p2_1BtnBack.add_Click({
    & $globalState.ShowPanel $globalState.Panel1
})
$panel.Controls.Add($p2_1BtnBack)

# Next Button
$p2_1BtnNext = New-Object System.Windows.Forms.Button
$p2_1BtnNext.Text = "Tiếp tục"
$p2_1BtnNext.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$p2_1BtnNext.Location = New-Object System.Drawing.Point(300, 347)
$p2_1BtnNext.Size = New-Object System.Drawing.Size(180, 40)
$p2_1BtnNext.BackColor = [System.Drawing.Color]::FromArgb(0, 123, 255)
$p2_1BtnNext.ForeColor = [System.Drawing.Color]::White
$p2_1BtnNext.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$p2_1BtnNext.add_Click({
    $gDriveLetter = "I"
    foreach ($d in [System.IO.DriveInfo]::GetDrives()) {
        if ($d.DriveType -eq "Network" -or $d.DriveType -eq "Fixed") {
            if ($d.VolumeLabel -like "*Google*" -or (Test-Path "$($d.Name)My Drive")) {
                $gDriveLetter = $d.Name.Replace(":\", "")
                break
            }
        }
    }
    $globalState.P2_2Txt.Text = "$($gDriveLetter):\My Drive"
    & $globalState.ShowPanel $globalState.Panel2_2
})
$panel.Controls.Add($p2_1BtnNext)
$globalState.P2_1BtnNext = $p2_1BtnNext

return $panel
