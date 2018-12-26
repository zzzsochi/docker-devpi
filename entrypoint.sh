#!/usr/bin/env sh

set -e

if [ -z "${DEVPI_HOST}" ]; then
    DEVPI_HOST="0.0.0.0"
fi

if [ -z "${DEVPI_PORT}" ]; then
    DEVPI_PORT="3141"
fi

if [ ! -f "${DEVPI_SERVERDIR}/.nodeinfo" ]; then
    echo "start initialization"
    devpi-server --init

    (
        echo "waiting for devpi-server start"
        sleep 5
        devpi use "http://${DEVPI_HOST}:${DEVPI_PORT}/root/pypi"
        devpi login root --password=""

        if [ ! -z "${DEVPI_ROOT_PASSWORD}" ]; then
            echo "setup password for root"
            devpi user -m root password="${DEVPI_ROOT_PASSWORD}"
        fi

        if [ ! -z "${DEVPI_USER}" ] && ! ( devpi user -l | grep -q -x "${DEVPI_USER}" ); then
            echo "create user ${DEVPI_USER}"
            devpi user -c "${DEVPI_USER}" password="${DEVPI_PASSWORD}"
            devpi logout  # logout from root
            devpi login "${DEVPI_USER}" --password="${DEVPI_PASSWORD}"
        else
            export DEVPI_USER=root
            export DEVPI_PASSWORD="${DEVPI_ROOT_PASSWORD}"
        fi

        if [ ! -z "${DEVPI_INDEX}" ] && ! ( devpi index -l | grep -q -x "${DEVPI_USER}/${DEVPI_INDEX}" ); then
            echo "create index ${DEVPI_USER}/${DEVPI_INDEX}"
            devpi index -c "${DEVPI_INDEX}"
        fi

        devpi logout
    ) &

else
    echo "skip initialization"
fi

exec devpi-server --host="${DEVPI_HOST}" --port="${DEVPI_PORT}" $@
