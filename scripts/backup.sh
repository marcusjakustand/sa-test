#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$BASE_DIR/config/settings.conf"

DATE=$(date '+%Y%m%d_%H%M%S')
ARCHIVE="$BACKUP_DIR/backup_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "Varukoopia loomine..."

tar -czf "$ARCHIVE" -C "$BACKUP_SOURCE" . 2>/dev/null

if [ -s "$ARCHIVE" ]; then
    file_count=$(tar -tzf "$ARCHIVE" | wc -l)
    echo "Varukoopia valmis: $ARCHIVE"
    echo "Failide arv: $file_count"
    exit 0
else
    echo "Varukoopia ebaõnnestus."
    exit 1
fi
