# docker-msmtpd-msal

This is a Docker container image of [msmtpd] with an MSAL authorization
functionality constructed atop [distroless].

[msmtpd]: https://marlam.de/msmtp/
[distroless]: https://github.com/GoogleContainerTools/distroless

## Setup

```sh
docker pull ghcr.io/uenob/msmtpd-msal
```

## Usage

Mount a volume containing the following to `/etc/msmtp`:
- `msmtprc`: configuration file for msmtp
