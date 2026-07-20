@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: 1. Check if Windows XP
ver | findstr /i "5.1." >nul
if %errorlevel% equ 0 (
    echo ========================================================
    echo  [LOI] WINDOWS XP KHONG DUOC HO TRO
    echo ========================================================
    echo Tool HR Tool Antigravity doi hoi Windows 10/11 hoac Windows 7 co cap nhat.
    echo Phien ban Windows XP cua ban da qua cu, khong the tiep tuc cai dat.
    pause
    exit /b 1
)

:: 2. Check if Git and Python are installed
set "MISSING_DEP=0"
where git >nul 2>nul
if %errorlevel% neq 0 set "MISSING_DEP=1"
where python >nul 2>nul
if %errorlevel% neq 0 set "MISSING_DEP=1"

:: Check if PowerShell version is modern [PS 3.0+]
powershell -Command "if ($PSVersionTable.PSVersion.Major -lt 3) { exit 1 } else { exit 0 }" >nul 2>nul
if %errorlevel% neq 0 set "MISSING_DEP=1"

:: 3. Request elevation if dependencies are missing
if "!MISSING_DEP!"=="1" (
    net session >nul 2>&1
    if %errorlevel% neq 0 (
        echo ========================================================
        echo  [THONG BAO] CAN QUYEN ADMIN DE THIET LAP MOI TRUONG
        echo ========================================================
        echo Phat hien may tinh cua ban thieu moi truong chay tool [Python, Git hoac PowerShell].
        echo Dang yeu cau quyen Administrator de tu dong tai va cai dat ngam cac thanh phan con thieu...
        echo.
        powershell -Command "Start-Process '%~dpnx0' -Verb RunAs"
        exit /b 0
    )
)

:: 4. Run Silent Installers for missing dependencies (Requires Admin rights if they were missing)
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo ========================================================
    echo  [MOI TRUONG] TIEN TRINH CAI DAT: GIT
    echo ========================================================
    echo [*] Buoc 1: Dang tai bo cai dat Git tu may chu internet...
    call :download "https://github.com/git-for-windows/git/releases/download/v2.41.0.windows.1/Git-2.41.0-64-bit.exe" "%TEMP%\git_setup.exe"
    echo [*] Buoc 2: Dang chay cai dat Git tu dong, am tham...
    echo    [Quat trinh nay se mat khoang 1 den 2 phut. Vui long cho...]
    "%TEMP%\git_setup.exe" /VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS
    echo [OK] Da cai dat Git thanh cong vao he thong!
    echo.
    set "PATH=%PATH%;C:\Program Files\Git\cmd"
)

where python >nul 2>nul
if %errorlevel% neq 0 (
    echo ========================================================
    echo  [MOI TRUONG] TIEN TRINH CAI DAT: PYTHON 3
    echo ========================================================
    echo [*] Buoc 1: Dang tai bo cai dat Python 3.10 tu internet...
    call :download "https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe" "%TEMP%\python_setup.exe"
    echo [*] Buoc 2: Dang chay cai dat Python am tham tren o dia...
    echo    [Quat trinh nay se mat tu 2 den 3 phut. Vui long kien nhan cho...]
    "%TEMP%\python_setup.exe" /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
    echo [OK] Da cai dat Python 3.10 va tu dong cau hinh duong dan thanh cong!
    echo.
    set "PATH=%PATH%;C:\Program Files\Python310;C:\Program Files\Python310\Scripts"
)

:: Check PowerShell / .NET on Windows 7
powershell -Command "if ($PSVersionTable.PSVersion.Major -lt 3) { exit 1 } else { exit 0 }" >nul 2>nul
if %errorlevel% neq 0 (
    echo ========================================================
    echo  [MOI TRUONG] TIEN TRINH CAP NHAT POWERSHELL / .NET
    echo ========================================================
    echo Phat hien phien ban Windows 7 cua ban chua cap nhat moi truong he thong.
    echo.
    echo [*] Dang tai va cai dat .NET Framework 4.8 ngam...
    call :download "https://go.microsoft.com/fwlink/?linkid=2085155" "%TEMP%\ndp48_setup.exe"
    echo    Dang tien hanh setup .NET [vui long doi trong vai phut]...
    "%TEMP%\ndp48_setup.exe" /q /norestart
    echo [OK] Da cai dat xong .NET Framework.
    echo.
    
    echo [*] Dang tai va nang cap Windows Management Framework 5.1 [PowerShell]...
    call :download "https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-A28C-2D1DAC6844E8/Win7AndW2K8R2-KB3191566-x64.zip" "%TEMP%\wmf51.zip"
    powershell -Command "Expand-Archive -Path '%TEMP%\wmf51.zip' -DestinationPath '%TEMP%\wmf51' -Force"
    echo    Dang chay trinh nang cap PowerShell...
    wusa.exe "%TEMP%\wmf51\Win7AndW2K8R2-KB3191566-x64.msu" /quiet /norestart
    echo [OK] Da dang ky cap nhat phien ban moi.
    echo.
    
    echo ========================================================
    echo  [YEU CAU] KHOI DONG LAI MAY TINH [REBOOT]
    echo ========================================================
    echo Windows yeu cau khoi dong lai de hoan tat cap nhat he thong.
    echo Vui long khoi dong lai may tinh cua ban, sau do click dup file:
    echo     install_rules.bat
    echo de tiep tuc setup giao dien!
    echo ========================================================
    pause
    exit /b 0
)

