#!/bin/sh
set -e

OPTIONS_FILE=/data/options.json

get_option() {
    python3 -c "import json
try:
    v = json.load(open('$OPTIONS_FILE')).get('$1', '')
    if isinstance(v, bool):
        print('true' if v else 'false')
    elif v is None:
        print('')
    else:
        print(v)
except Exception:
    print('')" 2>/dev/null
}

LOG_LEVEL="$(get_option log_level)"
[ -z "$LOG_LEVEL" ] && LOG_LEVEL="info"

# Dispatcharr runs as the 'dispatch' user with this UID/GID (upstream default)
PUID=1000
PGID=1000

# --- Optional CIFS mount ----------------------------------------------------
# Home Assistant mounts its own network storage root-only, so Dispatcharr
# (UID 1000) cannot write there. Mounting the share ourselves with uid=1000
# gives Dispatcharr full write access at /mnt/remote.
CIFS_MOUNT="$(get_option cifs_mount)"
if [ "$CIFS_MOUNT" = "true" ]; then
    CIFS_HOST="$(get_option cifs_host)"
    CIFS_SHARE="$(get_option cifs_share)"
    CIFS_USERNAME="$(get_option cifs_username)"
    CIFS_PASSWORD="$(get_option cifs_password)"

    if [ -z "$CIFS_HOST" ] || [ -z "$CIFS_USERNAME" ]; then
        echo "[dispatcharr-addon] WARNING: cifs_mount is enabled but cifs_host/cifs_username is empty — skipping mount"
    else
        MOUNTPOINT=/mnt/remote
        mkdir -p "$MOUNTPOINT"
        # Credentials via file, so the password never shows up in 'ps' or logs
        CREDFILE=/tmp/.cifs-credentials
        umask 077
        printf 'username=%s\npassword=%s\n' "$CIFS_USERNAME" "$CIFS_PASSWORD" > "$CREDFILE"
        umask 022
        echo "[dispatcharr-addon] Mounting //${CIFS_HOST}/${CIFS_SHARE} at ${MOUNTPOINT} (uid=${PUID})"
        if mount -t cifs "//${CIFS_HOST}/${CIFS_SHARE}" "$MOUNTPOINT" \
            -o "credentials=${CREDFILE},uid=${PUID},gid=${PGID},file_mode=0664,dir_mode=0775,vers=3.0,iocharset=utf8,noserverino"; then
            echo "[dispatcharr-addon] CIFS share mounted — use ${MOUNTPOINT}/... as path inside Dispatcharr"
        else
            echo "[dispatcharr-addon] ERROR: CIFS mount failed — check cifs_* options and the add-on log above"
        fi
        rm -f "$CREDFILE"
    fi
fi

# --- Writable folder on /share ----------------------------------------------
# /share is root-owned on the host; give Dispatcharr its own writable subdir
mkdir -p /share/dispatcharr
chown "$PUID:$PGID" /share/dispatcharr 2>/dev/null || true

# --- Start Dispatcharr (all-in-one) -------------------------------------------
# The upstream entrypoint starts PostgreSQL, Redis, Celery and the web app
# inside this single container.
export DISPATCHARR_ENV=aio
export REDIS_HOST=localhost
export CELERY_BROKER_URL=redis://localhost:6379/0
export DISPATCHARR_LOG_LEVEL="$LOG_LEVEL"
export PUID="$PUID"
export PGID="$PGID"

echo "[dispatcharr-addon] Starting Dispatcharr (log level: $LOG_LEVEL)"
echo "[dispatcharr-addon] Data is persisted in /data (add-on storage)"

exec /app/docker/entrypoint.sh
