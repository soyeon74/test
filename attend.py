
import csv
from datetime import date
from pathlib import Path

FILE = Path("attendance.csv")

def add_attendance():
    name = input("이름을 입력하세요: ").strip()
    if not name:
        print("이름을 입력해야 합니다.")
        return

    today = date.today().isoformat()
    new_file = not FILE.exists() or FILE.stat().st_size == 0

    with FILE.open("a", newline="", encoding="utf-8-sig") as f:
        writer = csv.writer(f)

        if new_file:
            writer.writerow(["날짜", "이름"])

        writer.writerow([today, name])

    print(f"{name}님 출석 완료!")

def show_attendance():
    if not FILE.exists():
        print("아직 출석 기록이 없습니다.")
        return

    with FILE.open("r", newline="", encoding="utf-8-sig") as f:
        reader = csv.reader(f)
        for row in reader:
            print(" | ".join(row))

while True:
    print("\n=== 스터디 출석부 ===")
    print("1. 출석 등록")
    print("2. 출석 목록 보기")
    print("3. 종료")

    choice = input("번호 선택: ")

    if choice == "1":
        add_attendance()
    elif choice == "2":
        show_attendance()
    elif choice == "3":
        print("프로그램을 종료합니다.")
        break
    else:
        print("1~3 중 선택하세요.")
