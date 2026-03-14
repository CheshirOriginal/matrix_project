#!/bin/bash

set -e

echo "=== PACKAGE STAGE ==="

VERSION=${VERSION:-0.0.0-dev}
PACKAGE_NAME="matrix-app"
PACKAGE_DIR="${PACKAGE_NAME}_${VERSION}"

echo "Version: $VERSION"
echo "Package directory: $PACKAGE_DIR"

# \Удаляем старый dep-пакет
rm -f "${PACKAGE_DIR}.deb"

# Создаём структуру пакета
mkdir -p "$PACKAGE_DIR/DEBIAN"
mkdir -p "$PACKAGE_DIR/usr/src/matrix-app"

# Копируем исходники
cp -r src "$PACKAGE_DIR/usr/src/matrix-app/"
cp Makefile "$PACKAGE_DIR/usr/src/matrix-app/"

# Создаём control файл
cat <<EOF > "$PACKAGE_DIR/DEBIAN/control"
Package: $PACKAGE_NAME
Version: $VERSION
Section: utils
Priority: optional
Architecture: amd64
Maintainer: Kirill
Depends: build-essential
Description: Matrix diagonal task application
 Finds minimal element on diagonals and replaces upper triangle elements.
EOF

# Создаём postinst файл
cat <<EOF > "$PACKAGE_DIR/DEBIAN/postinst"
#!/bin/bash
set -e
echo "Building matrix-app..."
cd /usr/src/matrix-app
make rebuild
make clean
install -m 755 matrix_app /usr/bin/matrix_app
echo "matrix-app installed successfully."
EOF

chmod 755 "$PACKAGE_DIR/DEBIAN"
chmod 644 "$PACKAGE_DIR/DEBIAN/control"
chmod 755 "$PACKAGE_DIR/DEBIAN/postinst"

# Сборка deb
echo "Building .deb package..."
dpkg-deb --build "$PACKAGE_DIR"

echo "Package created: ${PACKAGE_DIR}.deb"

# Удаляем файлы сборки
rm -rf "$PACKAGE_DIR"