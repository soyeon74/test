# 2026-11-09 워크스테이션 실습 증거 (실제 출력 발췌)

> 본 문서는 PowerShell 및 Ubuntu Docker 컨테이너에서 사용자 본인이 실행하여 제공한 로그를 기반으로 작성함. 전체 명령을 재실행한 출력이 아닌 일부 발췌이며, 포트 충돌 실험 및 Docker managed volume 출력은 현재 제공된 로그에 없음.

## CLI 생성·복사·변경·삭제
```powershell
PS C:\test> New-Item -ItemType Directory -Path "workstation-recheck" -Force
# Directory: C:\test / workstation-recheck 생성 확인
PS C:\test\workstation-recheck> Get-Location
Path
----
C:\test\workstation-recheck
PS C:\test\workstation-recheck> "Docker CLI 실습" | Set-Content test.txt
PS C:\test\workstation-recheck> Get-Content test.txt
Docker CLI 실습
PS C:\test\workstation-recheck> Copy-Item test.txt copy.txt
PS C:\test\workstation-recheck> Rename-Item copy.txt renamed.txt
PS C:\test\workstation-recheck> Get-ChildItem -Force
# renamed.txt, test.txt 표시
PS C:\test\workstation-recheck> Remove-Item renamed.txt
PS C:\test\workstation-recheck> Get-ChildItem -Force
# test.txt만 표시
```

## Docker 엔진 / hello-world / Ubuntu
```text
PS> docker --version
Docker version 29.9.2, build a82e528
PS> docker info --format '{{.ServerVersion}}'
29.9.2
PS> docker run hello-world
Hello from Docker!
This message shows that your installation appears to be working correctly.
PS> docker run --rm ubuntu:24.04 echo "Ubuntu container OK"
Ubuntu container OK
PS> docker images
IMAGE                 ID             DISK USAGE
hello-world:latest    c567b231f656       25.9kB
python:3.12-slim      b18b261e1b49        179MB
ubuntu:24.04          fe81560990fa        119MB
PS> docker ps -a
CONTAINER ID   IMAGE         COMMAND    STATUS
e6dd27fd0c6d   hello-world   "/hello"   Exited (0)
e948347f1776   hello-world   "/hello"   Exited (0)
```

## Linux 파일·디렉터리 권한 변경
```bash
$ docker run -it --name permission-practice ubuntu:24.04 bash
root@0a2dd793e607:/# mkdir /practice
root@0a2dd793e607:/# cd /practice
root@0a2dd793e607:/practice# touch sample.txt
root@0a2dd793e607:/practice# mkdir sample_dir
root@0a2dd793e607:/practice# ls -l sample.txt
-rw-r--r-- 1 root root 0 Nov  9 10:13 sample.txt
root@0a2dd793e607:/practice# ls -ld sample_dir
drwxr-xr-x 2 root root 4096 Nov  9 10:13 sample_dir
root@0a2dd793e607:/practice# chmod 600 sample.txt
root@0a2dd793e607:/practice# chmod 700 sample_dir
root@0a2dd793e607:/practice# ls -l sample.txt
-rw------- 1 root root 0 Nov  9 10:13 sample.txt
root@0a2dd793e607:/practice# ls -ld sample_dir
drwx------ 2 root root 4096 Nov  9 10:13 sample_dir
root@0a2dd793e607:/practice# chmod 644 sample.txt
root@0a2dd793e607:/practice# chmod 755 sample_dir
root@0a2dd793e607:/practice# ls -l sample.txt
-rw-r--r-- 1 root root 0 Nov  9 10:13 sample.txt
root@0a2dd793e607:/practice# ls -ld sample_dir
drwxr-xr-x 2 root root 4096 Nov  9 10:13 sample_dir
```

## Dockerfile 오류 → 조치 → 이미지 빌드
```text
PS> docker build -t workstation-web:1.0 .
ERROR: failed to build: failed to solve: failed to read dockerfile: open Dockerfile: no such file or directory
PS> Get-Content .\Dockerfile
Get-Content : Cannot find path 'C:\test\workstation-recheck\Dockerfile' because it does not exist.
PS> @'
FROM nginx:alpine
LABEL org.opencontainers.image.title="workstation-web"
COPY site/ /usr/share/nginx/html/
EXPOSE 80
'@ | Set-Content -Path .\Dockerfile -Encoding ascii
PS> docker build -t workstation-web:1.0 .
[+] Building 11.3s (8/8) FINISHED docker:desktop-linux
=> [1/2] FROM docker.io/library/nginx:alpine
=> [2/2] COPY site/ /usr/share/nginx/html/
=> exporting to image
PS> docker images
IMAGE                 ID             DISK USAGE
workstation-web:1.0   00dd3ed72a90       93.7MB
```

## 포트 매핑, 로그, 리소스, HTTP 응답
```text
PS> docker run -d --name workstation-web-8080 -p 8080:80 workstation-web:1.0
62537c4ede8db30d9deec7112bd368356bd86de0533e64c77754f1786cb40286
PS> docker ps
CONTAINER ID   IMAGE                 STATUS         PORTS                                     NAMES
62537c4ede8d   workstation-web:1.0   Up 4 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   workstation-web-8080
PS> docker logs workstation-web-8080
/docker-entrypoint.sh: Configuration complete; ready for start up
2026/11/09 10:19:43 [notice] 1#1: nginx/1.31.8
PS> docker stats --no-stream workstation-web-8080
CONTAINER ID   NAME                   CPU %     MEM USAGE / LIMIT     MEM %     NET I/O         BLOCK I/O     PIDS
62537c4ede8d   workstation-web-8080   0.00%     3.375MiB / 3.826GiB   0.09%     1.17kB / 126B   0B / 8.19kB   3
PS> docker run -d --name workstation-web-8081 -p 8081:80 workstation-web:1.0
d15e3034236460ee85fe3e05a608dcc84d75a1c352cd9d552a126f877c46d7fc
PS> curl.exe http://localhost:8081
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>Docker 실습</title>
</head>
<body>
  <h1>Docker Web Server Success!</h1>
  <p>Development Workstation Mission</p>
  <p>Custom NGINX Docker Image</p>
</body>
</html>
PS> docker ps
CONTAINER ID   IMAGE                 STATUS          PORTS                                     NAMES
d15e30342364   workstation-web:1.0   Up 8 seconds    0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   workstation-web-8081
62537c4ede8d   workstation-web:1.0   Up 47 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   workstation-web-8080
```

## 기록 미확보
- 8080 포트 충돌 실험: 사용자 완료 진술은 있으나 원시 터미널 로그 미수신
- Docker **관리형(named) 볼륨** 생성→컨테이너 삭제→재생성 후 파일 유지 증거 미수신
- Git 설정 및 원격 출력: 기존 README의 실습 설명 존재, 현재 명령 출력은 미수신
- 브라우저 주소창이 포함된 스크린샷: 미수신

위 항목을 실제로 확인한 후 이 파일에 증거를 추가해야 함.
