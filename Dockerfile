FROM mirror.gcr.io/owncloud/ocis:latest

USER root
# Minimal setup to avoid crash on startup
RUN mkdir -p /var/lib/ocis && chown -R 1000:1000 /var/lib/ocis

# OCIS requires specific environment variables to run in a containerized/automated environment
# OCIS_INSECURE allows skipping HTTPS internally for the gateway
ENV OCIS_INSECURE=true
ENV OCIS_STORAGE_PATH=/var/lib/ocis
ENV OCIS_LOG_LEVEL=info

# This is the critical variable to avoid the interactive setup process causing 503s
ENV OCIS_BOOTSTRAP_SESSIONS_ENABLED=true

# Use the default user provided by the image to avoid permission issues
USER 1000

EXPOSE 9200

# Use the wrapper script provided by the image rather than calling the binary directly
# the image entrypoint is usually 'ocis server', but we explicitly define it here
CMD ["ocis", "server"]
