# Official Cerbos binary (pinned by digest) on Alpine, so the entrypoint can
# hash the admin password and write the config from environment variables.
FROM cerbos/cerbos:0.55.0@sha256:4b9d3b58c4f11c1b8953bc798d8d086e64f276882253ab169625fddc7f432515 AS cerbos

FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6
RUN apk add --no-cache apache2-utils ca-certificates su-exec tzdata \
 && adduser -D -H -u 10001 cerbos
COPY --from=cerbos /cerbos /usr/local/bin/cerbos
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENV CERBOS_DATA_DIR=/data
EXPOSE 3592 3593
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
