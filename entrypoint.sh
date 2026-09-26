#!/bin/sh
# Writes the Cerbos config from environment variables, then starts the PDP.
set -eu

: "${CERBOS_ADMIN_USERNAME:=admin}"
: "${CERBOS_ADMIN_PASSWORD:?set CERBOS_ADMIN_PASSWORD}"
: "${CERBOS_HTTP_PORT:=3592}"
: "${CERBOS_GRPC_PORT:=3593}"

mkdir -p "$CERBOS_DATA_DIR"
[ "$(stat -c %u "$CERBOS_DATA_DIR")" = 10001 ] || chown -R cerbos:cerbos "$CERBOS_DATA_DIR"

# Cerbos expects the bcrypt hash of the admin password, base64-encoded.
hash=$(htpasswd -bnBC 10 "" "$CERBOS_ADMIN_PASSWORD" | tr -d ':\n' | base64 -w0)

cat > /tmp/cerbos.yaml <<CONF
server:
  httpListenAddr: "[::]:${CERBOS_HTTP_PORT}"
  grpcListenAddr: "[::]:${CERBOS_GRPC_PORT}"
  adminAPI:
    enabled: true
    adminCredentials:
      username: "${CERBOS_ADMIN_USERNAME}"
      passwordHash: "${hash}"
storage:
  driver: sqlite3
  sqlite3:
    dsn: "file:${CERBOS_DATA_DIR}/cerbos.sqlite?mode=rwc&_fk=true"
telemetry:
  disabled: true
CONF
chown cerbos:cerbos /tmp/cerbos.yaml
chmod 600 /tmp/cerbos.yaml

if [ "$#" -eq 0 ]; then set -- server; fi
exec su-exec cerbos cerbos "$@" --config=/tmp/cerbos.yaml
