#!/usr/bin/env sh

set -e

if [ "$@" ]; then
    $@
else
    set -x

    if [ ! -f "$DEVPI_SERVERDIR/.nodeinfo" ]; then
        devpi-server --init
    fi

    devpi-server --host=0.0.0.0
fi
