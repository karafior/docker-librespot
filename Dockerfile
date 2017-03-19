FROM fedora:latest

RUN dnf update -y && dnf install -y cargo unzip

RUN mkdir /build
ENV CARGO_TARGET_DIR /build
ENV CARGO_HOME /build/cache

ADD https://github.com/plietar/librespot/archive/master.zip /
RUN unzip /master.zip && rm /master.zip
WORKDIR /librespot-master

# build only stdout backend
RUN cargo build --jobs $(grep -c ^processor /proc/cpuinfo) --release --no-default-features

RUN mv /build/release/librespot /
RUN chmod +x /librespot

RUN dnf remove -y cargo unzip
RUN dnf clean all

WORKDIR /
RUN rm -rf /build
RUN rm -rf /librespot-master

COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

RUN useradd -m librespot

USER librespot

ENV device_name SpotifyConnect

ENTRYPOINT ["/entrypoint.sh"]
