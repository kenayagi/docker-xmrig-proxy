FROM ubuntu:16.04

# Prepare directories
RUN mkdir /config

# Install dependencies
RUN apt-get update && apt-get -y install build-essential cmake libuv1-dev uuid-dev libmicrohttpd-dev

# Clean
RUN rm -rf /var/lib/apt/lists/*

# Get Code
ADD https://github.com/xmrig/xmrig-proxy/archive/v2.5.2.tar.gz /opt/xmrig-proxy.tar.gz
RUN mkdir /opt/xmrig-proxy
RUN tar xfv /opt/xmrig-proxy.tar.gz --strip 1 -C /opt/xmrig-proxy
RUN mkdir /opt/xmrig-proxy/build
WORKDIR /opt/xmrig-proxy/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DUV_LIBRARY=/usr/lib/x86_64-linux-gnu/libuv.a
RUN make

# Volume
VOLUME /config
RUN cp /opt/xmrig-proxy/src/config.json /config/config.json

# Ports
EXPOSE 80 7777

# Command
CMD ["/opt/xmrig-proxy/build/xmrig-proxy", "-c", "/config/config.json"]
