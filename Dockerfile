FROM ubuntu:18.04

# Prepare directories
RUN mkdir /config

# Install dependencies
RUN apt update && apt -y upgrade && apt -y install \
    build-essential \
    cmake \
    git \
    libmicrohttpd-dev \
    libssl-dev \
    libuv1-dev \
    uuid-dev

# Clean
RUN rm -rf /var/lib/apt/lists/*

# Get Code
WORKDIR /opt
RUN git clone https://github.com/xmrig/xmrig-proxy && \
    cd xmrig-proxy && \
    git checkout v2.14.4 && \
    sed -i "/^constexpr const int kDefaultDonateLevel = 2;/c\constexpr const int kDefaultDonateLevel = 0;" src/donate.h && \
    mkdir build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DUV_LIBRARY=/usr/lib/x86_64-linux-gnu/libuv.a . && \
    make

# Volume
VOLUME /config
RUN cp /opt/xmrig-proxy/src/config.json /config/config.json

# Ports
EXPOSE 80 7777

# Command
CMD ["/opt/xmrig-proxy/build/xmrig-proxy", "-c", "/config/config.json"]
