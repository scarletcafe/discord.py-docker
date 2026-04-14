#!/bin/bash
set -euo pipefail

echo "Uploading stage 0 (minimal)"

if docker push ${DOCKER_UPLOAD_REPOSITORY:-gorialis}/discord.py:build0-$1-trixie; then echo -e "UPLOAD build0-$1-trixie" >> ${DOCKER_DISCORD_PY_PASSTMP:-/dev/null}; else echo -e "FAIL UPLOAD build0-$1-trixie" | tee -a ${DOCKER_DISCORD_PY_FAILTMP:-/dev/null}; fi
if docker push ${DOCKER_UPLOAD_REPOSITORY:-gorialis}/discord.py:build0-$1-slim-trixie; then echo -e "UPLOAD build0-$1-slim-trixie" >> ${DOCKER_DISCORD_PY_PASSTMP:-/dev/null}; else echo -e "FAIL UPLOAD build0-$1-slim-trixie" | tee -a ${DOCKER_DISCORD_PY_FAILTMP:-/dev/null}; fi
if docker push ${DOCKER_UPLOAD_REPOSITORY:-gorialis}/discord.py:build0-$1-bookworm; then echo -e "UPLOAD build0-$1-bookworm" >> ${DOCKER_DISCORD_PY_PASSTMP:-/dev/null}; else echo -e "FAIL UPLOAD build0-$1-bookworm" | tee -a ${DOCKER_DISCORD_PY_FAILTMP:-/dev/null}; fi
if docker push ${DOCKER_UPLOAD_REPOSITORY:-gorialis}/discord.py:build0-$1-slim-bookworm; then echo -e "UPLOAD build0-$1-slim-bookworm" >> ${DOCKER_DISCORD_PY_PASSTMP:-/dev/null}; else echo -e "FAIL UPLOAD build0-$1-slim-bookworm" | tee -a ${DOCKER_DISCORD_PY_FAILTMP:-/dev/null}; fi
if docker push ${DOCKER_UPLOAD_REPOSITORY:-gorialis}/discord.py:build0-$1-alpine; then echo -e "UPLOAD build0-$1-alpine" >> ${DOCKER_DISCORD_PY_PASSTMP:-/dev/null}; else echo -e "FAIL UPLOAD build0-$1-alpine" | tee -a ${DOCKER_DISCORD_PY_FAILTMP:-/dev/null}; fi
