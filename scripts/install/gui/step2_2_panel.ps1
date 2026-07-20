param($form, $globalState)

$panel = New-Object System.Windows.Forms.Panel
$panel.Size = New-Object System.Drawing.Size(520, 440)
$panel.Location = New-Object System.Drawing.Point(10, 10)

# Progress
$p2_2Progress = New-Object System.Windows.Forms.Label
$p2_2Progress.Text = "Bước 2/3: Chọn thư mục chứa CV"
$p2_2Progress.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$p2_2Progress.ForeColor = [System.Drawing.Color]::Gray
$p2_2Progress.Location = New-Object System.Drawing.Point(10, 10)
$p2_2Progress.Size = New-Object System.Drawing.Size(400, 20)
$panel.Controls.Add($p2_2Progress)

# Title
$p2_2Title = New-Object System.Windows.Forms.Label
$p2_2Title.Text = "Đường dẫn thư mục CV"
$p2_2Title.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$p2_2Title.ForeColor = [System.Drawing.Color]::FromArgb(30, 61, 89)
$p2_2Title.Location = New-Object System.Drawing.Point(10, 35)
$p2_2Title.Size = New-Object System.Drawing.Size(500, 30)
$panel.Controls.Add($p2_2Title)

# Desc
$p2_2Desc = New-Object System.Windows.Forms.Label
$p2_2Desc.Text = "Vui lòng chọn thư mục chứa CV. Bạn NÊN chọn một thư mục bên trong Google Drive (ổ I:) để lấy link trực tiếp."
$p2_2Desc.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
$p2_2Desc.ForeColor = [System.Drawing.Color]::FromArgb(108, 117, 125)
$p2_2Desc.Location = New-Object System.Drawing.Point(10, 75)
$p2_2Desc.Size = New-Object System.Drawing.Size(500, 40)
$panel.Controls.Add($p2_2Desc)

# Input Label
$p2_2InputLabel = New-Object System.Windows.Forms.Label
$p2_2InputLabel.Text = "Thư mục CV của bạn:"
$p2_2InputLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$p2_2InputLabel.Location = New-Object System.Drawing.Point(10, 130)
$p2_2InputLabel.Size = New-Object System.Drawing.Size(400, 20)
$panel.Controls.Add($p2_2InputLabel)

# Textbox
$p2_2Txt = New-Object System.Windows.Forms.TextBox
$p2_2Txt.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$p2_2Txt.Location = New-Object System.Drawing.Point(10, 155)
$p2_2Txt.Size = New-Object System.Drawing.Size(370, 25)
$panel.Controls.Add($p2_2Txt)
$globalState.P2_2Txt = $p2_2Txt

# Browse Button
$p2_2BtnBrowse = New-Object System.Windows.Forms.Button
$p2_2BtnBrowse.Text = "Duyệt..."
$p2_2BtnBrowse.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$p2_2BtnBrowse.Location = New-Object System.Drawing.Point(390, 154)
$p2_2BtnBrowse.Size = New-Object System.Drawing.Size(100, 27)
$p2_2BtnBrowse.add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Chọn thư mục chứa file CV của bạn"
    $dialog.SelectedPath = $p2_2Txt.Text
    if ($dialog.ShowDialog() -eq "OK") {
        $p2_2Txt.Text = $dialog.SelectedPath
    }
})
$panel.Controls.Add($p2_2BtnBrowse)

# Drive Label Label
$p2_2LabelName = New-Object System.Windows.Forms.Label
$p2_2LabelName.Text = "Tên hiển thị ổ đĩa ảo (Label):"
$p2_2LabelName.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$p2_2LabelName.Location = New-Object System.Drawing.Point(10, 195)
$p2_2LabelName.Size = New-Object System.Drawing.Size(400, 20)
$panel.Controls.Add($p2_2LabelName)

# Drive Label Textbox
$p2_2TxtName = New-Object System.Windows.Forms.TextBox
$p2_2TxtName.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$p2_2TxtName.Location = New-Object System.Drawing.Point(10, 220)
$p2_2TxtName.Size = New-Object System.Drawing.Size(370, 25)
$p2_2TxtName.Text = "Google Shared with me"
$panel.Controls.Add($p2_2TxtName)

