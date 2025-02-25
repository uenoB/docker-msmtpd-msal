FROM debian:12 AS build
RUN apt-get update
RUN apt-get install -y libc6-dev gcc make pkg-config xz-utils
RUN apt-get install -y libssl-dev
RUN apt-get install -y golang ca-certificates
WORKDIR /root

ARG VERSION
COPY msmtp-$VERSION.tar.xz /root
RUN xz -cd msmtp-$VERSION.tar.xz | tar -xf -
RUN cd msmtp-$VERSION && \
  ./configure --prefix=/usr --sysconfdir=/etc/msmtp \
              --disable-nls --with-tls=openssl && \
  make install

ARG MSAL_COMMIT
COPY msal.tgz /root
RUN mkdir msal && tar -xzf msal.tgz -C msal
RUN cd msal && go build -tags=simple -trimpath -ldflags="-s -w"

COPY entrypoint.sh /root
RUN chmod 755 entrypoint.sh

FROM gcr.io/distroless/cc-debian12:nonroot
COPY --from=build \
  /lib/x86_64-linux-gnu/libssl.so.3 \
  /lib/x86_64-linux-gnu/libcrypto.so.3 \
  /lib/x86_64-linux-gnu
COPY --from=build \
  /root/msal/msal \
  /usr/bin/msmtp \
  /usr/bin/msmtpd \
  /usr/bin
COPY --from=build /bin/sh /bin
COPY --from=build /root/entrypoint.sh /
VOLUME /etc/msmtp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--interface=0.0.0.0", "--log=/dev/stderr"]
