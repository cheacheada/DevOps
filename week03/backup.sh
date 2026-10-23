#!/usr/bin/env bash
set -euo pipefail
source_dir="${1:-sample}"
[[ -d "$source_dir" ]] || { echo "Not a directory: $source_dir" >&2; exit 1; }
mkdir -p backups
archive="backups/backup-$(date +%Y%m%d-%H%M%S)-$$.tar.gz"
tar -czf "$archive" -- "$source_dir"
printf '[%s] Backup complete! (file: %s, size: %s)\n' "$(date +%H:%M:%S)" "$archive" "$(du -h "$archive" | cut -f1)"
