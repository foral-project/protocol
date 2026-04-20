#!/bin/sh
# Foral CLI — Install Script
#
# Uso:
#   curl -sfL https://foral-project.github.io/protocol/install.sh | sh
#   curl -sfL https://foral-project.github.io/protocol/install.sh | sh -s -- --version v0.1.0
#
# Detecta OS e arch automaticamente, baixa o binário correto do GitHub Releases.

set -e

REPO="foral-project/cli"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
VERSION="${1:-latest}"

# Detectar OS
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$OS" in
  linux*)  OS="linux" ;;
  darwin*) OS="darwin" ;;
  *)       echo "❌ OS não suportado: $OS"; exit 1 ;;
esac

# Detectar arch
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|amd64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *)             echo "❌ Arquitetura não suportada: $ARCH"; exit 1 ;;
esac

BINARY="foral-${OS}-${ARCH}"

# Resolver versão
if [ "$VERSION" = "latest" ]; then
  VERSION=$(curl -sfL "https://api.github.com/repos/${REPO}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  if [ -z "$VERSION" ]; then
    echo "❌ Não foi possível determinar a versão mais recente."
    echo "   Especifique manualmente: sh install.sh v0.1.0"
    exit 1
  fi
fi

URL="https://github.com/${REPO}/releases/download/${VERSION}/${BINARY}"
CHECKSUM_URL="${URL}.sha256"

echo "🏛️  Foral CLI Installer"
echo ""
echo "  Versão:  ${VERSION}"
echo "  OS:      ${OS}"
echo "  Arch:    ${ARCH}"
echo "  Destino: ${INSTALL_DIR}/foral"
echo ""

# Download
TMPDIR=$(mktemp -d)
echo "⬇️  Baixando ${BINARY}..."
curl -sfL "$URL" -o "${TMPDIR}/foral" || {
  echo "❌ Falha ao baixar: $URL"
  echo "   Verifique se a versão ${VERSION} existe em:"
  echo "   https://github.com/${REPO}/releases"
  rm -rf "$TMPDIR"
  exit 1
}

# Checksum
echo "🔒 Verificando checksum..."
if curl -sfL "$CHECKSUM_URL" -o "${TMPDIR}/foral.sha256" 2>/dev/null; then
  cd "$TMPDIR"
  if command -v sha256sum >/dev/null 2>&1; then
    echo "$(cat foral.sha256)" | sha256sum -c - || {
      echo "❌ Checksum inválido!"
      rm -rf "$TMPDIR"
      exit 1
    }
  else
    echo "⚠️  sha256sum não disponível, pulando verificação."
  fi
  cd - >/dev/null
else
  echo "⚠️  Checksum não encontrado, pulando verificação."
fi

# Instalar
chmod +x "${TMPDIR}/foral"

if [ -w "$INSTALL_DIR" ]; then
  mv "${TMPDIR}/foral" "${INSTALL_DIR}/foral"
else
  echo "🔑 Requer sudo para instalar em ${INSTALL_DIR}..."
  sudo mv "${TMPDIR}/foral" "${INSTALL_DIR}/foral"
fi

rm -rf "$TMPDIR"

echo ""
echo "✅ Foral CLI ${VERSION} instalado em ${INSTALL_DIR}/foral"
echo ""
echo "Verifique:"
echo "  foral version"
