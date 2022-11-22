//
//  main.swift
//  MyCreditManager
//
//  Created by Doyeon on 2022/11/22.
//

import Foundation

var isRun:Bool = true // 프로그램 실행 상태

while isRun {
    print("""
          원하는 기능을 입력해주세요
          1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료
          """)
    
    let input = readLine() ?? ""
    
    switch input {
    case "1":
        print("학생추가")
    case "2":
        print("학생삭제")
    case "3":
        print("성적추가(변경)")
    case "4":
        print("성적삭제")
    case "5":
        print("평점보기")
    case "X":
        print("프로그램을 종료합니다...")
        isRun = false; break
    default:
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    }
}
