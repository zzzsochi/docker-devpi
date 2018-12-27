FROM python:3.7-alpine3.8
LABEL maintainer="Alexander Zelenyak <zzz.sochi@gmail.com>"

RUN apk add --update gcc python3-dev libffi-dev musl-dev && \
    pip3 wheel --wheel-dir=/srv/wheels 'devpi-server==4.8.0' 'devpi-client==4.2.0'


FROM python:3.7-alpine3.8
LABEL maintainer="Alexander Zelenyak <zzz.sochi@gmail.com>"

COPY --from=0 /srv/wheels /srv/wheels

VOLUME /srv/devpi

ENV DEVPISERVER_SERVERDIR=/var/lib/devpi
# ENV DEVPISERVER_USER=
# ENV DEVPISERVER_PASSWORD=
# ENV DEVPISERVER_INDEX=

RUN pip3 install --no-cache-dir --no-index --find-links=/srv/wheels devpi-server devpi-client

COPY entrypoint.sh /srv/entrypoint.sh
ENTRYPOINT ["/srv/entrypoint.sh"]
