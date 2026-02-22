#!/bin/bash

set -e

echo "=== TEST STAGE ==="

if [ ! -f matrix_app ]; then
    echo "Executable not found!"
    exit 1
fi

run_test () {
    INPUT="$1"
    EXPECTED="$2"
    TEST_NAME="$3"

    echo "Running $TEST_NAME..."

    echo -e "$INPUT" | ./matrix_app > output.txt
    echo -e "$EXPECTED" > expected.txt

    if diff -u expected.txt output.txt; then
        echo "$TEST_NAME passed!"
    else
        echo "$TEST_NAME failed!"
        exit 1
    fi

    rm -f output.txt expected.txt
}

# ----------------------------
# TEST 1 — стандартный случай
# ----------------------------
run_test \
"3
1 2 3
4 5 6
7 8 9" \
"1 1 1
4 5 1
7 8 9" \
"Test 1"

# ----------------------------
# TEST 2 — отрицательные числа
# ----------------------------
run_test \
"3
-1 2 -3
4 -5 6
7 8 -9" \
"-9 -9 -9
4 -5 -9
7 8 -9" \
"Test 2"

# ----------------------------
# TEST 3 — граничный случай N=1
# ----------------------------
run_test \
"1
42" \
"42" \
"Test 3"

echo "All tests passed successfully!"