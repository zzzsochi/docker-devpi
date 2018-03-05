FROM python:3.6-alpine3.6
LABEL maintainer="Alexander Zelenyak <zzz.sochi@gmail.com>"

RUN apk add --update gcc python3-dev libffi-dev musl-dev && \
    pip3 wheel --wheel-dir=/srv/wheels devpi-server devpi-client


FROM python:3.6-alpine3.6
LABEL maintainer="Alexander Zelenyak <zzz.sochi@gmail.com>"

COPY --from=0 /srv/wheels /srv/wheels

VOLUME /srv/devpi

ENV DEVPI_SERVERDIR=/srv/devpi
# ENV DEVPI_USER=
# ENV DEVPI_PASSWORD=
# ENV DEVPI_INDEX=

RUN pip3 install --no-index --find-links=/srv/wheels devpi-server devpi-client && \
    rm -rf /srv/wheels /root/.cache

COPY entrypoint.sh /srv/entrypoint.sh
ENTRYPOINT ["/srv/entrypoint.sh"]
