#
# WARNING: THIS DOCKERFILE IS AUTO-GENERATED
# DIRECT EDITS WILL BE DESTROYED WHEN THIS FILE IS NEXT GENERATED
# PLEASE EDIT THE TEMPLATES INSTEAD OF THIS FILE
#
ARG PYTHON_VERSION

FROM python:$PYTHON_VERSION-bullseye

ARG BUILD_TIME=unknown
ARG GIT_HEAD=unknown
LABEL maintainer="Devon R <Gorialis>"
LABEL creation_time="2024-10-01 17:58:02 UTC"
LABEL build_time=$BUILD_TIME
LABEL git_head=$GIT_HEAD

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.81.0

RUN apt-get update && \
    # basic deps
    apt-get install -y -qq git mercurial cloc openssl ssh gettext sudo build-essential \
    # voice support
    libffi-dev libsodium-dev libopus-dev ffmpeg \
    # apt is so noisy
    > /dev/null && \
    # install rust with rustup
    dpkgArch="$(dpkg --print-architecture)" && \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='6aeece6993e902708983b209d04c0d1dbb14ebb405ddb87def578d41f920f56d' ;; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='3c4114923305f1cd3b96ce3454e9e549ad4aa7c07c03aec73d1a785e98388bed' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='1cffbf51e63e634c746f741de50649bbbcbd9dbe1de363c9ecef64e278dba2b2' ;; \
        i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='0a6bed6e9f21192a51f83977716466895706059afb880500ff1d0e751ada5237' ;; \
        ppc64el) rustArch='powerpc64le-unknown-linux-gnu'; rustupSha256='079430f58ad4da1d1f4f5f2f0bd321422373213246a93b3ddb53dad627f5aa38' ;; \
        s390x) rustArch='s390x-unknown-linux-gnu'; rustupSha256='e7f89da453c8ce5771c28279d1a01d5e83541d420695c74ec81a7ec5d287c51c' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac && \
    rustup_url="https://static.rust-lang.org/rustup/archive/1.27.1/${rustArch}/rustup-init" && \
    wget "$rustup_url" && \
    echo "${rustupSha256} *rustup-init" | sha256sum -c - && \
    chmod +x rustup-init && \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch} && \
    rm rustup-init && \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME && \
    rustup --version && \
    cargo --version && \
    rustc --version && \
    # do this symlink for numpy
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    # update pip, install Cython, pytest, yt-dlp
    pip install -U pip Cython pytest "yt-dlp[default]" -q --retries 30 && \
    # remove caches
    rm -rf /root/.cache/pip/* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    find /usr/local -depth \
        \( \
            \( -type d -a \( -name test -o -name tests \) \) \
            -o \
            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
        \) -exec rm -rf '{}' +

WORKDIR /app

CMD ["python"]