#!/bin/bash
set -eux

# Adapted from https://stackoverflow.com/a/76211564
# TODO(eric.cousineau): Try using
# https://github.com/easimon/maximize-build-space

df -h
docker image prune -af
df -h /
sudo rm -rf \
  /usr/share/dotnet /usr/local/lib/android /opt/ghc \
  /usr/local/share/powershell /usr/share/swift /usr/local/.ghcup \
  /usr/lib/jvm
df -h /
