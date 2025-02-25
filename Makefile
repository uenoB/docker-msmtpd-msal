NAME=ghcr.io/uenob/msmtpd-msal
VERSION=1.8.26
SHA256=6cfc488344cef189267e60aea481f00d4c7e2a59b53c6c659c520a4d121f66d8
DOCKER=docker

msmtpd-msal-$(VERSION).tar: \
    Dockerfile msmtp-$(VERSION).tar.xz msal.tgz entrypoint.sh
	$(DOCKER) buildx build \
	  --build-arg VERSION=$(VERSION) \
	  --platform linux/amd64 -t $(NAME):$(VERSION) .
	$(DOCKER) save -o $@ $(NAME):$(VERSION)

msmtp-$(VERSION).tar.xz:
	curl -L -o $@ https://marlam.de/msmtp/releases/msmtp-$(VERSION).tar.xz
	test "$$(shasum -a256 $@)" = '$(SHA256)  $@'

msal.tgz:
	(cd msal && git archive --format=tgz HEAD) > $@
