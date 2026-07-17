param($form, $globalState)

$panel = New-Object System.Windows.Forms.Panel
$panel.Size = New-Object System.Drawing.Size(520, 440)
$panel.Location = New-Object System.Drawing.Point(10, 10)

# Progress
$p3Progress = New-Object System.Windows.Forms.Label
$p3Progress.Text = "Bước 3/3: Cài đặt hoàn tất"
$p3Progress.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$p3Progress.ForeColor = [System.Drawing.Color]::FromArgb(40, 167, 69)
$p3Progress.Location = New-Object System.Drawing.Point(10, 10)
$p3Progress.Size = New-Object System.Drawing.Size(400, 20)
$panel.Controls.Add($p3Progress)

# Title
$p3Title = New-Object System.Windows.Forms.Label
$p3Title.Text = "Cài đặt thành công!"
$p3Title.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$p3Title.ForeColor = [System.Drawing.Color]::FromArgb(40, 167, 69)
$p3Title.Location = New-Object System.Drawing.Point(10, 35)
$p3Title.Size = New-Object System.Drawing.Size(500, 35)
$panel.Controls.Add($p3Title)

# Summary Textbox
$p3Summary = New-Object System.Windows.Forms.TextBox
$p3Summary.Multiline = $true
$p3Summary.ReadOnly = $true
$p3Summary.Font = New-Object System.Drawing.Font("Consolas", 10)
$p3Summary.Location = New-Object System.Drawing.Point(10, 90)
$p3Summary.Size = New-Object System.Drawing.Size(500, 220)
$p3Summary.BackColor = [System.Drawing.Color]::White

$mappedLetter = if (![string]::IsNullOrEmpty($globalState.DriveLetter) -and $globalState.DriveLetter -ne "None" -and $globalState.DriveLetter -ne "SKIP") { $globalState.DriveLetter } else { "Không dùng (Dùng thư mục mặc định)" }

$summaryText = @"
==================================================
           THÔNG TIN CẤU HÌNH HR TOOL
==================================================
1. Đường dẫn cài đặt tool:
   $($globalState.RepoDir)

2. Thư mục chứa CV gốc:
   $($globalState.CvDir)

3. Ổ đĩa ảo được ánh xạ:
   $mappedLetter

4. Thiết lập AI:
   Đã đăng ký thành công luồng quy tắc vào file
   GEMINI.md trong máy tính của bạn.
==================================================
Hệ thống đã sẵn sàng sử dụng!
"@
$p3Summary.Text = $summaryText
$panel.Controls.Add($p3Summary)

# Close Button
$p3BtnClose = New-Object System.Windows.Forms.Button
$p3BtnClose.Text = "Đóng"
$p3BtnClose.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$p3BtnClose.Location = New-Object System.Drawing.Point(180, 340)
$p3BtnClose.Size = New-Object System.Drawing.Size(160, 45)
$p3BtnClose.BackColor = [System.Drawing.Color]::FromArgb(0, 123, 255)
$p3BtnClose.ForeColor = [System.Drawing.Color]::White
$p3BtnClose.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$p3BtnClose.add_Click({
    $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Close()
})
$panel.Controls.Add($p3BtnClose)

return $panel
