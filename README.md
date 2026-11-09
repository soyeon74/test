# 코디세이 스터디 출석부

## 1. 프로젝트 소개

이 프로젝트는 코디세이 올인원 온보딩 실습을 위한 Python 기반 스터디 출석부 프로그램입니다.

교육장과 집이라는 두 개발환경에서 동일한 프로젝트를 사용하면서 CLI, Git, GitHub, Docker의 기본 명령어와 개발 협업 과정을 학습하는 것을 목표로 합니다.

주요 실습 목표는 다음과 같습니다.

- CLI를 이용한 파일 및 폴더 관리
- Python 출석부 프로그램 제작 및 실행
- GitHub를 이용한 코드 업로드와 다운로드
- Git 브랜치 생성 및 병합
- Docker를 이용한 별도 Python 설치 없는 프로그램 실행
- 바인드 마운트를 통한 출석 기록 유지
- Git 충돌 발생 및 해결

실제 교육장 PC의 작업 환경이 초기화되어, 이후에는 별도 PC에 교육장 폴더를 재구성하여 실습을 이어 진행했습니다.

## 2. 주요 기능

`attend.py`에서 제공하는 기능은 다음과 같습니다.

1. 출석 등록: 이름을 입력하면 날짜와 함께 기록합니다.
2. 출석 목록 보기: CSV에 저장된 기록을 조회합니다.
3. 출석 횟수 확인: 이름별 출석 횟수를 집계합니다.
4. 종료: 출석부 프로그램을 종료합니다.

출석 정보는 `attendance.csv` 파일에 저장합니다.

현재 구현한 것은 **이름별 출석 횟수 조회**이며, 전체 출석률(%) 계산은 구현 완료 범위에 포함하지 않습니다.

## 3. 개발환경

실습에서 사용한 도구는 다음과 같습니다.

- 운영체제: Windows
- 터미널: PowerShell, Docker 내부 bash
- 개발 도구: Visual Studio Code
- Git: 2.56.0.windows.4
- Python: 교육장 초기 실습에서 3.15 사용
- Docker: Docker Desktop, Python 3.12 slim 이미지
- 원격 저장소: GitHub

GitHub 저장소:

https://github.com/soyeon74/test

교육장과 집 환경을 다음 폴더로 구분했습니다.

- 교육장: `C:\test\교육장`
- 집: `C:\test\집`

## 4. 교육장 실행 방법

교육장 폴더로 이동합니다.

```powershell
cd C:\test\교육장
```

Python 설치 상태에 따라 다음 명령 중 사용할 수 있는 것을 선택하여 실행합니다.

```powershell
py -3.15 attend.py
```

또는:

```powershell
py attend.py
```

프로그램 실행 후 1번 출석 등록, 2번 출석 목록, 3번 출석 횟수, 4번 종료 기능을 사용할 수 있습니다.

## 5. 집에서 Docker로 실행하기

집 환경에서는 Windows에 Python을 별도로 설치하지 않고 Docker의 Python 이미지를 이용했습니다.

먼저 집 폴더로 이동합니다.

```powershell
cd C:\test\집
```

다음 명령으로 Docker 컨테이너를 실행합니다.

```powershell
docker run -it --rm -v "${PWD}:/app" -w /app python:3.12-slim bash
```

주요 옵션의 의미는 다음과 같습니다.

- `-it`: 대화형 터미널 사용
- `--rm`: 컨테이너 종료 후 자동 제거
- `-v "${PWD}:/app"`: Windows 현재 폴더를 컨테이너 내부 `/app`에 연결
- `-w /app`: 컨테이너의 시작 작업 폴더 지정
- `python:3.12-slim`: 사용할 Python 이미지
- `bash`: 컨테이너에서 실행할 셸

컨테이너에 들어가면 다음 명령으로 파일을 확인하고 프로그램을 실행합니다.

```bash
ls
python --version
python attend.py
```

프로그램 종료 후 Docker에서 나오려면 다음을 입력합니다.

```bash
exit
```

## 6. Docker 바인드 마운트 검증

`attendance.csv`는 GitHub에 업로드하지 않는 로컬 출석 기록 파일입니다.

Docker 컨테이너에서 출석을 등록하고 종료한 다음 Windows PowerShell에서 파일을 확인했습니다.

```powershell
Get-Content attendance.csv -Encoding UTF8
```

실제 확인한 실습 데이터:

```text
날짜,이름
2026-11-03,2
2026-11-03,2
```

출석 횟수 조회 결과:

```text
=== 이름별 출석 횟수 ===
2: 2회
```

