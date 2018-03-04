# Container With Devpi Server

A Docker image based on [python:3.6-alpine3.6](https://hub.docker.com/_/python) that runs
a [devpi](http://doc.devpi.net) server (*a PyPi Cache*).


## Usage

```bash
docker run -it --rm -p 3141:3141 --name devpi zzzsochi/devpi
```

Directory with persistent data: ``/srv/devpi``.

```bash
docker run -it --rm -p 3141:3141 -v /local/path/to/data:/srv/devpi --name devpi zzzsochi/devpi
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
