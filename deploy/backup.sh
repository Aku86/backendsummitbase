#!/usr/bin/env bash
set -euo pipefail

APP_DIR="${APP_DIR:-/var/www/summit-base}"
BACKUP_DIR="${BACKUP_DIR:-$APP_DIR/backups}"
ENV_FILE="${ENV_FILE:-$APP_DIR/.env}"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="$BACKUP_DIR/summit-base-$STAMP.archive.gz"

mkdir -p "$BACKUP_DIR"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "ENV file tidak ditemukan: $ENV_FILE" >&2
  exit 1
fi

# Load only for this process; jangan commit file .env.
set -a
source "$ENV_FILE"
set +a

: "${MONGODB_URI:?MONGODB_URI wajib diisi}"
: "${MONGODB_DB:?MONGODB_DB wajib diisi}"

if ! command -v mongodump >/dev/null 2>&1; then
  echo "mongodump tidak ditemukan. Install MongoDB Database Tools terlebih dahulu." >&2
  exit 1
fi

mongodump \
  --uri="$MONGODB_URI" \
  --db="$MONGODB_DB" \
  --archive="$OUT" \
  --gzip

find "$BACKUP_DIR" -type f -name 'summit-base-*.archive.gz' -mtime +14 -delete

echo "Backup selesai: $OUT"
