FROM ubuntu:20.04

RUN apt-get update; \
    apt-get install -y clang-format \
                       curl \
                       gcc \
                       make \
                       sshpass \
                       openssh-client; \
    rm -rf /var/lib/apt/lists/*
