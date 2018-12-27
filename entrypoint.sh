#!/usr/bin/env sh

set -e

if [ -z "${DEVPISERVER_HOST}" ]; then
    DEVPISERVER_HOST="0.0.0.0"
fi

if [ -z "${DEVPISERVER_PORT}" ]; then
    DEVPISERVER_PORT="3141"
fi

if [ ! -f "${DEVPISERVER_SERVERDIR}/.nodeinfo" ]; then
    echo "start initialization"
    devpi-server --init

    (
        echo "waiting for devpi-server start"
        sleep 5
        devpi use "http://${DEVPISERVER_HOST}:${DEVPISERVER_PORT}/root/pypi"
        devpi login root --password=""

        if [ ! -z "${DEVPISERVER_ROOT_PASSWORD}" ]; then
            echo "setup password for root"
            devpi user -m root password="${DEVPISERVER_ROOT_PASSWORD}"
        fi

        if [ ! -z "${DEVPISERVER_USER}" ] && ! ( devpi user -l | grep -q -x "${DEVPISERVER_USER}" ); then
            echo "create user ${DEVPISERVER_USER}"
            devpi user -c "${DEVPISERVER_USER}" password="${DEVPISERVER_PASSWORD}"
            devpi logout  # logout from root
            devpi login "${DEVPISERVER_USER}" --password="${DEVPISERVER_PASSWORD}"
        else
            export DEVPISERVER_USER=root
            export DEVPISERVER_PASSWORD="${DEVPISERVER_ROOT_PASSWORD}"
        fi

        if [ ! -z "${DEVPISERVER_INDEX}" ] && ! ( devpi index -l | grep -q -x "${DEVPISERVER_USER}/${DEVPISERVER_INDEX}" ); then
            echo "create index ${DEVPISERVER_USER}/${DEVPISERVER_INDEX}"
            devpi index -c "${DEVPISERVER_INDEX}"
        fi

        devpi logout
    ) &

else
    echo "skip initialization"
fi

echo "+ devpi-server --host=\"${DEVPISERVER_HOST}\" --port=\"${DEVPISERVER_PORT}\" $@"
exec devpi-server --host="${DEVPISERVER_HOST}" --port="${DEVPISERVER_PORT}" $@
