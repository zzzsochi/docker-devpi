# Container With Devpi Server

A Docker image based on [python:3.7-alpine3.8](https://hub.docker.com/_/python) that runs
a [devpi](http://doc.devpi.net) server (*a PyPi Cache*).


## Usage

```bash
docker run -it --rm -p 3141:3141 --name devpi zzzsochi/devpi
```

Directory with persistent data: ``/srv/devpi``.

```bash
docker run -it --rm -p 3141:3141 -v /local/path/to/data:/srv/devpi --name devpi zzzsochi/devpi
```

### Automated initialization

| Variable                  | Description                                           |
|---------------------------|-------------------------------------------------------|
| DEVPISERVER_ROOT_PASSWORD | Set password for root user                            |
| DEVPISERVER_USER          | Create user                                           |
| DEVPISERVER_PASSWORD      | Password for user ``$DEVPISERVER_USER``               |
| DEVPISERVER_INDEX         | Create index named ``$DEVPISERVER_USER/$DEVPI_INDEX`` |
| DEVPISERVER_HOST          | Default: ``0.0.0.0``                                  |
| DEVPISERVER_PORT          | Default: ``3141``                                     |

#### Example

```bash
docker run -it --rm --name devpi \
    -p 0.0.0.0:3141:3141 \
    -v /srv/devpi_data:/srv/devpi \
    -e DEVPISERVER_ROOT_PASSWORD=abracadabra \
    -e DEVPISERVER_USER=ci \
    -e DEVPISERVER_PASSWORD=else-abracadabra \
    -e DEVPISERVER_INDEX=mirror \
    zzzsochi/devpi
```


### pip

Use a configuration similar to this in your `~/.pip/pip.conf`:

```ini
[global]
index-url = http://localhost:3141/root/pypi/+simple/
```

### setuptools

Use a configuration similar to this in your `~/.pydistutils.cfg`:

```ini
[easy_install]
index_url = http://localhost:3141/root/pypi/+simple/
```
