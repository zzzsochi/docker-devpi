FROM python:3.6-alpine3.6
LABEL maintainer="Alexander Zelenyak <zzz.sochi@gmail.com>"

RUN apk add --update gcc python3-dev libffi-dev musl-dev && \
    pip3 wheel --wheel-dir=/srv/wheels devpi-server


FROM python:3.6-alpine3.6
LABEL maintainer="Alexander Zelenyak <zzz.sochi@gmail.com>"

COPY --from=0 /srv/wheels /srv/wheels
COPY entrypoint.sh /srv/entrypoint.sh

VOLUME /srv/devpi
ENV DEVPI_SERVERDIR=/srv/devpi

RUN pip3 install --no-index --find-links=/srv/wheels devpi-server && \
    rm -rf /srv/wheels /root/.cache

ENTRYPOINT ["/srv/entrypoint.sh"]
