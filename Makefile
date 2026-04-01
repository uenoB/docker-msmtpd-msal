NAME=ghcr.io/uenob/msmtpd-msal
VERSION=1.8.32
SHA256=20cd58b58dd007acf7b937fa1a1e21f3afb3e9ef5bbcfb8b4f5650deadc64db4
DOCKER=docker

msmtpd-msal-$(VERSION).tar: Dockerfile msmtp-$(VERSION).tar.xz msal.tgz
	$(DOCKER) buildx build \
	  --build-arg VERSION=$(VERSION) \
	  --platform linux/amd64 -t $(NAME):$(VERSION) .
	$(DOCKER) save -o $@ $(NAME):$(VERSION)

msmtp-$(VERSION).tar.xz:
	curl -L -o $@ https://marlam.de/msmtp/releases/msmtp-$(VERSION).tar.xz
	test "$$(shasum -a256 $@)" = '$(SHA256)  $@'

msal.tgz:
	(cd msal && git archive --format=tgz HEAD) > $@
