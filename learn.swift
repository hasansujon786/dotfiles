import Foundation

// ============================================================
// MARK: - Learning Swift Syntax
// A feature-by-feature playground for Swift basics.
// ============================================================

// ============================================================
// MARK: - 1. Optionals & Optional Binding
// `String?` means the value can be a String or nil.
// `if let` safely unwraps an optional.
// ============================================================

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

// ============================================================
// MARK: - 2. Functions - Basics
// `_ value` hides the external parameter label at call site.
// ============================================================

func plusTwo(_ value: Int) -> Int {
    print("plusTwo")

    return value + 2
}

var _ = plusTwo(23232)
var _ = plusTwo(23232)

// ============================================================
// MARK: - 3. Functions - @discardableResult
// Suppresses "result unused" warning when caller ignores return.
// ============================================================

@discardableResult
func doCalculation(_ lhs: Int, _ rhs: Int, using: (Int, Int) -> Int) -> Int {
    return using(lhs, rhs)
}

func addition(n1: Int, n2: Int) -> Int {
    return n1 + n2
}

// ============================================================
// MARK: - 4. Strings & Characters
// Strings are collections of Character. Unicode-safe by default.
// ============================================================

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

// ============================================================
// MARK: - 5. Arrays & Loops
// `for-in` iterates over collections.
// ============================================================

let arr = ["apple", "mango"]

for item in arr {
    print(item)
}

let numbers = [1, 2, 3, 4]
print(numbers)

// ============================================================
// MARK: - 6. Higher-Order Functions - map
// `map` transforms each element and returns a new array.
// `$0` is shorthand for the first closure argument.
// ============================================================

var squareNumbers = numbers.map { $0 * $0 }
squareNumbers = numbers.map({ num in
    return num * num
})

// ============================================================
// MARK: - 7. Closures & Trailing Closure Syntax
// A closure can be passed as a function, inline, or trailing.
// ============================================================

// 1. Passing a named function reference
doCalculation(
    20, 10,
    using: addition(n1:n2:)
)

// 2. Passing a full inline closure
doCalculation(
    20, 10,
    using: { n1, n2 in
        return n1 + n2
    }
)

// 3. Trailing closure (closure is last arg, moved outside parens)
doCalculation(20, 10) { n1, n2 in
    return n1 + n2
}

// 4. Shorthand argument names ($0, $1) + implicit return
doCalculation(
    20, 10,
) {
    $0 + $1
}

// ============================================================
// MARK: - 8. Structs - Value Types
// `mutating func` is required to modify `var` properties.
// ============================================================

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

// ============================================================
// MARK: - 9. Enums - Basic Cases
// ============================================================

enum Fruits {
    case apple,
        orange,
        jackfruit,
        lichi
}

// ============================================================
// MARK: - 10. Enums - Associated Values
// Each case can carry its own payload of data.
// ============================================================

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

// ============================================================
// MARK: - 11. Pattern Matching with `if case`
// Checks for a single enum case without a full switch.
// ============================================================

if case .failure(let code, let message) = badResponse {
    print("Error \(code): \(message)")
}

// ============================================================
// MARK: - 12. Generics & Standard Library `Result`
// Swift already has `Result<Success, Failure: Error>` built in.
// Renamed here to `MyResult` to avoid redefinition conflict.
// ============================================================

@frozen
public enum MyResult<Success, Failure> where Failure: Error {
    case success(Success)
    case failure(Failure)
}

// ============================================================
// MARK: - 13. Unicode Identifiers
// Swift allows emoji and non-Latin characters as identifiers.
// Useful for learning, avoid in production code.
// ============================================================

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
