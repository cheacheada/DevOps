# 6주차: Dockerfile과 방명록 이미지

## Dockerfile 이해
| 명령 | 역할 |
|---|---|
| FROM python:3.12-slim | Linux 기반 Python 실행 환경 선택 |
| WORKDIR /app | 이후 명령의 작업 경로 지정 |
| COPY requirements.txt . | 의존성 목록을 먼저 복사 |
| RUN pip install ... | 이미지 빌드 시 의존성 설치 |
| COPY . . | 애플리케이션 복사 |
| USER appuser | 일반 사용자 권한으로 실행 |
| ENV | 기본 환경변수 설정 |
| EXPOSE 5000 | 사용할 포트 정보 선언 |
| CMD | 컨테이너 시작 시 실행할 명령 |

자주 바뀌는 코드를 의존성 설치 뒤에 복사하면 빌드 캐시를 재사용하기 쉽다. EXPOSE만으로 호스트에 포트가 공개되지는 않는다.

## Linux 실행 명령
```bash
cd guestbook
docker build -t devops-guestbook:midterm .
docker run -d --name midterm-memory -p 18081:5000 devops-guestbook:midterm
curl http://localhost:18081/healthz
docker logs midterm-memory
docker exec midterm-memory id
docker stop midterm-memory
docker rm midterm-memory
```

## 저장 방식과 배운 점
메모리 모드에서는 프로세스 재시작 시 글이 사라진다. 환경변수로 제목과 테마를 바꿀 수 있지만 데이터 지속성은 별도의 저장소가 필요하다. 7주차에서 Redis와 named volume을 사용해 이를 해결했다. GHCR push는 이번 제출 실습 범위에서 수행하지 않았으며 실행했다고 주장하지 않는다.

실제 빌드·실행 기록: [docker-checks.txt](../evidence/docker-checks.txt). 강의자료: DevOps_06_도커파일.pdf.
