import Foundation

var myName = "Hasan"
var yourName = "Kuddus Khan"

myName = "kuddus khan"

print("Hello, \(myName)!")

var names = [
    myName,
    yourName,
]

names.append("another name")
print(names)

let array = NSMutableArray(array: ["Mango"])

array.add("Apple")
array.add("Banana")

print(array)

// array.append("Apple")
// array.append("Banana")
