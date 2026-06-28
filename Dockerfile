# Thin wrapper around the official ownCloud Infinite Scale single binary.
# The official image's ENTRYPOINT is /usr/bin/ocis with CMD ["server"], which
# fails on first boot because no ocis.yaml config exists yet: oCIS requires a
# one-time `ocis init` to generate the jwt_secret and other service secrets
# before `ocis server` will start.
#
# We run `ocis init` at BUILD time so the generated /etc/ocis/ocis.yaml (with
# secrets) is baked into the image with the correct ownership for the non-root
# oCIS user. This avoids the runtime "permission denied" on /etc/ocis that
# happens when init tries to write into a root-owned mounted volume. The
# nexlayer.yaml therefore does NOT mount a volume over /etc/ocis.
FROM mirror.gcr.io/owncloud/ocis:8.0.5

ENV OCIS_INSECURE="true" \
    PROXY_TLS="false" \
    PROXY_HTTP_ADDR="0.0.0.0:9200" \
    IDM_CREATE_DEMO_USERS="true" \
    IDM_ADMIN_PASSWORD="admin"

# Generate the config (jwt_secret, machine auth, transfer secret, service
# accounts, demo admin) into the image at build time. PROXY_TLS=false is set
# above so the proxy serves plain HTTP behind the Nexlayer edge (which
# terminates TLS) instead of speaking TLS itself.
RUN ocis init --insecure yes

ENTRYPOINT ["/usr/bin/ocis"]
CMD ["server"]
