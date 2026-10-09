#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
source "$BASE_DIR/config/settings.conf"

usage=$(df -Ph / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Kettakasutus: ${usage}%"

if [ "$usage" -lt "$DISK_LIMIT" ]; then
    echo "OK: kettaruumi kasutus on normis."
    exit 0
else
    echo "HOIATUS: kettaruumi kasutus on liiga suur."
    exit 1
fi
