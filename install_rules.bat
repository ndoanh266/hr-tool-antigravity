@echo off
setlocal enabledelayedexpansion

set "TARGET_FILE=%USERPROFILE%\.gemini\GEMINI.md"
set "REPO_DIR=C:\mkt\hr-tool-antigravity"
set "RULE_PATH=C:/mkt/hr-tool-antigravity/INSTRUCTIONS_FOR_AI.md"
set "RULE_LINE=@%RULE_PATH%"
set "REPO_URL=https://github.com/ndoanh266/hr-tool-antigravity.git"

echo ===================================================
echo   HR Tool Antigravity - Auto Installer & Updater   
echo ===================================================
echo.

:: Check if git is installed
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [WARNING] Git is not installed or not in PATH.
    echo If the folder is already downloaded, we will proceed with registering rules.
    echo.
) else (
    :: Check if repository directory exists
    if not exist "%REPO_DIR%" (
        echo [INFO] Target directory %REPO_DIR% does not exist.
        echo Cloning repository from GitHub...
        git clone "%REPO_URL%" "%REPO_DIR%"
        if !errorlevel! neq 0 (
            echo [ERROR] Failed to clone repository. Please check your internet connection.
            pause
            exit /b 1
        )
    ) else (
        echo [INFO] Target directory %REPO_DIR% already exists.
        echo Checking for updates from GitHub...
        pushd "%REPO_DIR%"
        git pull
        popd
    )
)

echo.
echo Registering rules in global Gemini configuration (%TARGET_FILE%)...

if not exist "%TARGET_FILE%" (
    echo [ERROR] Not found %TARGET_FILE%!
    echo Please make sure Antigravity is installed and initialized.
    pause
    exit /b 1
)

:: Check if the rule is already present in GEMINI.md
findstr /C:"%RULE_LINE%" "%TARGET_FILE%" >nul
if %errorlevel% equ 0 (
    echo [INFO] Rule is already registered in GEMINI.md.
) else (
    echo.>> "%TARGET_FILE%"
    echo # HR Tool Antigravity Rules>> "%TARGET_FILE%"
    echo %RULE_LINE%>> "%TARGET_FILE%"
    echo [SUCCESS] Successfully registered rules in %TARGET_FILE%.
)

echo.
echo Installation / Update completed!
pause
