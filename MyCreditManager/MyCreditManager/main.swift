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
    var grade: String
}

// MARK: 전체 메뉴
while isRun {
    
    print("\n>> 현재 studentInfo")
    for info in studentInfo {
        print("< 학생명 : \(info.name) >")
        for i in 0 ..< info.subject.count {
            print("과목명 : \(info.subject[i].title), 성적 : \(info.subject[i].grade)")
        }
    }
    print()
    
    print("""
          원하는 기능을 입력해주세요
          1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료
          """)
    
    let input = readLine() ?? ""
    
    switch input {
    case "1":
        print("추가할 할생의 이름을 입력해주세요.")
        let name = readLine() ?? ""
        if nameCheck(name) {
            insertStudent(name)
        } else {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
        }
        
    case "2":
        print("삭제할 할생의 이름을 입력해주세요.")
        let name = readLine() ?? ""
        if nameCheck(name) {
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
        
        guard let input = readLine() else { break }
        let array = input.split(separator: " ").map{ String($0) }
        if array.count == 3 {
            let (name, subject, grade) = (array[0], array[1], array[2])
            if gradeCheck(grade) {
                updateGrade(name: name, subject: subject, grade: grade)
            } else {
                print("성적이 양식에 맞게 입력되지 않았습니다. 다시 시도해주세요.")
            }
        } else {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
        }
    case "4":
        print("""
              성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.
              입력예) Mickey Swift
              """)
        guard let input = readLine() else { break }
        if input != "" {
            let array = input.split(separator: " ").map{ String($0) }
            if array.count == 2 {
                let (name, subject) = (array[0], array[1])
                deleteGrade(name: name, subject: subject)
            } else {
                print("입력이 잘못되었습니다. 다시 확인해주세요")
            }
        } else {
            print("입력이 잘못되었습니다. 다시 확인해주세요")
        }
    case "5":
        print("평점을 알고싶은 학생의 이름을 입력해주세요")
        let name = readLine() ?? ""
        if nameCheck(name) {
            getAverage(name)
        } else {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
        }
    case "X":
        print("프로그램을 종료합니다...")
        isRun = false; break
    default:
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    }
}

// MARK: 1. 학생추가

/// 학생 정보를 등록하는 기능
/// - Parameter name: 등록하기 원하는 학생명
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

/// 학생의 정보를 삭제하는 기능
/// - Parameter name: 삭제하기 원하는 학생명
func deleteStudent(_ name: String) {
    if let index = studentInfo.firstIndex(where: {$0.name == name}) {
        studentInfo.remove(at: index)
        print("\(name) 학생을 삭제하였습니다.")
    } else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
}

// MARK: 3. 성적추가(변경)

/// 학생의 과목별 성적이 기존에 존재하지 않으면 추가, 존재하면 변경해주는 기능
/// - Parameters:
///   - name: 성적을 변경하기 원하는 학생명
///   - subject: 과목명
///   - grade: 성적 정보
func updateGrade(name:String, subject: String, grade: String) {
    // 학생 존재 여부 체크
    if let studentIdx = studentInfo.firstIndex(where: { $0.name == name }) {
        // 과목 존재 여부 체크
        if let subjectIdx = studentInfo[studentIdx].subject.firstIndex(where: { $0.title == subject}) {
            // 과목이 존재하는 경우 성적 업데이트
            studentInfo[studentIdx].subject[subjectIdx].grade = grade
        } else {
            // 과목이 존재하지 않을 경우 과목, 성적 정보 추가
            let newSubjectInfo = Subject(title: subject, grade: grade)
            studentInfo[studentIdx].subject.append(newSubjectInfo)
        }
        print("\(name) 학생의 \(subject) 과목이 \(grade)로 추가(변경)되었습니다.")
    } else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
    
}

// MARK: 4. 성적삭제

/// 학생의 특정 성적 정보를 삭제하는 기능
/// - Parameters:
///   - name: 학생명
///   - subject: 과목명
func deleteGrade(name: String, subject: String) {
    // 학생 존재 여부 체크
    if let studentIdx = studentInfo.firstIndex(where: { $0.name == name }) {
        // 과목 존재 여부 체크
        if let subjectIdx = studentInfo[studentIdx].subject.firstIndex(where: { $0.title == subject}) {
            // 과목이 존재하는 경우 삭제
            studentInfo[studentIdx].subject.remove(at: subjectIdx)
            print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
        } else {
            print("\(name) 학생의 \(subject) 과목이 존재하지 않습니다.")
        }
    } else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
}

// MARK: 5. 평점보기

/// 학생의 과목별 성적과 평점 정보를 출력하는 기능
/// - Parameter name: 학생명
func getAverage(_ name: String) {
    // 학생 존재 여부 체크
    if let idx = studentInfo.firstIndex(where: { $0.name == name }) {
        var total: Double = 0.0
        studentInfo[idx].subject.forEach { subjectInfo in
            print("\(subjectInfo.title): \(subjectInfo.grade)")
            total += getScore(subjectInfo.grade)
        }
        let average = String(format: "%.2f", total / Double(studentInfo[idx].subject.count))
        print("평점 : \(average)")
    } else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
}

/// 성적을 점수로 변환하는 기능
/// - Parameter grade: 기존에 저장되어있는 성적 정보 ( 예: A+, C-, F 등 )
/// - Returns: 0.0 ~ 4.5 사이의 점수
func getScore(_ grade: String) -> Double {
    switch grade {
    case "A+":
        return 4.5
    case "A":
        return 4.0
    case "B+":
        return 3.5
    case "B":
        return 3.0
    case "C+":
        return 2.5
    case "C":
        return 2.0
    case "D+":
        return 1.5
    case "D":
        return 1.0
    default:
        return 0.0
    }
}

// MARK: 입력 체크

/// 이름이 형식에 맞는지 체크
/// - Parameter name: 확인하기 원하는 이름
/// - Returns: 정규식과 일치하면 true, 일치하지 않으면 false
func nameCheck(_ name: String) -> Bool {
    return (name.range(of: #"^(?:[A-Z][a-z]{1,20}){1}$"#, options: .regularExpression) != nil) ? true : false
}

/// 성적이 형식에 맞는지 체크
/// - Parameter grade: 확인하기 원하는 성적
/// - Returns: 정규식과 일치하면 true, 일치하지 않으면 false
func gradeCheck(_ grade: String) -> Bool {
    var result = false
    if (grade.range(of: #"^[A-DF][+-]?$"#, options: .regularExpression) != nil) {
        if (grade.contains("F")) && (grade.count > 1) {
            return false // 성적이 F-, F+ 이라면 false
        }
        result = true
    }
    return result
}
