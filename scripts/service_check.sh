#!/usr/bin/env bash

service="$1"

if [ -z "$service" ]; then
    echo "Kasutus: $0 <teenuse_nimi>"
    exit 1
fi

if systemctl is-active --quiet "$service"; then
    echo "Teenus $service töötab."
    exit 0
else
    echo "Teenus $service ei tööta."
    exit 1
fi
