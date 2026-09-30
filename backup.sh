#!/usr/bin/env bash
set -euo pipefail
SOURCE="${1:-README.md}"
mkdir -p backups
FILENAME="backup-$(date +%Y%m%d-%H%M%S).tar.gz"
tar -czf "backups/$FILENAME" -- "$SOURCE"
SIZE=$(du -h "backups/$FILENAME" | cut -f1)
echo "Backup complete! (size: $SIZE)"
