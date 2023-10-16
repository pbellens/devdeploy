#!/bin/bash

#docker build --file Dockerfile.dev -t otel-dev .
docker run -it --rm --mount type=bind,source=${PWD},target=/src $1 /bin/sh
