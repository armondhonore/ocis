# Thin wrapper around the official ownCloud Infinite Scale single binary.
# The official image's ENTRYPOINT is /usr/bin/ocis with CMD ["server"], which
# fails on first boot because no ocis.yaml config exists yet. oCIS requires a
# one-time `ocis init` to generate secrets before `ocis server` will start.
# This wrapper runs init (idempotent) then exec's the server, so a fresh
# deployment with an empty config volume comes up cleanly.
FROM mirror.gcr.io/owncloud/ocis:8.0.5

ENV OCIS_INSECURE="true" \
    PROXY_HTTP_ADDR="0.0.0.0:9200" \
    IDM_CREATE_DEMO_USERS="true" \
    IDM_ADMIN_PASSWORD="admin"

# Reset the entrypoint so our script controls startup. The official image runs
# as a non-root user with /etc/ocis and /var/lib/ocis writable.
ENTRYPOINT ["/bin/sh", "-c", "ocis init || true; exec ocis server"]
