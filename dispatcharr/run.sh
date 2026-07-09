#!/bin/sh
set -e

OPTIONS_FILE=/data/options.json

get_option() {
    python3 -c "import json,sys
try:
    print(json.load(open('$OPTIONS_FILE')).get('$1', ''))
except Exception:
    print('')" 2>/dev/null
}

LOG_LEVEL="$(get_option log_level)"
[ -z "$LOG_LEVEL" ] && LOG_LEVEL="info"

# Run Dispatcharr in all-in-one mode: the upstream entrypoint starts
# PostgreSQL, Redis, Celery and the web app inside this single container.
export DISPATCHARR_ENV=aio
export REDIS_HOST=localhost
export CELERY_BROKER_URL=redis://localhost:6379/0
export DISPATCHARR_LOG_LEVEL="$LOG_LEVEL"

echo "[dispatcharr-addon] Starting Dispatcharr (log level: $LOG_LEVEL)"
echo "[dispatcharr-addon] Data is persisted in /data (add-on storage)"

exec /app/docker/entrypoint.sh