숫자 `2`가 이름으로 기록된 것은 실습 입력 과정에서 발생한 데이터이며, 실제 사용자 이름을 의미하지 않습니다.

첫 번째 Docker 컨테이너를 종료한 뒤 새 컨테이너를 생성해도 기록이 유지되는 것을 확인했습니다.

**검증 결과:** Docker 컨테이너가 삭제되더라도 바인드 마운트로 연결한 Windows 호스트 폴더의 CSV 파일은 유지되었습니다.

## 7. GitHub 협업 실습

GitHub의 `test` 저장소를 교육장과 집 환경에 각각 복제했습니다.

최초 복제 명령:

```powershell
git clone https://github.com/soyeon74/test.git .
```

변경사항을 저장하고 업로드하는 명령:

```powershell
git status
git add attend.py
git commit -m "Update attendance message"
git push origin main
```

다른 컴퓨터에서 최신 내용을 가져오는 명령:

```powershell
git pull origin main
```

교육장에서 출석부를 개발해 GitHub에 업로드한 후, 집에서 저장소를 받아 수정했습니다.

집에서 수정한 출석 완료 안내 문구는 커밋 `1fbee07`로 GitHub에 업로드했습니다.

이후 가상 교육장 폴더에 저장소를 다시 복제하여 해당 커밋과 프로그램 실행을 확인했습니다.

## 8. Git 브랜치 생성 및 병합 실습

기존 `main` 브랜치에서 `feature-attendance-rate` 브랜치를 생성했습니다.

```powershell
git switch -c feature-attendance-rate
```

이 브랜치에서 출석 횟수 확인 기능을 추가하고 커밋했습니다.

```powershell
git add attend.py
git commit -m "출석 횟수 확인 기능 추가"
```

그다음 `main`으로 이동하여 병합했습니다.

```powershell
git switch main
git merge feature-attendance-rate
```

실습 결과 Fast-forward 방식으로 병합되었고, 출석 횟수 확인 기능이 `main`에 반영되었습니다.

해당 기능 커밋은 `c94281a`입니다.

## 9. Git 충돌 발생 및 해결 실습

기존 출석부에 영향을 주지 않도록 충돌 실습용 브랜치와 파일을 별도로 사용했습니다.

사용한 브랜치:

- `practice-conflict`
- `practice-conflict-b`

실습용 파일:

`conflict-practice.txt`

공통 커밋 `f084f7b`에서 두 브랜치가 분리되었고, 동일한 줄을 서로 다르게 수정했습니다.

A버전:

```text
출석 확인: A버전
```

B버전:

```text
출석 확인: B버전
```

두 브랜치를 병합하는 과정에서 다음 충돌 표시가 발생했습니다.

```text
<<<<<<< HEAD
출석 확인: A버전
=======
출석 확인: B버전
>>>>>>> practice-conflict-b
```

최초에는 충돌 표시를 제거하지 않고 `git add`와 `git commit`을 실행하여, Git이 병합 완료로 인식했지만 파일 내용에는 충돌 표시가 남아 있었습니다.

이를 확인한 후 다음과 같이 내용을 정리했습니다.

```text
출석 확인: A버전과 B버전 통합 완료
```

수정 내용을 다시 저장했습니다.

```powershell
git add conflict-practice.txt
git commit -m "충돌 표시 제거 및 통합 문구 정리"
```

최종 정리 커밋은 `5c5c1a0`입니다.

`git status`에서 `nothing to commit, working tree clean`을 확인했습니다.

이 실습을 통해 Git의 병합 상태가 정상이라는 사실과, **파일 내용까지 올바르게 해결되었다는 사실은 구분해서 검증해야 한다**는 점을 배웠습니다.

충돌 실습은 별도 브랜치에 보존하여 기존 `main`의 출석부 프로그램을 유지했습니다.

## 10. 실제 발생한 오류와 해결 방법

### 사례 1. Python 명령어 인식 오류

문제: 교육장 초기 환경에서 `python` 명령어로 실행하기 어려운 상황이 발생했습니다.

해결: 설치된 Python 버전을 확인하고 `py -3.15` 명령으로 실행했습니다.

### 사례 2. GitHub 저장소 복제 실패

문제: 초기 실습에서 `Repository not found` 오류가 발생했습니다.

해결: GitHub에 `test` 저장소를 생성한 후 올바른 주소로 복제했습니다.

### 사례 3. Git 명령어를 찾지 못함

문제: 집 컴퓨터 PowerShell에서 `git` 명령을 인식하지 못했습니다.

Git이 설치된 경로를 확인한 뒤 현재 터미널의 PATH에 추가하여 해결했습니다.