# Auto-update virtual drive label on path change
$p2_2Txt.add_TextChanged({
    $path = $p2_2Txt.Text.Trim().TrimEnd('\').TrimEnd('/')
    if ($path) {
        try {
            $folderName = Split-Path -Leaf $path
            if ($folderName -and $folderName -notmatch '^[a-zA-Z]:\\?$') {
                $p2_2TxtName.Text = $folderName
            }
        } catch {}
    }
})

# Manage Drives Button
$p2_2BtnManage = New-Object System.Windows.Forms.Button
$p2_2BtnManage.Text = "Xóa ổ đĩa ảo cũ..."
$p2_2BtnManage.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$p2_2BtnManage.Location = New-Object System.Drawing.Point(390, 219)
$p2_2BtnManage.Size = New-Object System.Drawing.Size(120, 27)
$p2_2BtnManage.add_Click({
    $subForm = New-Object System.Windows.Forms.Form
    $subForm.Text = "Quản lý và Xóa ổ đĩa ảo"
    $subForm.Size = New-Object System.Drawing.Size(460, 360)
    $subForm.StartPosition = "CenterParent"
    $subForm.FormBorderStyle = "FixedDialog"
    $subForm.MaximizeBox = $false
    $subForm.MinimizeBox = $false
    $subForm.BackColor = [System.Drawing.Color]::FromArgb(248, 249, 250)

    $subLabel = New-Object System.Windows.Forms.Label
    $subLabel.Text = "Chọn các ổ đĩa ảo muốn xóa (Click chuột vào ô chọn):"
    $subLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $subLabel.Location = New-Object System.Drawing.Point(10, 10)
    $subLabel.Size = New-Object System.Drawing.Size(420, 20)
    $subForm.Controls.Add($subLabel)

    $listBox = New-Object System.Windows.Forms.CheckedListBox
    $listBox.Location = New-Object System.Drawing.Point(10, 35)
    $listBox.Size = New-Object System.Drawing.Size(420, 200)
    $listBox.Font = New-Object System.Drawing.Font("Consolas", 9.5)
    $subForm.Controls.Add($listBox)

    $loadDrives = {
        $listBox.Items.Clear()
        $lines = subst
        foreach ($line in $lines) {
            if ($line.Contains(" => ")) {
                $parts = $line -split " => "
                $driveRaw = $parts[0].Trim()
                $driveLetter = $driveRaw.Substring(0, 2)
                $targetPath = $parts[1].Trim()
                $listBox.Items.Add("$driveLetter -> $targetPath") | Out-Null
            }
        }
    }
    & $loadDrives

    $btnDel = New-Object System.Windows.Forms.Button
    $btnDel.Text = "Xóa ổ đĩa đã chọn"
    $btnDel.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
    $btnDel.BackColor = [System.Drawing.Color]::FromArgb(220, 53, 69)
    $btnDel.ForeColor = [System.Drawing.Color]::White
    $btnDel.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btnDel.Location = New-Object System.Drawing.Point(260, 260)
    $btnDel.Size = New-Object System.Drawing.Size(170, 35)
    $btnDel.add_Click({
        [string[]]$checkedItems = @()
        foreach ($item in $listBox.CheckedItems) {
            $checkedItems += $item.ToString()
        }
        
        if ($checkedItems.Count -eq 0) {
            [System.Windows.Forms.MessageBox]::Show($subForm, "Vui lòng chọn ít nhất một ổ đĩa để xóa.", "Thông báo", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            return
        }
        
        foreach ($item in $checkedItems) {
            $drive = $item.Substring(0, 2)
            subst $drive /d 2>$null | Out-Null
        }
        
        [System.Windows.Forms.MessageBox]::Show($subForm, "Đã xóa thành công các ổ đĩa đã chọn.", "Thành công", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        & $loadDrives
    })
    $subForm.Controls.Add($btnDel)

    $btnClose = New-Object System.Windows.Forms.Button
    $btnClose.Text = "Đóng"
    $btnClose.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
    $btnClose.Location = New-Object System.Drawing.Point(10, 260)
    $btnClose.Size = New-Object System.Drawing.Size(100, 35)
    $btnClose.add_Click({
        $subForm.Close()
    })
    $subForm.Controls.Add($btnClose)

    $subForm.ShowDialog()
})
$panel.Controls.Add($p2_2BtnManage)

# Drive Icon Label
$p2_2LabelIcon = New-Object System.Windows.Forms.Label
$p2_2LabelIcon.Text = "Biểu tượng ổ đĩa ảo (Icon):"
$p2_2LabelIcon.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$p2_2LabelIcon.Location = New-Object System.Drawing.Point(10, 255)
$p2_2LabelIcon.Size = New-Object System.Drawing.Size(400, 20)
$panel.Controls.Add($p2_2LabelIcon)

# Drive Icon ComboBox
$p2_2ComboIcon = New-Object System.Windows.Forms.ComboBox
$p2_2ComboIcon.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$p2_2ComboIcon.Location = New-Object System.Drawing.Point(10, 280)
$p2_2ComboIcon.Size = New-Object System.Drawing.Size(370, 25)
$p2_2ComboIcon.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$p2_2ComboIcon.Items.Add("Mặc định (Hình ổ đĩa)") | Out-Null
$p2_2ComboIcon.Items.Add("Google Drive") | Out-Null
$p2_2ComboIcon.Items.Add("Thư mục (Folder)") | Out-Null
$p2_2ComboIcon.Items.Add("Đám mây (Cloud)") | Out-Null
$p2_2ComboIcon.Items.Add("Tùy chỉnh (.ico)...") | Out-Null
$p2_2ComboIcon.SelectedIndex = 0
$panel.Controls.Add($p2_2ComboIcon)

# Drive Icon Browse Button
$p2_2BtnIconBrowse = New-Object System.Windows.Forms.Button
$p2_2BtnIconBrowse.Text = "Chọn Icon..."
$p2_2BtnIconBrowse.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$p2_2BtnIconBrowse.Location = New-Object System.Drawing.Point(390, 279)
$p2_2BtnIconBrowse.Size = New-Object System.Drawing.Size(120, 27)
$p2_2BtnIconBrowse.Enabled = $false
$p2_2ComboIcon.add_SelectedIndexChanged({
    $p2_2BtnIconBrowse.Enabled = ($p2_2ComboIcon.SelectedIndex -eq 4)
})
$p2_2CustomIconPath = ""
$p2_2BtnIconBrowse.add_Click({
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = "Icon files (*.ico)|*.ico"
    $dialog.Title = "Chọn file biểu tượng (.ico)"
    if ($dialog.ShowDialog() -eq "OK") {
        $p2_2CustomIconPath = $dialog.FileName
        $p2_2BtnIconBrowse.Text = [System.IO.Path]::GetFileName($dialog.FileName)
    }
})
$panel.Controls.Add($p2_2BtnIconBrowse)

# Skip Checkbox
$p2_2SkipBox = New-Object System.Windows.Forms.CheckBox
$p2_2SkipBox.Text = "Bỏ qua bước liên kết ổ đĩa ảo (Dùng thư mục CV mặc định của tool)"
$p2_2SkipBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$p2_2SkipBox.Location = New-Object System.Drawing.Point(10, 320)
$p2_2SkipBox.Size = New-Object System.Drawing.Size(480, 25)
$p2_2SkipBox.add_CheckedChanged({
    $p2_2Txt.Enabled = -not $p2_2SkipBox.Checked
    $p2_2BtnBrowse.Enabled = -not $p2_2SkipBox.Checked
    $p2_2TxtName.Enabled = -not $p2_2SkipBox.Checked
    $p2_2ComboIcon.Enabled = -not $p2_2SkipBox.Checked
    $p2_2BtnIconBrowse.Enabled = (-not $p2_2SkipBox.Checked) -and ($p2_2ComboIcon.SelectedIndex -eq 4)
})
$panel.Controls.Add($p2_2SkipBox)

# Back Button
$p2_2BtnBack = New-Object System.Windows.Forms.Button
$p2_2BtnBack.Text = "Quay lại"
$p2_2BtnBack.Font = New-Object System.Drawing.Font("Segoe UI", 9.5)
$p2_2BtnBack.Location = New-Object System.Drawing.Point(50, 365)
$p2_2BtnBack.Size = New-Object System.Drawing.Size(120, 35)
$p2_2BtnBack.add_Click({
    & $globalState.ShowPanel $globalState.Panel2_1
})
$panel.Controls.Add($p2_2BtnBack)

# Install Button
$p2_2BtnInstall = New-Object System.Windows.Forms.Button
$p2_2BtnInstall.Text = "Hoàn tất thiết lập"
$p2_2BtnInstall.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$p2_2BtnInstall.Location = New-Object System.Drawing.Point(300, 362)
$p2_2BtnInstall.Size = New-Object System.Drawing.Size(180, 40)
$p2_2BtnInstall.BackColor = [System.Drawing.Color]::FromArgb(40, 167, 69)
$p2_2BtnInstall.ForeColor = [System.Drawing.Color]::White
$p2_2BtnInstall.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$p2_2BtnInstall.add_Click({
    $repoDir = $globalState.RepoDir
    $cvDir = if ($p2_2SkipBox.Checked) { "SKIP" } else { $p2_2Txt.Text.Trim() }
    $driveLabel = $p2_2TxtName.Text.Trim()
    if ([string]::IsNullOrEmpty($driveLabel)) { $driveLabel = "Google Shared with me" }
    
    # Get selected icon
    $driveIcon = "default"
    if ($p2_2ComboIcon.SelectedIndex -eq 1) {
        $driveIcon = "gdrive"
    } elseif ($p2_2ComboIcon.SelectedIndex -eq 2) {
        $driveIcon = "folder"
    } elseif ($p2_2ComboIcon.SelectedIndex -eq 3) {
        $driveIcon = "cloud"
    } elseif ($p2_2ComboIcon.SelectedIndex -eq 4 -and $p2_2CustomIconPath) {
        $driveIcon = $p2_2CustomIconPath
    }
    
    if ($cvDir -ne "SKIP" -and [string]::IsNullOrEmpty($cvDir)) {
        [System.Windows.Forms.MessageBox]::Show($form, "Vui lòng chọn đường dẫn CV hoặc click bỏ qua.", "Cảnh báo", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }
    $form.Hide()
    $tempFile = "$env:TEMP\hr_tool_setup_paths.txt"
    $utf8NoBOM = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($tempFile, "$repoDir|$cvDir|$driveLabel|$driveIcon", $utf8NoBOM)
    $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.Close()
})
$panel.Controls.Add($p2_2BtnInstall)

return $panel
