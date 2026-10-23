#!/usr/bin/env bash
set -Eeuo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
interval="${INTERVAL:-5}"
[[ "$interval" =~ ^[1-9][0-9]*$ ]] || { echo 'INTERVAL must be a positive integer' >&2; exit 2; }
exec 9>.reconcile.lock
flock -n 9 || { echo 'Another reconciler is running' >&2; exit 1; }
trap 'exit 0' INT TERM
docker compose config --quiet
while true; do
    # Compose는 일회성 명령이므로 반복 실행으로 원하는 상태를 다시 요청한다.
    # 재빌드/이미지 다운로드 없이 기존 web 이미지를 사용한다.
    if docker compose up -d --no-deps --no-build --pull never --scale web=3 web; then
        ids=$(docker compose ps --status running -q web)
        count=$(printf '%s\n' "$ids" | grep -c . || true)
        printf '[%s] running_web=%s target=3\n' "$(date -Iseconds)" "$count"
    else
        printf '[%s] reconcile failed; retry later\n' "$(date -Iseconds)" >&2
    fi
    [[ "${ONCE:-0}" == 1 ]] && break
    sleep "$interval" & wait $!
done
