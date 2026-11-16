# 재평가 추가 증거 — 실제 실행과 캡처 안내

> 이 문서는 **증거 수집 절차**입니다. 실행 결과나 스크린샷이 없는 항목을 성공으로 표시하지 않습니다. 기존 검증 로그: [워크스테이션 실습](2026-11-09-workstation-logs.md), [볼륨 영속성](volume-verification-actual.txt).

## 1. 포트 접속 브라우저 캡처 (#7)

이미 2026-11-09 실습에서 Docker의 `workstation-web:1.0` 이미지로 8080·8081 포트를 연결하고 `curl.exe http://localhost:8081`에서 HTML이 출력된 기록이 있습니다. [실제 HTTP 및 컨테이너 운영 로그](2026-11-09-workstation-logs.md)를 확인하세요.

브라우저 캡처는 아직 첨부되지 않았습니다.

1. Docker Desktop 엔진을 실행하고 `docker ps`로 웹 컨테이너가 실행 중인지 확인합니다.
2. 주소창에 `http://localhost:8080` 또는 `http://localhost:8081`을 입력합니다.
3. **주소창의 포트 번호와 'Docker Web Server Success!'라는 본문이 함께 보이도록** Windows 캡처 도구(Win+Shift+S)로 화면을 저장합니다.
4. 개인정보 및 다른 탭·프로필 아이콘이 노출되면 캡처 범위를 조정하거나 마스킹합니다.
5. 파일을 `evidence/browser-port-8080.png` (또는 `browser-port-8081.png`)로 GitHub에 올리고 README에서 링크합니다.

## 2. Git 설정·VS Code 연동 증거 (#9)

Git과 GitHub는 구분됩니다. Git은 로컬 커밋 이력을 관리하고, GitHub는 원격 저장소를 보관하고 협업을 지원합니다. **Git 명령 성공만으로 VS Code에 GitHub 로그인이 완료되었다고 판단하지 않습니다.**

저장소를 복제한 PowerShell에서 실행:

```powershell
git --version
git config --get init.defaultBranch
git config --get user.name
git config --get user.email
git remote -v
git status -sb
```

- `git config --list`도 평가 요구에 있으므로 실행하되 공개 전에 사용자 이메일·인증 관련 값을 마스킹하세요.
- `git remote -v`의 주소가 `https://github.com/soyeon74/test.git`인지 확인합니다.
- VS Code로 복제 폴더를 연 다음, 좌측 **소스 제어(Source Control)** 및 **계정(Accounts)**에서 GitHub 로그인 상태를 확인합니다.
- VS Code에서 저장소 폴더·브랜치·소스 제어 화면이 보이는 캡처와 (필요하다면 별도로) GitHub 로그인 계정 상태가 보이는 캡처를 저장합니다. 토큰이나 이메일 등은 마스킹합니다.
- 권장 파일명: `evidence/git-remote-redacted.txt`, `evidence/vscode-github-linked.png`.

명령 실행과 VS Code 화면 사진은 아직 업로드되지 않았으므로 **증거 확인 필요** 상태입니다.

## 3. 바인드 마운트 변경 전·후 비교 (#8)

기존 README는 `attendance.csv`가 컨테이너 종료 후에도 유지됐다고 기록합니다. 재평가에서는 아래 별도 실험으로 **호스트 변경 전/후 및 컨테이너 재생성 후** 결과를 같은 로그에 남기면 명확합니다.

프로젝트 작업 폴더에서 실행(실제 파일을 덮어쓰지 않도록 전용 `bind-demo` 폴더 사용):

```powershell
New-Item -ItemType Directory -Force .\bind-demo
"before-bind" | Set-Content .\bind-demo\proof.txt
Get-Content .\bind-demo\proof.txt
docker run --rm --mount "type=bind,source=$((Resolve-Path .\bind-demo).Path),target=/data" ubuntu:24.04 cat /data/proof.txt
"after-host-change" | Set-Content .\bind-demo\proof.txt
Get-Content .\bind-demo\proof.txt
docker run --rm --mount "type=bind,source=$((Resolve-Path .\bind-demo).Path),target=/data" ubuntu:24.04 cat /data/proof.txt
```

예상 결과: 처음에는 `before-bind`, 호스트 수정 후 새 컨테이너에는 `after-host-change`가 표시됩니다. **이는 예상 출력이며 실습 결과가 아닙니다.** Docker Desktop에서 Windows 경로 공유가 허용된 경우 실행됩니다.

PowerShell의 실행 입력과 출력이 함께 표시되는 화면을 저장하거나, 실제 결과를 `evidence/bind-mount-before-after-actual.txt`에 정리해 제출합니다. 실패한 경우 오류 원문을 남겨 트러블슈팅으로 기록합니다.

## 확인 현황

| 항목 | 현재 증거 | 보완 필요 |
|---|---|---|
| 포트 HTTP 접속 | 8080·8081 매핑 + 8081 curl 실제 성공 로그 | 주소창 포함 브라우저 이미지 |
| Git 원격 연동 | 기존 README의 clone/push/pull 및 실제 GitHub 저장소 존재 | config/remote 실행 출력, VS Code 로그인 화면 |
| 바인드 마운트 | 기존 README의 CSV 데이터 유지 | 호스트 변경 전후 원본 출력 |
