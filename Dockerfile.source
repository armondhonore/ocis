FROM mirror.gcr.io/owncloud/ocis:latest

USER root
RUN mkdir -p /var/lib/ocis && chown -R 1000:1000 /var/lib/ocis

# OCIS needs a specific set of environment variables to bypass interactive setup
# and run as a single-process gateway in a container
ENV OCIS_INSECURE=true
ENV OCIS_STORAGE_PATH=/var/lib/ocis
ENV OCIS_LOG_LEVEL=info
ENV OCIS_BOOTSTRAP_SESSIONS_ENABLED=true
ENV OCIS_URL=https://relaxed-weasel-ocis.cloud.nexlayer.ai

USER 1000
EXPOSE 9200

# The ocis server command starts the gateway which routes to all internal services
CMD ["ocis", "server"]