:: =======================================================
:: SCRIPT DE AUTOMATIZACIÓN DE EMPAQUETADO Y CHECKSUM
:: =======================================================

@echo off
set APP_NAME=mi-algoritmo
set APP_VERSION=1.0.0
set MAIN_JAR_NAME=%APP_NAME%-hash-%APP_VERSION%.jar
set MAIN_CLASS=com.tuempresa.HashGenerator
set INSTALLER_NAME=%APP_NAME%-%APP_VERSION%.msi

echo --- 1. Creando instalador MSI con jpackage ---

:: Crea la carpeta de salida si no existe
mkdir installer_output 2>nul || echo Carpeta 'installer_output' ya existe.

:: Comando jpackage para Windows (Requiere JDK 14+ y WiX Toolset)
jpackage ^
  --type msi ^
  --name %APP_NAME% ^
  --app-version %APP_VERSION% ^
  --input target ^
  --dest installer_output ^
  --main-jar %MAIN_JAR_NAME% ^
  --main-class %MAIN_CLASS% ^
  --win-menu ^
  --win-shortcut ^
  --verbose

if errorlevel 1 (
    echo.
    echo ERROR: jpackage ha fallado. Asegurese de tener el JDK 14+ y WiX Toolset instalados.
    exit /b 1
)

echo --- 2. Generando Checksum SHA-256 del instalador ---

:: Comando para generar SHA-256 usando PowerShell
PowerShell -Command "Get-FileHash -Algorithm SHA256 'installer_output\%INSTALLER_NAME%' | Select-Object -ExpandProperty Hash" > installer_output\%INSTALLER_NAME%.sha256

echo --- ¡PROCESO DE EMPAQUETADO Y CHECKSUM FINALIZADO! ---
echo El instalador MSI y su Checksum SHA-256 estan en la carpeta 'installer_output\'