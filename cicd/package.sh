#!/bin/bash

set -e

echo "=== PACKAGE STAGE ==="

# Если VERSION не передана — используем dev
VERSION=${VERSION:-dev}

PACKAGE_NAME="matrix-app"
PACKAGE_DIR="${PACKAGE_NAME}_${VERSION}"

echo "Version: $VERSION"
echo "Package directory: $PACKAGE_DIR"

# Удаляем старую сборку
rm -rf "$PACKAGE_DIR"
rm -f "${PACKAGE_DIR}.deb"

# Создаём структуру пакета
mkdir -p "$PACKAGE_DIR/DEBIAN"
mkdir -p "$PACKAGE_DIR/usr/local/bin"

# Копируем бинарник
cp matrix_app "$PACKAGE_DIR/usr/local/bin/"
chmod 755 "$PACKAGE_DIR/usr/local/bin/matrix_app"

# Создаём control файл
cat <<EOF > "$PACKAGE_DIR/DEBIAN/control"
Package: $PACKAGE_NAME
Version: $VERSION
Section: base
Priority: optional
Architecture: amd64
Maintainer: Kirill
Depends: libc6
Description: Matrix diagonal task application
 Finds minimal element on diagonals and replaces upper triangle elements.
EOF

chmod 755 "$PACKAGE_DIR/DEBIAN"
chmod 644 "$PACKAGE_DIR/DEBIAN/control"

# Сборка deb
echo "Building .deb package..."
dpkg-deb --build "$PACKAGE_DIR"

echo "Package created: ${PACKAGE_DIR}.deb"