```powershell
$env:Path += ";C:\Program Files\Git\cmd"
```

### 사례 4. Docker에서 Git 명령 실행 오류

문제:

```text
bash: git: command not found
```

원인: 사용한 Python 컨테이너 이미지에 Git이 설치되어 있지 않았습니다.

해결: `exit`로 Windows PowerShell로 돌아와 Git 명령을 실행했습니다.

### 사례 5. Git 작성자 정보 오류

문제:

```text
Author identity unknown
```

원인: 집 컴퓨터의 Git 커밋 작성자 정보 설정이 완료되지 않은 상태였습니다.

해결: Git 작성자 정보를 설정하고 커밋을 다시 실행했습니다.

```powershell
git config --global user.name "작성자이름"
git config --global user.email "본인이메일"
```

### 사례 6. Git 충돌이 해결되지 않은 상태

문제:

```text
cannot switch branch while merging
```

원인: 충돌 해결이 끝나지 않은 병합 작업이 진행 중이었습니다.

해결: 충돌 파일의 내용을 확인하고 최종 문구로 정리한 후 저장했습니다.

## 11. 최종 실습 검증 결과

| 실습 항목 | 결과 |
|---|---|
| CLI 기본 명령 사용 | 완료 |
| GitHub 저장소 복제 | 완료 |
| Python 출석부 제작 | 완료 |
| 출석 등록·조회·횟수 확인 | 완료 |
| 교육장 Python 실행 | 완료 |
| Docker 컨테이너 실행 | 완료 |
| Docker 바인드 마운트 | 완료 |
| 컨테이너 재생성 후 출석 기록 유지 | 완료 |
| Git commit 및 push | 완료 |
| 집에서 수정한 코드의 교육장 반영 | 완료 |
| Git 기능 브랜치 생성 및 병합 | 완료 |
| Git 충돌 발생 및 내용 정리 | 완료 |
| README 최종 정리 | 완료 후 GitHub 업로드 필요 |

## 12. 학습 내용 및 소감

이번 실습을 통해 CLI, Git, GitHub, Docker가 서로 어떤 역할을 하는지 이해할 수 있었습니다.

특히 Git의 `commit`은 내 컴퓨터에 변경 이력을 저장하는 작업이고, `push`는 그 기록을 GitHub에 업로드하는 작업이라는 점을 배웠습니다.

또한 Docker를 사용하면 Windows에 Python을 별도로 설치하지 않고도 Python 프로그램을 실행할 수 있으며, 바인드 마운트를 이용하면 컨테이너를 삭제한 뒤에도 출석 기록을 유지할 수 있다는 점을 직접 확인했습니다.

Git 충돌 실습에서는 Git 명령이 성공했다고 해서 파일 내용까지 반드시 올바른 것은 아니므로, 최종 결과를 직접 검증하는 과정이 중요하다는 것을 배웠습니다.

## 13. 향후 개선 방향

현재 구현되지 않은 추가 개선 과제는 다음과 같습니다.

- 출석률(%) 계산 기능
- 중복 출석 처리 기준 개선
- 이름 입력값 검증
- 출석 데이터 조회 기능 개선

이번 온보딩에서는 CLI·Git·Docker를 이용한 개발환경 구성과 코드 공유 및 실행 검증을 중심으로 실습을 완료했습니다.

---

## 14. 개발 워크스테이션 재평가 보완 (2026-11-09)

> **실제 명령과 출력 증거:** [2026-11-09 워크스테이션 검증 로그](evidence/2026-11-09-workstation-logs.md). 2026-11-09 추가된 Dockerfile과 웹 소스는 이 저장소 루트에서 확인할 수 있습니다. 실습 여부와 제출 증거 보유 여부를 구분합니다.

### 실행 환경 및 구조

- Windows PowerShell, Docker Desktop Linux(WSL2), Ubuntu 24.04 bash
- Docker Client/Server **29.9.2**, 컨텍스트 **desktop-linux**
- Git **2.56.0.windows.4** (기존 실습 기록; 현재 버전 재확인은 필요)
- 웹 베이스 이미지: **nginx:alpine**
- 기존 출석부: 'attend.py', 로컬 데이터 'attendance.csv' (GitHub 비업로드)

