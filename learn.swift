import Foundation

func getUsername() -> String? {
    return "hasan"
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
) {
    $0 + $1
}

doCalculation(
    20, 10,
    using: addition(n1:n2:)
)

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
