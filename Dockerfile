FROM mirror.gcr.io/owncloud/ocis:latest

USER root
# Ensure essential dependencies are present and fix DNS resolution issues
RUN apk add --no-cache attr ca-certificates curl mailcap tree vips || true
RUN echo 'hosts: files dns' > /etc/nsswitch.conf

# OCIS environment configuration
# OCIS_URL is required for the gateway to handle redirects correctly
ENV OCIS_URL=https://relaxed-weasel-ocis.cloud.nexlayer.ai
ENV OCIS_INSECURE=true
ENV OCIS_STORAGE_PATH=/var/lib/ocis
ENV OCIS_LOG_LEVEL=info
# Use the basic setup to avoid interactive prompts during first boot
ENV OCIS_BOOTSTRAP_SESSIONS_ENABLED=true

# Setup data directory
RUN mkdir -p /var/lib/ocis && chown -R 1000:1000 /var/lib/ocis

EXPOSE 9200

USER 1000

# Use the full path to the binary to avoid PATH resolution issues in some environments
# The official image usually puts binaries in /usr/bin or /bin
CMD ["ocis", "server"]
