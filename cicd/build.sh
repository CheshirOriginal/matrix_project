#!/bin/bash

set -e  # если ошибка — выход

echo "=== BUILD STAGE ==="

echo "Cleaning old build..."
make clean || true

echo "Building project..."
make

if [ ! -f matrix_app ]; then
    echo "Build failed: matrix_app not found!"
    exit 1
fi

echo "Build successful!"