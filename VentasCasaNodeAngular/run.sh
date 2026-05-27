#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$BASE_DIR/proyectos/ventas-backend"
FRONTEND_DIR="$BASE_DIR/proyectos/ventas-front"

# Evita prompts interactivos del CLI de Angular (analytics, etc.)
export CI=true
export NG_CLI_ANALYTICS=false

if ! command -v node >/dev/null 2>&1; then
  echo "ERROR: node no esta instalado o no esta en PATH."
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "ERROR: npm no esta instalado o no esta en PATH."
  exit 1
fi

echo "Node: $(node --version)"
echo "NPM : $(npm --version)"

echo "Instalando dependencias backend..."
(cd "$BACKEND_DIR" && npm install)

echo "Instalando dependencias frontend..."
(cd "$FRONTEND_DIR" && npm install)

echo "Iniciando backend en http://localhost:3500"
(cd "$BACKEND_DIR" && npm run start) &
BACK_PID=$!

echo "Iniciando frontend en http://localhost:4300"
(cd "$FRONTEND_DIR" && npm run start) &
FRONT_PID=$!

cleanup() {
  echo "Deteniendo procesos..."
  kill "$BACK_PID" "$FRONT_PID" 2>/dev/null || true
}
trap cleanup INT TERM EXIT

wait "$BACK_PID" "$FRONT_PID"
