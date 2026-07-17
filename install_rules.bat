@echo off
setlocal enabledelayedexpansion

set "TARGET_FILE=%USERPROFILE%\.gemini\GEMINI.md"
set "REPO_URL=https://github.com/ndoanh266/hr-tool-antigravity.git"

echo ===================================================
echo   HR Tool Antigravity - Auto Installer & Updater   
echo ===================================================
echo.

:: Open Folder Browser Dialog GUI for initial storage selection
echo [INFO] Dang khoi dong GUI lua chon thu muc luu tru...
for /f "usebackq delims=" %%I in (`powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.FolderBrowserDialog; $f.Description = 'Chon thu muc cha de luu tru HR Tool (Vi du: C:\mkt)'; $f.ShowNewFolderButton = $true; if ($f.ShowDialog() -eq 'OK') { $f.SelectedPath } else { 'CANCEL' }"`) do (
    set "PARENT_DIR=%%I"
)

if "%PARENT_DIR%"=="CANCEL" (
    echo [WARNING] Nguoi dung da huy qua trinh cai dat.
    powershell -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; [System.Windows.Forms.MessageBox]::Show('Ban da huy qua trinh setup.', 'HR Tool Installer', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)"
    exit /b 0
)

set "REPO_DIR=%PARENT_DIR%\hr-tool-antigravity"
set "RULE_PATH=!REPO_DIR:\=/!/INSTRUCTIONS_FOR_AI.md"
set "RULE_LINE=@!RULE_PATH!"

echo [INFO] Thu muc luu tru da chon: !REPO_DIR!
echo.

:: Check if git is installed
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [WARNING] Git is not installed or not in PATH.
    echo If the folder is already downloaded, we will proceed with registering rules.
    echo.
) else (
    :: Check if repository directory exists
    if not exist "!REPO_DIR!" (
        echo [INFO] Thu muc dich !REPO_DIR! chua ton tai.
        echo Dang clone repository tu GitHub...
        git clone "%REPO_URL%" "!REPO_DIR!"
        if !errorlevel! neq 0 (
            echo [ERROR] Failed to clone repository. Please check your internet connection.
            powershell -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; [System.Windows.Forms.MessageBox]::Show('Loi khi tai repository tu GitHub. Vui long kiem tra ket noi mang.', 'HR Tool Installer', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)"
            pause
            exit /b 1
        )
    ) else (
        echo [INFO] Thu muc !REPO_DIR! da ton tai.
        echo Dang kiem tra cap nhat tu GitHub...
        pushd "!REPO_DIR!"
        git pull
        popd
    )
)

echo.
echo Dang dang ky luat trong cau hinh Gemini toan cuc (%TARGET_FILE%)...

if not exist "%TARGET_FILE%" (
    echo [ERROR] Khong tim thay file %TARGET_FILE%!
    echo Vui long dam bao Antigravity da duoc khoi tao.
    powershell -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; [System.Windows.Forms.MessageBox]::Show('Khong tim thay %TARGET_FILE:\=\\%! Vui long dam bao Antigravity da duoc khoi tao.', 'HR Tool Installer', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)"
    pause
    exit /b 1
)

:: Check if the rule is already present in GEMINI.md
findstr /C:"!RULE_LINE!" "%TARGET_FILE%" >nul
if !errorlevel! equ 0 (
    echo [INFO] Luat da duoc dang ky truoc do trong GEMINI.md.
) else (
    echo.>> "%TARGET_FILE%"
    echo # HR Tool Antigravity Rules>> "%TARGET_FILE%"
    echo !RULE_LINE!>> "%TARGET_FILE%"
    echo [SUCCESS] Dang ky luat thanh cong vao %TARGET_FILE%.
)

echo.
echo Cai dat / Cap nhat hoan tat!
powershell -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null; [System.Windows.Forms.MessageBox]::Show('Cai dat va cấu hình HR Tool thanh cong tai: !REPO_DIR!', 'HR Tool Installer', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)"
pause

