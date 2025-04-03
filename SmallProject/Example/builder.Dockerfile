ARG base_tag=bullseye
ARG base_img=mcr.microsoft.com/vscode/devcontainers/base:dev-${base_tag}

FROM --platform=linux/amd64 ${base_img} AS builder-install

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update --fix-missing && \
    apt-get -y upgrade && \
    apt-get install -y --no-install-recommends \
        apt-utils \
        curl \
        cmake \
        build-essential \
        gcc \
        g++-multilib \
        locales \
        make \
        ruby \
        gcovr \
        wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
