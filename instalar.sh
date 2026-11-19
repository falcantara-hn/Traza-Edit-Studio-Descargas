#!/bin/bash
# Instala TRAZA Edit Studio con una sola línea en Terminal, sin el bloqueo de macOS para apps sin firma:
#
#   curl -fsSL https://raw.githubusercontent.com/falcantara-hn/Traza-Edit-Studio-Descargas/main/instalar.sh | bash
#
# Baja la última versión, la deja en Aplicaciones a tu nombre (así se actualiza sola) y la abre.
# No pide contraseña ni toca nada fuera de la app. Tus marcas, memoria y proyectos no se tocan.
set -euo pipefail

REPO="falcantara-hn/Traza-Edit-Studio-Descargas"
URL="https://github.com/$REPO/releases/latest/download/TRAZA-Edit-Studio-app.zip"
APP="/Applications/TRAZA Edit Studio.app"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "Descargando TRAZA Edit Studio…"
curl -fL --progress-bar -o "$TMP/app.zip" "$URL"
ditto -x -k "$TMP/app.zip" "$TMP"
[ -d "$TMP/TRAZA Edit Studio.app" ] || { echo "La descarga no trae la app. Prueba de nuevo." >&2; exit 1; }

if pgrep -x TrazaStudio >/dev/null; then
  echo "Cerrando la app abierta para reemplazarla…"
  osascript -e 'quit app "TRAZA Edit Studio"' >/dev/null 2>&1 || true
  sleep 3
fi

if [ -d "$APP" ] && [ ! -w "$APP" ]; then
  # Una versión instalada antes con el .pkg es del sistema: solo esta vez hace falta tu contraseña.
  echo "Para reemplazar la versión anterior, macOS pide tu contraseña de la Mac:"
  sudo rm -rf "$APP"
fi
rm -rf "$APP"
mv "$TMP/TRAZA Edit Studio.app" "$APP"
echo "Listo. Abriendo TRAZA Edit Studio…"
open "$APP"
