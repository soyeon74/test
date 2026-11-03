# 코디세이 스터디 출석부

## 1. 프로젝트 소개
이 프로젝트는 코디세이 올인원 온보딩 실습을 위한 Python 출석부 프로그램입니다.

교육장과 집이라는 두 개의 개발환경을 가정하여 GitHub로 파일을 공유하고 Docker로 프로그램을 실행하는 것을 목표로 합니다.

## 2. 주요 기능
- 출석자 이름 입력
- 오늘 날짜 자동 기록
- 출석 목록 조회
- CSV 파일에 출석 기록 저장

## 3. 개발환경
- 운영체제: Windows
- Python: 3.15
- Git: 2.56.0.windows.4
- 개발 도구: Visual Studio Code

## 4. 교육장 실행 방법

교육장 폴더에서 다음 명령을 실행합니다.

`py -3.15 attend.py`

프로그램 실행 후 1번을 선택하면 출석 등록, 2번은 목록 조회, 3번은 종료입니다.

## 5. 집 실행 방법

집 환경의 Docker 실습 완료 후 작성할 예정입니다.

## 6. GitHub 협업 실습

교육장에서 출석부 프로그램을 작성한 후 Git을 사용하여 GitHub test 저장소에 업로드했습니다.

- git add: 변경사항 기록 준비
- git commit: 로컬 Git에 기록
- git push: GitHub에 업로드
- git pull: GitHub에서 변경사항 받아오기

## 7. 실행 검증 결과

- Python 프로그램 실행: 성공
- 출석자 등록: 성공
- 날짜 자동 기록: 성공
- 출석 목록 조회: 성공
- 프로그램 종료: 성공
- GitHub push: 성공
- Docker 실행: 미실시

## 8. 트러블슈팅

### 사례 1. Python 명령 인식 오류
문제: `python --version` 실행 시 Python을 찾지 못함

확인: Python 3.15 설치 경로를 확인함

대안: `py -3.15` 명령을 사용하여 출석부 프로그램 실행에 성공함

### 사례 2. GitHub 저장소 복제 실패
문제: `Repository not found` 오류 발생

원인: test 저장소가 생성되지 않은 상태였음

해결: GitHub에 test 저장소를 생성한 뒤 clone 성공

## 9. 향후 실습
- Docker 컨테이너에서 출석부 실행
- 교육장과 집의 변경사항 통합
- 출석률 계산 기능 추가
- 브랜치 및 병합 연습

## Git 브랜치 및 병합 실습

### 1. 브랜치 생성
기존 main 브랜치에서 새로운 기능을 개발하기 위해 `feature-attendance-rate` 브랜치를 생성하였다.

`git switch -c feature-attendance-rate`

### 2. 기능 개발
기존 출석부에 이름별 출석 횟수 확인 기능을 추가하였다.

- 기존 메뉴: 출석 등록, 출석 목록, 종료
- 변경 메뉴: 출석 등록, 출석 목록, 출석 횟수 확인, 종료
- 실행 결과: 홍길동 1회 출석 확인

### 3. 변경사항 기록
`git add attend.py`

`git commit -m "출석 횟수 확인 기능 추가"`

### 4. main 브랜치 병합
`git switch main`

`git merge feature-attendance-rate`

병합 결과: Fast-forward 방식으로 정상 반영됨.

### 5. GitHub 업로드
`git push`

GitHub main 브랜치에 변경사항이 반영되었음을 확인하였다.

### 6. 추가 확인사항
병합 후 프로그램의 최종 정상 종료 검증은 별도로 확인할 예정이다.
