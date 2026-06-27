FROM mirror.gcr.io/owncloud/ocis:latest

USER root
RUN apk add --no-cache attr ca-certificates curl mailcap tree vips || true
RUN echo 'hosts: files dns' > /etc/nsswitch.conf

ENV OCIS_URL=https://relaxed-weasel-ocis.cloud.nexlayer.ai
ENV OCIS_INSECURE=true

# Ensure we run as the user expected by the official image if applicable, 
# but OCIS typically handles its own user switching in the entrypoint.
USER ocis