FROM fedora:latest

ENV CARGO_TARGET_DIR /build
ENV CARGO_HOME /build/cache

ADD https://github.com/plietar/librespot/archive/master.zip /

# build only stdout backend
RUN dnf install -y cargo unzip && \
    unzip /master.zip && rm /master.zip && cd /librespot-master && mkdir /build && \
    cargo build --jobs $(grep -c ^processor /proc/cpuinfo) --release --no-default-features && \
    mv /build/release/librespot / && chmod +x /librespot && \
    rm -rf /build /librespot-master && dnf remove -y cargo unzip && dnf clean all && \
    cd /

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

RUN useradd -m librespot

USER librespot

ENV device_name SpotifyConnect

ENTRYPOINT ["/entrypoint.sh"]
