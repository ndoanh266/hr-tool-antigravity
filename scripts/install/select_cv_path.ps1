Add-Type -AssemblyName System.Windows.Forms
$d = New-Object System.Windows.Forms.FolderBrowserDialog
$d.Description = 'Chon thu muc chua cac file CV cua ban (Vi du: Thu muc Google Drive dong bo)'
$d.ShowNewFolderButton = $true
$w = New-Object System.Windows.Forms.Form
$w.TopMost = $true
if ($d.ShowDialog($w) -eq 'OK') {
    Write-Output $d.SelectedPath
} else {
    Write-Output 'CANCEL'
}
