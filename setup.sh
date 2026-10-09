#!/usr/bin/env bash
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
rm -rf "$BASE_DIR/testdata"
mkdir -p "$BASE_DIR/testdata/source/subdir" "$BASE_DIR/logs" "$BASE_DIR/backups"
printf 'normal
' > "$BASE_DIR/testdata/source/normal.txt"
printf 'spaces
' > "$BASE_DIR/testdata/source/important data.txt"
printf 'nested
' > "$BASE_DIR/testdata/source/subdir/nested.txt"
echo "Testkeskkond loodud."
