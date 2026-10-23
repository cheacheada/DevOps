# 3주차: 리눅스 셸 스크립팅

## 핵심 개념
셸 스크립트는 터미널에서 반복하던 명령을 파일로 저장한 것이다. `#!/usr/bin/env bash`는 Bash로 해석하도록 지정한다. `chmod u+x`로 실행 권한을 부여하고 `./backup.sh`로 실행한다. 현재 디렉터리가 PATH에 없기 때문에 파일명만 입력하면 실행되지 않을 수 있다.

## 실습
```bash
cd week03
mkdir -p sample
printf 'Linux backup practice\n' > sample/note.txt
chmod u+x backup.sh
bash -n backup.sh
./backup.sh sample
tar -tzf "$(ls -t backups/*.tar.gz | head -1)"
./backup.sh missing-directory  # 오류 메시지, 종료 코드 1 확인
```

## 코드 설명
`$1`은 첫 번째 인자이고 `${1:-sample}`은 인자가 없을 때 기본값을 사용한다. 디렉터리 검사 실패 시 `exit 1`로 종료한다. 경로를 큰따옴표로 감싸 공백이 포함된 경로도 하나의 인자로 전달한다. `date`는 파일명에 시각을 넣고 `tar -czf`는 gzip 압축 파일을 만든다. `set -euo pipefail`로 실패를 가능한 일찍 드러낸다.

## 배운 점
명령을 나열하는 것만으로 자동화가 완성되지는 않는다. 잘못된 인자와 경로를 먼저 확인해야 한다. 이 반복 실행 개념을 7주차의 컨테이너 상태 복구에 연결했다.

실제 실행 기록: [evidence/linux-checks.txt](../evidence/linux-checks.txt). 강의자료: 제공된 2주차.pdf의 '02. 셸 스크립팅' (표지상 3주차).
