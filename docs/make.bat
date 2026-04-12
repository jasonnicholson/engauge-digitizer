@echo off
REM Batch file for Sphinx documentation on Windows.
REM
REM Usage: make.bat [target]
REM Targets: html, clean, livehtml

setlocal enabledelayedexpansion

REM Check for uv command
where uv >nul 2>&1
if errorlevel 1 (
    echo.
    echo Error: uv was not found on PATH.
    echo.
    echo Please install uv: https://docs.astral.sh/uv/getting-started/installation/
    echo.
    exit /b 1
)

if "%1"=="" goto html
if "%1"=="html" goto html
if "%1"=="clean" goto clean
if "%1"=="livehtml" goto livehtml
if "%1"=="help" goto help

echo Unknown target: %1
goto help

:html
echo Building HTML documentation...
uv run --project . sphinx-build -b html source build/html
if errorlevel 1 (
    echo.
    echo ERROR: sphinx-build failed with exit code !errorlevel!
    exit /b !errorlevel!
)
echo.
echo Build finished. The HTML pages are in build\html
goto end

:clean
echo Removing build directory...
if exist build (
    rmdir /s /q build
    echo Build directory removed.
) else (
    echo Build directory does not exist.
)
goto end

:livehtml
echo Starting Sphinx autobuild with live reload...
uv run --project . sphinx-autobuild source build/html --open-browser
goto end

:help
echo Sphinx documentation build helper for Windows.
echo.
echo Usage: make.bat [target]
echo.
echo Targets:
echo   html       - Build HTML documentation (default)
echo   clean      - Remove build directory
echo   livehtml   - Build and serve with live reload (sphinx-autobuild)
echo   help       - Show this help message
echo.
echo Examples:
echo   make.bat
echo   make.bat html
echo   make.bat clean
echo   make.bat livehtml
goto end

:end
endlocal