\`\`\`text
test/
├── README.md                            # 과제 설명, 개념, 재현 순서
├── attend.py                            # 기존 출석부 프로그램
├── Dockerfile                           # NGINX 커스텀 이미지 제작 설정
├── site/index.html                      # Docker 웹 서버용 정적 페이지
└── evidence/2026-11-09-workstation-logs.md  # 실습 실제 출력 발췌
\`\`\`

### 평가 항목별 보완 증거

| 평가 | 상태 | 근거 및 남은 확인 |
|---|---|---|
| #1 CLI | 실행 확인 | 폴더·파일 생성, 내용 확인, 복사, 이름변경, 삭제 |
| #2 권한 | 실행 확인 | 파일 chmod 600→644, 디렉터리 700→755, ls 출력 |
| #3 데몬 | 실행 확인 | docker --version / docker info 서버 29.9.2 |
| #4 hello-world | 실행 확인 | Hello from Docker! |
| #5 이미지·컨테이너 | 실행 확인 | docker images, ps -a, logs, stats |
| #6 Dockerfile 빌드 | 실행 확인 | workstation-web:1.0 생성 |
| #7 포트 매핑 | 실행 확인 | 8080·8081 포트, 8081 HTTP 응답 |
| #8 바인드 마운트 | 기존 README 통과 | 컨테이너 변경 후 CSV 유지 기록; 명령 전후 원본 로그 보강 권장 |
| #9 Git | 기존 README 통과 | clone, commit, push, pull 기록; config/remote 출력 보강 권장 |
| #10 폴더 구조 | 문서 보완 | 위 트리와 역할 설명 |
| #11 재현 방법 | 문서 보완 | 아래 빌드/실행/접속 명령 |
| #12 이미지/컨테이너 | 개념 보완 | 아래 6개 학습 개념 |
| #13 네트워크 | 개념 보완 | 아래 포트 매핑 설명 |
| #14 절대/상대 경로 | 개념 보완 | 아래 경로 설명 |
| #15 권한 계산 | 개념 보완 | 아래 rwx 설명 |
| #16 포트 충돌 | **사용자 실습 완료 진술** | 해당 실험 실제 출력 로그는 아직 미확보 |
| #17 named volume | **추가 검증 필요** | 바인드 마운트 성공과 별개로 Docker 볼륨 출력 미확보 |
| #18 문제 해결 | 실행 확인 | Dockerfile 누락→파일 생성→빌드 성공 및 기존 Git 충돌 사례 |

실제 재평가의 통과/점수는 평가 도구의 판단에 따릅니다. 현재 자료가 없는 실습은 실제로 완료한 것으로 기재하지 않았습니다.

### 재현 순서

\`\`\`powershell
git clone https://github.com/soyeon74/test.git
cd test
docker --version
docker info --format '{{.ServerVersion}}'
docker run hello-world
docker run --rm ubuntu:24.04 echo "Ubuntu container OK"
docker build -t workstation-web:1.0 .
docker run -d --name workstation-web-8080 -p 8080:80 workstation-web:1.0
docker run -d --name workstation-web-8081 -p 8081:80 workstation-web:1.0
docker ps
docker images
docker logs workstation-web-8080
docker stats --no-stream workstation-web-8080
curl.exe http://localhost:8081
\`\`\`

브라우저에서는 http://localhost:8080 또는 http://localhost:8081 에 접속합니다. 같은 이름의 컨테이너가 이미 존재하면 새 이름을 쓰거나 기존 컨테이너를 별도로 정리해야 합니다. 평가용 브라우저 캡처는 **주소창과 응답 화면**이 함께 나타나야 합니다.

### 학습 목표: 6개 개념 설명

1. **절대 경로 vs 상대 경로**: \`C:\test\workstation-recheck\site\index.html\`은 시작 위치부터 지정하는 절대 경로. 프로젝트 루트의 \`.\site\index.html\`은 현재 작업 폴더 기준의 상대 경로. 고정 위치 지정에는 절대 경로, 프로젝트 내부 재사용에는 상대 경로가 유용.
2. **r/w/x와 755·644**: r=4(읽기), w=2(쓰기), x=1(실행·디렉터리 탐색). 세 자리는 소유자/그룹/기타. 755=\`rwxr-xr-x\`, 644=\`rw-r--r--\`. Ubuntu에서 파일과 디렉터리 권한 변경을 실제 검증함.
3. **커스텀 이미지와 컨테이너**: \`nginx:alpine\` 베이스에 \`site/index.html\`을 복사하는 Dockerfile을 작성하고 \`docker build -t workstation-web:1.0 .\` 실행. 이미지는 실행 템플릿, 컨테이너는 그 이미지의 실행 인스턴스. 동일 이미지로 8080·8081 두 인스턴스를 실행함.
4. **네트워크/포트 매핑**: 컨테이너는 자체 네트워크 네임스페이스에서 실행됨. \`-p 8080:80\`은 호스트 8080 연결을 컨테이너 80으로 전달. \`EXPOSE 80\`만으로 호스트 포트가 열리지 않으며 \`-p\`를 지정해야 함.
5. **Docker 볼륨/영속성**: 바인드 마운트는 지정한 호스트 경로를, named volume은 Docker 관리 저장공간을 연결. 컨테이너가 제거되어도 별도의 호스트 데이터/볼륨은 남는다. 바인드 마운트는 기존 출석 CSV로 검증했으나 Docker named volume은 아래 별도 검증 필요. 익명 볼륨도 있으나 재사용 시 named volume이 편리함.
6. **Git vs GitHub**: Git은 로컬 코드 변경 이력 기록(\`git add/commit\`), GitHub는 온라인 협업/원격 저장소(\`git push/pull\`)를 제공. 기존 출석부를 여러 컴퓨터에서 공유하는 데 사용함.

### 포트 충돌 실습 기록 보완용

사용자는 포트 충돌 실험을 이미 마쳤다고 알림. 출력 로그가 전달되지 않아 아래 명령은 **재현 예시**임.

\`\`\`powershell
docker ps
Get-NetTCPConnection -LocalPort 8080 -State Listen | Select-Object LocalAddress,LocalPort,OwningProcess
docker run -d --name workstation-port-conflict -p 8080:80 workstation-web:1.0
docker rm -f workstation-port-conflict
docker run -d --name workstation-web-8082 -p 8082:80 workstation-web:1.0
curl.exe http://localhost:8082
\`\`\`

포트 충돌은 다른 포트를 쓰거나 해당 포트를 점유한 **내가 관리하는** 컨테이너를 중지하여 해결할 수 있다. 운영체제/Docker 시스템 프로세스의 무분별한 강제 종료는 피한다.

### Docker named volume 검증 예시 (실제 출력 확인 필요)

\`\`\`powershell
docker volume create workstation-data
docker run --rm -v workstation-data:/data ubuntu:24.04 sh -c "echo hello > /data/test.txt"
docker run --rm -v workstation-data:/data ubuntu:24.04 cat /data/test.txt
docker volume inspect workstation-data
\`\`\`

새 컨테이너에서도 \`hello\`가 출력되어야 컨테이너 삭제 후 데이터 유지가 확인된 것이다. 이 명령은 사용자가 실행했다고 확인된 로그가 아니므로 현재 제출 증거로 간주하지 않는다.

### 오류·가설·확인·조치

- **문제**: \`docker build\`가 \`open Dockerfile: no such file or directory\` 오류.
- **가설**: 작업 경로에 Dockerfile이 없음.
- **확인**: \`Get-Content .\Dockerfile\`에서 경로 없음 오류.
- **조치**: \`Dockerfile\` 직접 생성 후 동일 명령을 재실행해 \`workstation-web:1.0\` 빌드 성공.
- 실제 출력은 [증거 파일](evidence/2026-11-09-workstation-logs.md)에 기록. 기존 Git 병합 충돌 및 해결 과정은 README 9~10절 참고.

### 추가 확인 명령

\`\`\`powershell
git --version
git config --list
git remote -v
\`\`\`

출력에는 개인 이메일·토큰·인증정보가 있는지 확인하고 필요한 부분을 가린 뒤 보존해야 합니다. Git 설정을 출력했다는 사실을 보여줄 경우 개인정보는 마스킹하여 제출합니다.


### #17 실제 Docker 볼륨 검증 로그 생성하기 (2026-11-09 추가)

[볼륨 검증 스크립트](scripts/verify-volume.ps1)를 저장소에 추가했습니다. 실제 성공 여부는 **사용자 컴퓨터에서 실행 후 저장된 결과**로만 판정합니다. 아직 실제 출력 로그가 제출된 것은 아닙니다.

PowerShell에서 저장소를 복제한 폴더(예: \`C:\test\집\`)로 이동한 뒤 실행:

\`\`\`powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify-volume.ps1
Get-Content .\evidence\volume-verification-actual.txt
\`\`\`

스크립트는 Docker named volume을 생성하여 첫 컨테이너에 proof.txt를 쓰고, **첫 컨테이너 삭제 후** 새 컨테이너가 파일을 읽는지 확인합니다. 실제 실행할 때 명령과 출력, PASS/FAIL 결과를 \`evidence/volume-verification-actual.txt\`로 저장합니다. 기존 볼륨을 자동 삭제하지 않습니다.

로그가 생성된 경우 내용을 검토해 비밀·개인정보가 없는지 확인하고 해당 파일을 GitHub에 추가해야 평가 증거가 완성됩니다. \`RESULT: PASS\`가 기록되지 않았다면 완료로 표시하지 않습니다.
