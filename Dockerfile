FROM ubuntu:24.04

# Use sjtu mirror
RUN sed -i s@/archive.ubuntu.com/@/mirror.sjtu.edu.cn/@g /etc/apt/sources.list.d/ubuntu.sources
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    cmake build-essential flex bison llvm clang libzstd-dev zlib1g-dev \
    sudo git vim tar openssh-server rsync python3 python3-pip \
    dos2unix clang-format \
    && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash", "-i"]