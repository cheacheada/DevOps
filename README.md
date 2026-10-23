# DevOps 리눅스 중간 종합 평가

Ubuntu 24.04 LTS (WSL2)에서 셸, 네트워크, Dockerfile, Docker Compose를 실습한 기록이다.

공개 저장소: https://github.com/cheacheada/DevOps

## 주차별 정리
- [3주차 셸 스크립팅](week03/README.md)
- [4주차 네트워크](week04/README.md)
- [6주차 Dockerfile](week06/README.md)
- [7주차 Compose 및 web=3 복구](week07/README.md)

## 실행
```bash
cd guestbook
cp .env.example .env
# .env 비밀번호 수정
docker compose up -d --build --scale web=3 --wait
bash reconcile-web.sh
```

감시기를 끄려면 Ctrl+C를 누른다. 정비/종료 전 감시기를 먼저 끄고 `docker compose down`을 실행한다. 볼륨을 삭제하지 않으면 Redis 데이터가 남는다.

## 제출 자료
`evidence/`는 실제 Linux 실행 로그다. `report/`에는 제출용 보고서와 Issue부터 Merge까지 설명한 PPT 한 장을 둔다. 수업 제공 방명록 코드를 바탕으로 Compose 및 복구 스크립트를 추가했다.

강의자료 파일명과 표지 주차가 다른 경우 표지에 적힌 수업 주차와 주제를 기준으로 정리했다. 개인 실습 결과는 원문 로그와 GitHub 기록으로 확인한다.
