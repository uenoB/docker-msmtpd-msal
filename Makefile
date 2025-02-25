NAME=ghcr.io/uenob/msmtpd-msal
VERSION=1.8.28
SHA256=3a57f155f54e4860f7dd42138d9bea1af615b99dfab5ab4cd728fc8c09a647a4
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
