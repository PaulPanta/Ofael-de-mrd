@echo off
TITLE Entorno Ventas Casa - Node.js Portable

REM Definir rutas absolutas
SET BASE_DIR=%~dp0
SET NODE_PATH=%BASE_DIR%nodejs
SET NPM_CONFIG_PREFIX=%BASE_DIR%npm-global-ventas
SET NPM_CONFIG_CACHE=%BASE_DIR%npm-cache
SET PROYECTOS_DIR=%BASE_DIR%proyectos
SET BACKEND_DIR=%PROYECTOS_DIR%\ventas-backend
SET FRONTEND_DIR=%PROYECTOS_DIR%\ventas-front

REM Crear carpetas necesarias si no existen
if not exist "%NPM_CONFIG_PREFIX%" mkdir "%NPM_CONFIG_PREFIX%"
if not exist "%NPM_CONFIG_CACHE%" mkdir "%NPM_CONFIG_CACHE%"

REM Verificar existencia del ejecutable de Node
if exist "%NODE_PATH%\node.exe" (
  set USE_NODE_PATH=1
) else (
  set USE_NODE_PATH=0
)

if "%USE_NODE_PATH%"=="0" (
  where node >nul 2>&1
  if errorlevel 1 (
    echo ERROR: Node no encontrado en %NODE_PATH% ni en PATH.
    echo Copia una distribución portable de Node (node.exe) dentro de "%NODE_PATH%" o instala Node globalmente.
    pause
    exit /b 1
  )
)

REM Definir comandos node/npm segun entorno disponible
set "NPM_CMD=npm"
if "%USE_NODE_PATH%"=="1" (
  set "NPM_CMD=%NODE_PATH%\npm"
)

REM Configurar npm global/cache para evitar permisos y dependencia del equipo
if "%USE_NODE_PATH%"=="1" (
  call "%NODE_PATH%\npm" config set prefix "%NPM_CONFIG_PREFIX%" >nul
  call "%NODE_PATH%\npm" config set cache "%NPM_CONFIG_CACHE%" >nul
) else (
  call npm config set prefix "%NPM_CONFIG_PREFIX%" >nul
  call npm config set cache "%NPM_CONFIG_CACHE%" >nul
)

echo ==========================
echo Entorno Ventas Casa
echo ==========================
echo Node version:
call node --version
echo NPM version:
call "%NPM_CMD%" --version
echo.

if not exist "%BACKEND_DIR%\package.json" (
  echo ERROR: No se encontro %BACKEND_DIR%\package.json
  pause
  exit /b 1
)

if not exist "%FRONTEND_DIR%\package.json" (
  echo ERROR: No se encontro %FRONTEND_DIR%\package.json
  pause
  exit /b 1
)

REM Instalar dependencias solo si falta node_modules (primera ejecucion)
if not exist "%BACKEND_DIR%\node_modules" (
  echo Instalando dependencias backend...
  cd /d "%BACKEND_DIR%"
  call "%NPM_CMD%" install
  if errorlevel 1 (
    echo ERROR instalando backend.
    pause
    exit /b 1
  )
)

if not exist "%FRONTEND_DIR%\node_modules" (
  echo Instalando dependencias frontend...
  cd /d "%FRONTEND_DIR%"
  call "%NPM_CMD%" install
  if errorlevel 1 (
    echo ERROR instalando frontend.
    pause
    exit /b 1
  )
)

echo.
echo Iniciando backend y frontend...

start "Ventas Backend (3500)" cmd /k "cd /d "%BACKEND_DIR%" && call "%NPM_CMD%" run start"
start "Ventas Frontend (4300)" cmd /k "cd /d "%FRONTEND_DIR%" && call "%NPM_CMD%" run start"

echo Listo. Se abrieron dos ventanas:
echo - Backend:  http://localhost:3500
echo - Frontend: http://localhost:4300
exit /b 0
