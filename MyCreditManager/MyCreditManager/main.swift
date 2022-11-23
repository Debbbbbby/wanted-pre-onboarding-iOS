//
//  main.swift
//  MyCreditManager
//
//  Created by Doyeon on 2022/11/22.
//

import Foundation

var isRun:Bool = true // 프로그램 실행 상태
var studentInfo: [Student] = [] // [MyCreditManager.Student(name: "학생이름", subject: [])]

struct Student {
    let name: String
    var subject: [Subject]
}

struct Subject {
    let title: String
    let grade: String
}

// MARK: 전체 메뉴
while isRun {
    
    print(">> 현재 studentInfo \(studentInfo) \n")
    print("""
          원하는 기능을 입력해주세요
          1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료
          """)
    
    let input = readLine() ?? ""
    
    switch input {
    case "1":
        print("추가할 할생의 이름을 입력해주세요.")
        let name = readLine() ?? ""
        if (name.range(of: #"^(?:[A-Z][a-z]{1,20}){1}$"#, options: .regularExpression) != nil) {
            insertStudent(name)
        } else {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
        }
        
    case "2":
        print("삭제할 할생의 이름을 입력해주세요.")
        let name = readLine() ?? ""
        if (name.range(of: #"^(?:[A-Z][a-z]{1,20}){1}$"#, options: .regularExpression) != nil) {
            deleteStudent(name)
        } else {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
        }
    case "3":
        print("""
              성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.
              입력예) Mickey Swift A+
              만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.
              """)
        
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

// MARK: 1. 학생추가
func insertStudent(_ name: String) {
    if studentInfo.filter({$0.name == name}).count != 0 {
        print("\(name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
    } else {
        let new = Student(name: name, subject: [])
        studentInfo.append(new)
        print("\(name) 학생을 추가했습니다.")
    }
}

// MARK: 2. 학생삭제
func deleteStudent(_ name: String) {
    if let index = studentInfo.firstIndex(where: {$0.name == name}) {
        studentInfo.remove(at: index)
        print("\(name) 학생을 삭제하였습니다.")
    } else{
        print("\(name) 학생을 찾지 못했습니다.")
    }
}

