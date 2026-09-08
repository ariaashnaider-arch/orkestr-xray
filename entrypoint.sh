#!/bin/sh
set -eu

PORT="${PORT:-8080}"

if [ -z "${XRAY_UUID:-}" ]; then
  echo "XRAY_UUID is required" >&2
  exit 1
fi

if [ -z "${XHTTP_PATH:-}" ]; then
  echo "XHTTP_PATH is required" >&2
  exit 1
fi

case "$XHTTP_PATH" in
  /*) ;;
  *) XHTTP_PATH="/$XHTTP_PATH" ;;
esac

sed   -e "s|__PORT__|$PORT|g"   -e "s|__UUID__|$XRAY_UUID|g"   -e "s|__XHTTP_PATH__|$XHTTP_PATH|g"   /etc/xray/config.template.json > /tmp/config.json

exec /usr/local/bin/xray run -c /tmp/config.json
