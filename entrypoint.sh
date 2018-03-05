#!/usr/bin/env sh

set -e

if [ "$@" ]; then
    $@
else
    if [ ! -f "${DEVPI_SERVERDIR}/.nodeinfo" ]; then
        echo "start initialization"
        devpi-server --init

        echo "wait for devpi-server start "
        (
            sleep 4
            devpi use "http://0.0.0.0:3141/root/pypi"
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

    exec devpi-server --host=0.0.0.0
fi
