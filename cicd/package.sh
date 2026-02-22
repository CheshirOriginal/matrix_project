#!/bin/bash

set -e

echo "=== PACKAGE STAGE ==="

PACKAGE_DIR="matrix-app_1.0-1"

echo "Preparing package structure..."

rm -rf $PACKAGE_DIR
mkdir -p $PACKAGE_DIR/DEBIAN
mkdir -p $PACKAGE_DIR/usr/local/bin

cp matrix_app $PACKAGE_DIR/usr/local/bin/
chmod 755 $PACKAGE_DIR/usr/local/bin/matrix_app

cat <<EOF > $PACKAGE_DIR/DEBIAN/control
Package: matrix-app
Version: 1.0-1
Section: base
Priority: optional
Architecture: amd64
Maintainer: Kirill
Depends: libc6
Description: Matrix diagonal task application
 Finds minimal element on diagonals and replaces upper triangle elements.
EOF

chmod 755 $PACKAGE_DIR/DEBIAN
chmod 644 $PACKAGE_DIR/DEBIAN/control

echo "Building deb package..."

dpkg-deb --build $PACKAGE_DIR

echo "Package created successfully!"