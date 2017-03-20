FROM fedora:latest

ENV CARGO_TARGET_DIR /build
ENV CARGO_HOME /build/cache

# build only stdout backend
RUN wget https://github.com/awmath/librespot/archive/crypto-fork.zip && unzip /crypto-fork.zip && rm /crypto-fork.zip && \
    dnf update -y && dnf install -y cargo unzip && \
    cd /librespot-crypto-fork && mkdir /build && \
    cargo build --jobs $(grep -c ^processor /proc/cpuinfo) --release --no-default-features && \
    mv /build/release/librespot / && chmod +x /librespot && \
    rm -rf /build /librespot-crypto-fork && dnf remove -y cargo unzip && dnf clean all

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

RUN useradd -m librespot

USER librespot

ENV device_name SpotifyConnect

ENTRYPOINT ["/entrypoint.sh"]
