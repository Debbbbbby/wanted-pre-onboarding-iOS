# 📘 원티드 프리온보딩 챌린지 iOS과정 사전과제
|**프로젝트명**|MyCreditManager|
|:---:|:---|
|**프로젝트 소개**|성적 관리 프로그램|
|**사용 언어**|Swift|
|**환경**|Xcode 기본 템플릿 중 [ macOS - Command Line Tool ]|
|**작업기간**|22.11.22 ~ 22.11.23|
|**프로그램 메뉴**|- 학생 추가 <br>- 학생 삭제 <br>- 성적 추가(변경) <br>- 성적 삭제 <br>- 평점 보기 <br>- 종료 <br>- 예외처리|
|**프로그램 동작조건**|- 사용자가 종료 메뉴를 선택하기 전까지는 계속해서 사용자의 입력을 받습니다 <br>- 메뉴선택을 포함한 모든 입력은 숫자 또는 영문으로 받습니다|
|**성적별 점수**|- A+ (4.5점) / A (4점) <br>- B+ (3.5점) / B (3점) <br>- C+ (2.5점) / C (2점) <br>- D+ (1.5점) / D (1점) <br>- F (0점)|
|**평점**|- 각 과목의 점수 총 합 / 과목 수 <br>- 최대 소수점 2번째 자리까지 출력 <br> - 예) 3.75 / 4.1 / 2|

---

## 커밋 메세지
|**Gitmoji**|**Description**|
|:---:|:---|
|🎉|**프로젝트 생성**|
|✨|**새로운 기능** 추가|
|🎨|코드의 **형식 / 구조** 개선|
|💡|**새로운 아이디어** 또는 **주석 수정**|
|♻️|코드 **리팩토링**|
|📝|**문서** 추가 또는 수정|

---

## 프로그램 동작 과정
### 정보 구조
```swift
// 학생 정보 Struct
struct Student {
    let name: String
    var subject: [Subject]
}

// 과목 정보 Struct
struct Subject {
    let title: String
    var grade: String
}

// 학생 정보 저장
var studentInfo: [Student] = [] // [MyCreditManager.Student(name: "학생이름", subject: [])]
```

### 학생 추가
<p align="center">
    <img width="100%" alt="학생 추가" src="https://user-images.githubusercontent.com/108422901/203584493-50144859-4120-43bc-b20e-377b179fa43f.png">
</p>

```swift
// 추가할 학생 이름 입력
let name = readLine() ?? ""
if nameCheck(name) { // validation check : 이름 형식에 적합하다면 true
    insertStudent(name)
} else {
    print("입력이 잘못되었습니다. 다시 확인해주세요.")
}

// 정규식 : 영어 대문자로 시작, 2번째 이후 영어 소문자 1~20개, 공백 없이 한 단어
func nameCheck(_ name: String) -> Bool {
    return (name.range(of: #"^(?:[A-Z][a-z]{1,20}){1}$"#, options: .regularExpression) != nil) ? true : false
}

// 학생 정보 등록
func insertStudent(_ name: String) {
    // studentInfo의 모든 정보 중 name이 현재 name과 일치하는 정보가 존재하는 경우
    if studentInfo.filter({$0.name == name}).count != 0 {
        print("\(name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
    } else {
        // 존재하지 않는 경우 Student형 정보를 studentInfo에 추가
        let new = Student(name: name, subject: [])
        studentInfo.append(new)
        print("\(name) 학생을 추가했습니다.")
    }
}
```

### 학생 삭제
<p align="center">
    <img width="100%" alt="학생 삭제" src="https://user-images.githubusercontent.com/108422901/203584621-6ebea281-08dd-40d3-baff-defafde263f5.png">
</p>

```swift
// 삭제할 학생 이름 입력
let name = readLine() ?? ""
if nameCheck(name) {
    deleteStudent(name)
} else {
    print("입력이 잘못되었습니다. 다시 확인해주세요.")
}

// 학생 정보 삭제
func deleteStudent(_ name: String) {
    // studentInfo에 해당 정보가 존재하면 삭제
    if let index = studentInfo.firstIndex(where: {$0.name == name}) {
        studentInfo.remove(at: index)
        print("\(name) 학생을 삭제하였습니다.")
    } else {
        print("\(name) 학생을 찾지 못했습니다.")
    }
}
```

### 성적 추가(변경)
<p align="center">
    <img width="100%" alt="성적 추가(변경)" src="https://user-images.githubusercontent.com/108422901/203584617-bf424f99-63d2-4b21-adf9-6d3ff5898ee3.png">
</p>

```swift
// input: String -> array: [String] -> (name, subject, grade)으로 가공
guard let input = readLine() else { break }
let array = input.split(separator: " ").map{ String($0) }
if array.count == 3 {
    let (name, subject, grade) = (array[0], array[1], array[2])
    if gradeCheck(grade) { // validation check : 성적 형식에 적합하다면 true
        updateGrade(name: name, subject: subject, grade: grade)
    } else {
        print("성적이 양식에 맞게 입력되지 않았습니다. 다시 시도해주세요.")
    }
} else {
    print("입력이 잘못되었습니다. 다시 확인해주세요.")
}

// 정규식 : A(+-),B(+-),C(+-),D(+-),F
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

// 성적 정보 업데이트
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
```

### 성적 삭제
<p align="center">
    <img width="100%" alt="성적 삭제" src="https://user-images.githubusercontent.com/108422901/203584602-416b4dc3-e9e8-4e52-bad0-278b1f7555bd.png">
</p>

```swift
// input: String -> array: [String] -> (name, subject)로 가공
guard let input = readLine() else { break }
let array = input.split(separator: " ").map{ String($0) }
if array.count == 2 {
    let (name, subject) = (array[0], array[1])
    deleteGrade(name: name, subject: subject)
} else {
    print("입력이 잘못되었습니다. 다시 확인해주세요")
}

// 성적 정보 삭제
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
```

### 평점 보기
<p align="center">
    <img width="100%" alt="평점 보기" src="https://user-images.githubusercontent.com/108422901/203584607-c3734a63-0d93-4cc6-86fd-948402839bbc.png">
</p>

```swift
// 평점을 확인할 학생 이름 입력
let name = readLine() ?? ""
if nameCheck(name) { // validation check : 이름 형식에 적합하다면 true
    getAverage(name)
} else {
    print("입력이 잘못되었습니다. 다시 확인해주세요.")
}

// 전체 평균 정보
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

// 성적을 점수로 변환
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
```

### 프로그램 종료
<p align="center">
    <img width="100%" alt="종료" src="https://user-images.githubusercontent.com/108422901/203584612-88460072-2e2d-4b88-a805-3606a505e1d5.png">
</p>

```swift
var isRun:Bool = true // 프로그램 실행 상태

while isRun { // isRun이 true라면 전체 메뉴 실행 상태
    let input = readLine() ?? ""

    switch input {
    ...
    case "X": // input이 X라면
            print("프로그램을 종료합니다...")
            isRun = false; break // isRun을 false로 변경하고 break
}
```

### 예외처리
```swift
// 프로그램 실행 중
while isRun == true {
let input = readLine() ?? ""
    switch input {
        default: // input이 1~5 or X에 해당하지 않으면 예외, 처음으로 돌아감
            print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    }
}
```
