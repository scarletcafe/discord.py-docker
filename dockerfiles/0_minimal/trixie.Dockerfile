#
# WARNING: THIS DOCKERFILE IS AUTO-GENERATED
# DIRECT EDITS WILL BE DESTROYED WHEN THIS FILE IS NEXT GENERATED
# PLEASE EDIT THE TEMPLATES INSTEAD OF THIS FILE
#
ARG PYTHON_VERSION

FROM python:$PYTHON_VERSION-trixie

ARG BUILD_TIME=unknown
ARG GIT_HEAD=unknown
LABEL maintainer="Devon R <Gorialis>"
LABEL creation_time="2026-04-14 21:04:23 UTC"
LABEL build_time=$BUILD_TIME
LABEL git_head=$GIT_HEAD

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.94.1

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
        amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='4acc9acc76d5079515b46346a485974457b5a79893cfb01112423c89aeb5aa10' ;; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='124e02253af9128f9e27ea1ac929cbb73cf44cf35469d0f594a1b62f7b71fea1' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='9732d6c5e2a098d3521fca8145d826ae0aaa067ef2385ead08e6feac88fa5792' ;; \
        i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='5140e82096f96d1d8077f00eb312648e0e5106d101c9918d086f72cbc69bb3a1' ;; \
        ppc64el) rustArch='powerpc64le-unknown-linux-gnu'; rustupSha256='4bfff85bd3967d988e14567aa9cc6ab0ea386f0ffeff0f9f14d23f0103bf1f97' ;; \
        s390x) rustArch='s390x-unknown-linux-gnu'; rustupSha256='66c2c132428b6b77803facb02cbdf33b89d20c00bd20da142be8cb651f2e7cd8' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac && \
    rustup_url="https://static.rust-lang.org/rustup/archive/1.29.0/${rustArch}/rustup-init" && \
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
    # update pip, install Cython, pytest, youtube-dl
    pip install -U pip Cython pytest youtube-dl -q --retries 30 && \
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