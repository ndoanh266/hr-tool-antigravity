@echo off
setlocal enabledelayedexpansion

set "TARGET_FILE=%USERPROFILE%\.gemini\GEMINI.md"
set "RULE_PATH=C:/mkt/INSTRUCTIONS_FOR_AI.md"
set "RULE_LINE=@%RULE_PATH%"

echo Checking for global Gemini configuration in %TARGET_FILE%...

if not exist "%TARGET_FILE%" (
    echo [ERROR] Not found %TARGET_FILE%!
    echo Please make sure Antigravity is installed and initialized.
    pause
    exit /b 1
)

:: Check if the rule is already present in GEMINI.md
findstr /C:"%RULE_LINE%" "%TARGET_FILE%" >nul
if %errorlevel% equ 0 (
    echo [INFO] Rule is already imported in GEMINI.md.
) else (
    echo.>> "%TARGET_FILE%"
    echo # HR Tool Antigravity Rules>> "%TARGET_FILE%"
    echo %RULE_LINE%>> "%TARGET_FILE%"
    echo [SUCCESS] Successfully imported HR Tool rules into %TARGET_FILE%.
)

pause
