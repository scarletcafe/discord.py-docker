{% include 'WARNING_MD' %}

## Notices (most recent first)

### 2026-04-14

A large number of updates have been done:

- Python versions 3.13 and 3.14 added
- Python versions 3.8 and 3.9 removed (the Python base images for this version are no longer updated, upgrade to something newer)
- Debian trixie has been added
- Debian bullseye has been removed (the Python base images for this version are no longer updated, upgrade to something newer)
- The bundled Rust installation has been upgraded from 1.81.0 to 1.94.1
- The bundled `rustup` has been upgraded from 1.27.1 to 1.29.0
- Deno has been added to the image
- `youtube_dl` has been replaced with `yt-dlp`

As you may have guessed from the large gaps between updates, this image is not maintained with a large amount of active effort any more.

At the time this image and its build pipeline was devised, there was a large amount of inconsistency in terms of package availability, and it was often difficult to get built wheels on supported platforms.

There were also a larger amount of bot creators hosting multiple different bots on the same machine, and this image helped them make use of Docker's file system forking capability to save space between those instances.

Many of these previous packaging issues are no longer the case, and bot development by small developers is a lot less popular, with larger bots having their own infrastructure and not needing images like these.

This is hence your forewarning that this may be the last time this image receives updates. You should consider making your own purpose-built image.

### 2022-11-21

The main Debian image has been upgraded from `buster` to `bullseye`, 3.11 builds are added, and the new image tag names are updated to reflect the correct versions.

### 2021-04-11

As development of discord.py 2.0 begins, support for versions lower than 3.8 has been dropped. While the current PyPI version (1.7) still supports 3.6 and 3.7, in the interest of keeping the docker build process simple, and the image tag matrix easy to understand, 3.6 and 3.7 images will no longer be built from this date onwards. It is encouraged that you update any existing containers to 3.9 so you can continue receiving updated dependencies, and to prepare you for whenever 2.0 releases.

### 2019-07-21

The Docker `python` repo no longer builds containers for Debian stretch on 3.8+. In order to keep builds consistent, `stretch` containers will no longer be built, in favor of the newer `buster` containers available for all versions. This applies for slim images too (`slim-stretch` -> `slim-buster`). Alpine images are unaffected.

### 2019-04-09

The `rewrite` branch was merged into `master` on 2019-04-09, marking the end of the rewrite alpha stage. The `rewrite` tags will remain faithful to the old, now frozen, feature branch, so it is recommended to switch your containers to `master` to continue receiving development updates, or to switch to the new `pypi` tag.

### 2019-02-06

As of 2019-02-06, containers for the `async` branch will no longer be built, and as such, these will no longer have up to date Python versions, dependencies or installations of `discord.py`. You may still [pull these images](https://github.com/Gorialis/discord.py-docker/blob/8e3bec119beac363b11bda1565938870ba17e3f0/dockerfiles/README.md) for legacy reasons, but it is recommended that bots on the old branch are updated to use `rewrite` instead.

## Tags and respective `Dockerfile` links

{% for version, distro, checkout, stage in variations -%}
-   {{ get_tags(version, distro, checkout, stage)|map('mktag_l')|inline_codeblock }} (*[{{ distro[0] }}](https://github.com/Gorialis/discord.py-docker/blob/master/dockerfiles/0_minimal/{{ distro[0] }}.Dockerfile):[{{ stage[1][0] }}](https://github.com/Gorialis/discord.py-docker/tree/master/dockerfiles/{{ stage[0] }}_{{ stage[1][0] }}/)*)
{% endfor %}
*({{ len(variations) }} variants, {{ len(unchain(tags)) }} tags)*

## Image variants

This image comes in few variants depending on your use case:

### `discord.py:minimal`

This is the base, and therefore smallest, image. It contains only `discord.py` with voice and docs support, including ffmpeg and yt-dlp.

### `discord.py:full`

This is the default image. This contains some precompiled common dependencies, and as such, is much larger than the base image.

These dependencies are:
- {{ minor_deps.keys() | inline_codeblock }}

This can help reduce bot installation time as packages that would otherwise take a long time to compile or acquire are already installed.

### `discord.py:extras`

This image extends the `full` image with more dependencies:
- {{ major_deps.keys() | inline_codeblock }}

This image is therefore the largest image and is only recommended if you use a large variety of these dependencies.

## Using this image

### Create a Dockerfile for your project

```dockerfile
FROM gorialis/discord.py

WORKDIR /app

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "bot.py"]
```

You can use tags if you need specific versions:

```dockerfile
FROM gorialis/discord.py:3.9-alpine

WORKDIR /app

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY . .

CMD ["python", "bot.py"]
```

Then you can build your image and run it:
```sh
$ docker build -t my-bot .
$ docker run -it --rm --name my-running-bot my-bot
```

### Direct via console

If you are running one-time scripts, creating your own `Dockerfile` might be tedious. You can use this image directly from CLI like so:
```sh
$ docker run -it --rm --name my-bot -v $PWD:/app -w /app gorialis/discord.py:master python your-bot.py
```

You can also do this for tests:
```sh
$ docker run -it --rm --name my-tests -v $PWD:/app -w /app gorialis/discord.py:master pytest -vs
```

## Building this image

You can use the Dockerfiles listed with the tags above to build these images yourself.
The Dockerfiles themselves are autogenerated (last generated {{ now }}), and their templates are accessible via the [discord.py-docker repository](https://github.com/Gorialis/discord.py-docker).

The general format is as such:
```console
docker build --no-cache --tag <tag name> .
```

Note that these images can take quite a long time to build due to the amount of content included. It is for this reason that they are provided here, on Docker Hub, to use directly.

## Licensing

The `discord.py` library is available through the [MIT License](https://github.com/Rapptz/discord.py/blob/master/LICENSE) under copyright from [Rapptz](https://github.com/Rapptz).
Please visit the [original repository](https://github.com/Rapptz/discord.py) for more information.
