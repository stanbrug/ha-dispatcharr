# Home Assistant add-on wrapper around the official Dispatcharr all-in-one image.
# BUILD_FROM is passed by the Supervisor builder but intentionally unused:
# we base directly on the upstream image so the add-on always runs the real app.
ARG BUILD_FROM
FROM ghcr.io/dispatcharr/dispatcharr:latest

# cifs-utils is needed for the optional in-container CIFS mount (network
# storage with write access for the non-root dispatch user, UID 1000)
RUN apt-get update \
    && apt-get install -y --no-install-recommends cifs-utils \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
# Normalize line endings in case the repo was checked out on Windows (CRLF)
RUN sed -i 's/\r$//' /run.sh && chmod a+x /run.sh

ENTRYPOINT []
CMD ["/run.sh"]
