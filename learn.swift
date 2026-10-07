import Foundation

func getUsername() -> String? {
    let lName = "Mahmaud"
    return "Hasan" + lName
    // return nil
}
var username: String? = getUsername()

if let username {
    print(username)
} else {
    print("value is nil")
}

let arr = ["apple", "mango"]

for item in arr {
    print(item)
}

func plusTwo(_ value: Int) -> Int {
    print("plusTwo")

    return value + 2
}

var _ = plusTwo(23232)
var _ = plusTwo(23232)

@discardableResult
func doCalculation(_ lhs: Int, _ rhs: Int, using: (Int, Int) -> Int) -> Int {
    return using(lhs, rhs)
}
func addition(n1: Int, n2: Int) -> Int {
    return n1 + n2
}

doCalculation(
    20, 10,
    using: addition(n1:n2:)
)

doCalculation(20, 10) { n1, n2 in
    return n1 + n2
}

doCalculation(
    20, 10,
) {
    $0 + $1
}

// Struct

struct Person {
    let name: String
    var age: Int? = nil
    // init(name: String, age: Int?) {
    //     self.name = name
    //     self.age = age
    // }

    mutating func changeAge(newAge: Int) {
        age = newAge
    }
}

var kuddus = Person(name: "Kuddus", age: 50)
kuddus.changeAge(newAge: 51)

enum NetworkResult {
    case success(message: String)  // Carries a payload of data
    case failure(code: Int, message: String)  // Carries a status code and an error message
}

func handleResponse(_ result: NetworkResult) {
    switch result {
    case .success(let data):
        print("Received payload: \(data)")

    case .failure(let code, let message):
        print("Error \(code): \(message)")
    }
}

let goodResponse = NetworkResult.success(message: "{\"user\": \"Hasan\"}")
let badResponse = NetworkResult.failure(code: 404, message: "Page Not Found")
handleResponse(goodResponse)  // Output: Received payload: {"user": "Hasan"}
handleResponse(badResponse)  // Output: Error 404: Page Not Found

if case .failure(let code, let message) = badResponse {
    print("Error \(code): \(message)")
}

@frozen
public enum Result<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}

var 🐮 = "ridiculous"
print(🐮)

// Kanji (漢字)
let 名前 = "Hasan"
let 年齢 = 25

// Hiragana (ひらがな)
var ねこ = "Cat"

// Katakana (カタカナ)
let ユーザー = "User"

print("Name: \(名前), Age: \(年齢), Pet: \(ねこ)")

func 名() -> Int {
    return 23
}

enum Fruits {
    case apple,
        orange,
        jackfruit,
        lichi
}

var str = "Hello"
var smile = "😄"
var combined = str + " " + smile

print(combined.uppercased())

for char in combined {
    print(char)
}

combined.forEach { char in
    print(char)
}

combined.forEach { char in
    print(char)
}