:: 5. Check and retrieve / update installer files from GitHub
set "CURRENT_DIR=%~dp0"
set "CURRENT_DIR=%CURRENT_DIR:~0,-1%"

:: Always change directory to the batch file's folder to prevent working directory issues (like C:\Windows\System32 when run as admin)
cd /d "%CURRENT_DIR%"

if exist "%CURRENT_DIR%\hr-tool-antigravity" (
    set "REPO_DIR=%CURRENT_DIR%\hr-tool-antigravity"
) else (
    set "REPO_DIR=%CURRENT_DIR%"
)

echo ========================================================
echo  [HE THONG] KIEM TRA & CAP NHAT HR TOOL ANTIGRAVITY
echo ========================================================
echo Dang kiem tra va cap nhat phien ban moi nhat tu GitHub...
echo.

where git >nul 2>nul
if %errorlevel% equ 0 (
    if exist "!REPO_DIR!\.git" (
        echo [*] Dang cap nhat ma nguon qua Git...
        pushd "!REPO_DIR!"
        git fetch origin main >nul 2>&1
        git pull origin main
        popd
    ) else if exist "%CURRENT_DIR%\.git" (
        echo [*] Dang cap nhat ma nguon qua Git...
        pushd "%CURRENT_DIR%"
        git fetch origin main >nul 2>&1
        git pull origin main
        popd
    ) else (
        for %%I in ("%CURRENT_DIR%") do set "DIR_NAME=%%~nxI"
        if "!DIR_NAME!"=="hr-tool-antigravity" (
            git init
            git remote add origin https://github.com/ndoanh266/hr-tool-antigravity.git
            git fetch origin
            git checkout -f main
        ) else (
            git clone https://github.com/ndoanh266/hr-tool-antigravity.git "%CURRENT_DIR%\hr-tool-antigravity"
            set "REPO_DIR=%CURRENT_DIR%\hr-tool-antigravity"
        )
    )
) else (
    echo [*] Dang tai ma nguon dang ZIP tu GitHub...
    call :download "https://github.com/ndoanh266/hr-tool-antigravity/archive/refs/heads/main.zip" "%TEMP%\hr-tool.zip"
    if exist "%TEMP%\hr-tool.zip" (
        echo [*] Dang giai nen bo cai dat...
        powershell -Command "if (Test-Path '%TEMP%\hr-tool-extracted') { Remove-Item -Path '%TEMP%\hr-tool-extracted' -Recurse -Force } New-Item -ItemType Directory -Path '%TEMP%\hr-tool-extracted' -Force | Out-Null; Expand-Archive -Path '%TEMP%\hr-tool.zip' -DestinationPath '%TEMP%\hr-tool-extracted' -Force"
        
        for %%I in ("%CURRENT_DIR%") do set "DIR_NAME=%%~nxI"
        if "!DIR_NAME!"=="hr-tool-antigravity" (
            echo [*] Dang copy tep vao thu muc hien tai...
            xcopy /E /Y /I "%TEMP%\hr-tool-extracted\hr-tool-antigravity-main\*" "%CURRENT_DIR%\" >nul
        ) else (
            echo [*] Dang tao va copy tep vao thu muc hr-tool-antigravity...
            xcopy /E /Y /I "%TEMP%\hr-tool-extracted\hr-tool-antigravity-main\*" "%CURRENT_DIR%\hr-tool-antigravity\" >nul
            set "REPO_DIR=%CURRENT_DIR%\hr-tool-antigravity"
        )
        
        del /q "%TEMP%\hr-tool.zip"
        rmdir /s /q "%TEMP%\hr-tool-extracted"
    ) else (
        echo [CANH BAO] Khong thể tai xuong ma nguon tu GitHub. Se su dung phien ban hien co...
    )
)
echo [OK] Dong bo phien ban thanh cong!
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "!REPO_DIR!\scripts\install\install_rules.ps1"
exit /b 0

:: Downloader helper function
:download
where curl >nul 2>nul
if %errorlevel% equ 0 (
    curl -L -o "%~2" "%~1"
    exit /b 0
)
where bitsadmin >nul 2>nul
if %errorlevel% equ 0 (
    bitsadmin /transfer myDownloadJob /download /priority foreground "%~1" "%~2"
    exit /b 0
)
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = 3072; (New-Object System.Net.WebClient).DownloadFile('%~1', '%~2')"
exit /b 0
