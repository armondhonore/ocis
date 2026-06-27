FROM mirror.gcr.io/owncloud/ocis:latest

USER root
RUN apk add --no-cache attr ca-certificates curl mailcap tree vips || true
RUN echo 'hosts: files dns' > /etc/nsswitch.conf

# OCIS requires a dedicated data directory and specific environment variables to boot in a container
ENV OCIS_URL=https://relaxed-weasel-ocis.cloud.nexlayer.ai
ENV OCIS_INSECURE=true
ENV OCIS_STORAGE_PATH=/var/lib/ocis
ENV OCIS_LOG_LEVEL=info

# Create data directory and ensure correct ownership
RUN mkdir -p /var/lib/ocis && chown -R 1000:1000 /var/lib/ocis

# OCIS by default uses port 9200 for the proxy/gateway
EXPOSE 9200

USER 1000

# The official image entrypoint handles the 'ocis server' command
CMD ["ocis", "server"]