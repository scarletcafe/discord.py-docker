{% include 'WARNING_MD' %}

## Most recent notice

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

This is hence your forewarning that this may be the last time this image receives updates. You should consider making your own purpose-built image.

*See all notices in the [full README](https://github.com/Gorialis/discord.py-docker/blob/master/dockerfiles/README.md)*

## Tags and respective `Dockerfile` links

{% for version, distro, checkout, stage in variations_short -%}
-   {{ get_tags(version, distro, checkout, stage)|map('mktag_l')|inline_codeblock }} (*[{{ distro[0] }}](https://github.com/Gorialis/discord.py-docker/blob/master/dockerfiles/0_minimal/{{ distro[0] }}.Dockerfile):[{{ stage[1][0] }}](https://github.com/Gorialis/discord.py-docker/tree/master/dockerfiles/{{ stage[0] }}_{{ stage[1][0] }}/)*)
{% endfor %}
*({{ len(variations) }} variants, {{ len(unchain(tags)) }} tags)*

*See all the tags in the [full README](https://github.com/Gorialis/discord.py-docker/blob/master/dockerfiles/README.md)*

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

## Licensing

The `discord.py` library is available through the [MIT License](https://github.com/Rapptz/discord.py/blob/master/LICENSE) under copyright from [Rapptz](https://github.com/Rapptz).
Please visit the [original repository](https://github.com/Rapptz/discord.py) for more information.
