NAME=ghcr.io/uenob/msmtpd-msal
VERSION=1.8.31
SHA256=c262b11762d8582a3c6d6ca8d8b2cca2b1605497324ca27cc57fdc145a27119f
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
