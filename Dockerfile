# Specify versions
ARG FLUTTER_VERSION=3.24.0
ARG OLM_VERSION=3.2.16
ARG NIX_VERSION=2.22.1

# Building libolm
# libolm only has amd64
FROM --platform=linux/amd64 nixos/nix:${NIX_VERSION} AS olm-builder
ARG OLM_VERSION
RUN nix build -v --extra-experimental-features flakes --extra-experimental-features nix-command gitlab:matrix-org/olm/${OLM_VERSION}?host=gitlab.matrix.org\#javascript

# Building Twake for the web
FROM --platform=linux/amd64 ghcr.io/cirruslabs/flutter:${FLUTTER_VERSION} AS web-builder
ARG TWAKECHAT_BASE_HREF="/web/"

## Handling SSH
RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y openssh-client
RUN mkdir -pvm 0600 /root/.ssh
ADD ./.compose/chat/deps-reader.tar.gz /root/.ssh/
RUN ssh-keygen -y -f /root/.ssh/id_ed25519 > /root/.ssh/id_ed25519.pub && \
	ssh-keyscan github.com >> /root/.ssh/known_hosts && \
	chmod -v 644 /root/.ssh/known_hosts

COPY . /app
WORKDIR /app

COPY --from=olm-builder /result/javascript assets/js/package

RUN ./scripts/build-web.sh

# Final image
FROM nginx:alpine AS final-image
ARG TWAKECHAT_BASE_HREF
ENV TWAKECHAT_BASE_HREF=${TWAKECHAT_BASE_HREF:-/web/}
ENV TWAKECHAT_LISTEN_PORT="80"
RUN rm -rf /usr/share/nginx/html
COPY --from=web-builder /app/build/web /usr/share/nginx/html${TWAKECHAT_BASE_HREF}
COPY ./configurations/nginx.conf.template /etc/nginx/templates/default.conf.template

# Specify the port
EXPOSE 80
