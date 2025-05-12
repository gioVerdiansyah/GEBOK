@echo off
setlocal enabledelayedexpansion

if "%1"=="" (
    echo Usage: %0 feature_name
    exit /b 1
)

set "FEATURE_NAME=%1"
set "BASE_DIR=D:\Users\Verdi\AppData\Local\Android\book_shelf\lib\src\features\%FEATURE_NAME%"

for %%D in (
    "data\api"
    "data\models"
    "data\repositories"
    "domain\entities"
    "domain\repositories"
    "presentations\blocs"
    "presentations\screens"
    "presentations\widgets"
) do (
    mkdir "%BASE_DIR%\%%D" 2>nul
)

echo Feature '%FEATURE_NAME%' has successfully make in '%BASE_DIR%'
