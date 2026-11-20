#!/data/data/com.termux/files/usr/bin/bash
set -eu

ROOT="$HOME/steveobot-minecraft-addons"
BRANCH="integration/termux-setup"
URL="https://github.com/jalbantonio-lbaj/steveobot-minecraft-addons.git"

if ! command -v git >/dev/null 2>&1; then
  pkg install -y git
fi
if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
  pkg install -y nodejs-lts
fi

NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"
if [ "$NODE_MAJOR" -lt 24 ]; then
  echo "ERROR: SteveoBot requiere Node.js 24 o superior. Detectado: $(node --version)"
  echo "Actualiza Node.js en Termux antes de continuar."
  exit 1
fi

if [ -d "$ROOT/.git" ]; then
  echo "Repositorio existente: actualizando solo la rama $BRANCH"
  git -C "$ROOT" fetch origin "$BRANCH"
  git -C "$ROOT" checkout "$BRANCH"
  git -C "$ROOT" pull --ff-only origin "$BRANCH"
elif [ -e "$ROOT" ]; then
  echo "ERROR: $ROOT existe pero no es un repositorio Git. No se modificó."
  exit 1
else
  git clone --single-branch --branch "$BRANCH" "$URL" "$ROOT"
fi

PNPM_MAJOR=0
if command -v pnpm >/dev/null 2>&1; then
  PNPM_MAJOR="$(pnpm --version | cut -d. -f1)"
fi
if [ "$PNPM_MAJOR" -lt 10 ]; then
  npm install -g pnpm@10.33.0
fi

cd "$ROOT"
echo
echo "Instalando dependencias..."
pnpm install --frozen-lockfile

echo
echo "Ejecutando validación, TypeScript, pruebas y compilación..."
pnpm run check

echo
echo "Empaquetando addons de ejemplo..."
node tools/package.ts

echo
echo "SteveoBot quedó instalado y las comprobaciones terminaron."
echo "Paquetes generados (si la compilación y el empaquetado finalizaron):"
echo "$ROOT/dist/_packages/"
