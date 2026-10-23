# 7주차: Docker Compose와 web=3 복구

## 구성
브라우저 localhost:8080에서 nginx로 접속한다. nginx는 내부 DNS의 `web:5000`으로 요청을 전달한다. web 3개는 하나의 Redis를 공유한다. Redis 데이터는 named volume `redis-data`에 기록한다.

```bash
cd guestbook
cp .env.example .env
# .env의 비밀번호를 수정한다. 이 파일을 커밋하지 않는다.
docker compose config --quiet
docker compose up -d --build --scale web=3 --wait --wait-timeout 180
docker compose ps
for i in $(seq 1 12); do curl -fsS http://localhost:8080/healthz; echo; done
```

## 48쪽 문제: 항상 web=3 유지하기
`restart: unless-stopped`는 비정상 종료에는 유용하지만 `docker stop`으로 직접 중지한 컨테이너를 자동으로 살리지 않는다. `always`로 바꾸는 것만으로도 수동 중지 직후 복구를 보장할 수 없다. Compose의 `up --scale web=3`도 실행 시점의 상태를 맞추는 일회성 명령이다.

수업의 셸 반복문과 프로세스 개념을 이용해 5초마다 `up -d --no-deps --no-build --pull never --scale web=3 web`을 실행한다. 중지된 컨테이너를 시작하거나 부족한 컨테이너를 생성한다. `flock`으로 중복 감시기를 막고, 실패 시 다음 주기에 재시도한다. 상세 코드는 [reconcile-web.sh](../guestbook/reconcile-web.sh).

```bash
# 터미널 A: 먼저 전체 스택을 정상 기동한 뒤 실행
cd guestbook
bash reconcile-web.sh
# 터미널 B: 실습용 프로젝트의 web 하나만 중지
id=$(docker compose ps -q web | head -1)
docker stop "$id"
sleep 8
docker compose ps
# 터미널 A에서 Ctrl+C로 감시 종료
```

## 장점·단점·한계
- 장점: Bash와 Compose만 사용한다. 명령과 로그가 단순하고 학습 내용을 직접 연결할 수 있다.
- 단점: 최대 감시 간격과 컨테이너 시작 시간만큼 복구가 지연된다. 매 주기 Compose 명령을 실행하는 비용이 있다. 정비를 위해 중지해도 다시 살아나므로 먼저 감시기를 종료해야 한다.
- 한계: 실행 중이지만 unhealthy인 컨테이너를 재생성하지 않는다. running=3과 healthy=3은 다르다. 감시기 종료, Docker 데몬 또는 호스트 장애 시 복구하지 못한다. 순간적으로 2개가 되는 것을 막을 수 없으므로 '항상'은 장애 후 목표 개수로 수렴한다는 의미다. 무중단·다중 서버·자동 확장이 필요한 운영 환경에는 별도 오케스트레이터가 필요하다.

## 볼륨과 비밀번호
`docker compose down`은 컨테이너와 네트워크를 지우지만 named volume은 남긴다. 다시 up하면 글이 유지된다. `down -v`는 named volume까지 지우므로 글이 사라진다. 실제 데이터에서 함부로 실행하면 안 된다. `.env`는 비밀번호를 포함하므로 Git에 올리지 않고 키 이름을 보여주는 `.env.example`만 공유한다. `.env` 분리는 저장소 유출 방지이며 컨테이너 관리자에게까지 비밀을 숨겨주지는 않는다.

## 검증과 출처
실제 검증: [docker-checks.txt](../evidence/docker-checks.txt), [recovery.txt](../evidence/recovery.txt). 실행 당시 결과와 설명용 명령을 구분했다.
강의자료: DevOps_07_도커_컴포즈.pdf 43-48, 61쪽.
공식 문서: https://docs.docker.com/engine/containers/start-containers-automatically/ 및 https://docs.docker.com/reference/cli/docker/compose/up/ (2026-10-23 확인).
