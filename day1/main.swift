import Foundation

// part 1
var numbers: [Int] = []
let solutionOne: (Int, String) -> Void = { _, line in
    var firstNumber = ""
    var lastNumber = ""
    for char in line {
        if !char.isNumber {
            continue
        }
        if firstNumber.isEmpty {
            firstNumber = String(char)
        }
        lastNumber = String(char)
    }
    if firstNumber.isEmpty || lastNumber.isEmpty {
        return
    }
    numbers.append(Int(firstNumber + lastNumber)!)
}

let inputPath = getPath("day1/input.txt")

readFile(inputPath, callback: solutionOne)
printSolutionOne(numbers.reduce(0, +))

// part 2

numbers = []

let numbersDictionary: [String: Int] = [
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
]

let solutionTwo: (Int, String) -> Void = { _, line in
    var parts: [String] = []
    var spelledNumber = ""
    for char in line {
        if !char.isNumber {
            spelledNumber.append(String(char))
            continue
        }
        parts.append(spelledNumber)
        spelledNumber = ""
        parts.append(String(char))
    }
    if !spelledNumber.isEmpty {
        parts.append(spelledNumber)
    }

    var firstNumber = ""
    var lastNumber = ""
    let assignFirstAndLastNumber: (Int) -> Void = { number in
        if firstNumber.isEmpty {
            firstNumber = String(number)
        }
        lastNumber = String(number)
    }

    for part in parts {
        if part.count == 1, Character(part).isNumber {
            assignFirstAndLastNumber(Int(part)!)
            continue
        }
        for number in getAllSubstrings(part) {
            if let integer = numbersDictionary[String(number)] {
                assignFirstAndLastNumber(integer)
            }
        }
    }

    if firstNumber.isEmpty || lastNumber.isEmpty {
        return
    }
    numbers.append(Int(firstNumber + lastNumber)!)
}

readFile(inputPath, callback: solutionTwo)
printSolutionTwo(numbers.reduce(0, +))
