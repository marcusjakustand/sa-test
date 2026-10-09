#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "========================================"
echo "         SÜSTEEMI KONTROLLPANEEL         "
echo "========================================"
echo ""

"$BASE_DIR/scripts/system_info.sh"
echo ""
echo "----------------------------------------"
"$BASE_DIR/scripts/disk_check.sh"
echo "----------------------------------------"
echo ""
echo "Süsteemi põhiteenuste olek:"
for srv in cron ssh systemd-journald; do
    "$BASE_DIR/scripts/service_check.sh" "$srv"
done
echo ""
echo "========================================"
