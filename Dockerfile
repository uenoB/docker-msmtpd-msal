FROM debian:12 AS build
RUN apt-get update
RUN apt-get install -y libc6-dev gcc make pkg-config xz-utils libssl-dev
RUN apt-get install -y golang ca-certificates
RUN apt-get install -y tini
WORKDIR /root

ARG VERSION
COPY msmtp-$VERSION.tar.xz /root
RUN xz -cd msmtp-$VERSION.tar.xz | tar -xf -
RUN cd msmtp-$VERSION && \
  ./configure --prefix=/usr --sysconfdir=/etc/msmtp \
              --disable-nls --with-tls=openssl && \
  make install

COPY msal.tgz /root
RUN mkdir msal && tar -xzf msal.tgz -C msal
RUN cd msal && go build -tags=simple -trimpath -ldflags="-s -w"

FROM gcr.io/distroless/cc-debian12:nonroot
COPY --from=build \
  /lib/x86_64-linux-gnu/libssl.so.3 \
  /lib/x86_64-linux-gnu/libcrypto.so.3 \
  /lib/x86_64-linux-gnu
COPY --from=build \
  /root/msal/msal \
  /usr/bin/msmtp \
  /usr/bin/msmtpd \
  /usr/bin/tini \
  /usr/bin
VOLUME /etc/msmtp

ENTRYPOINT ["tini", "--", "msmtpd"]
CMD ["--interface=0.0.0.0", "--log=/dev/stderr"]
