import Foundation

// part 1
var numbers: [Int] = []
let solutionOne: (String) -> Void = { line in
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
print("solution 1 = " + String(numbers.reduce(0, +)))

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

let solutionTwo: (String) -> Void = { line in
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

func getAllSubstrings(_ str: String) -> [String] {
    var result: [String] = []
    for i in 0 ..< str.count + 1 {
        for j in (i + 1) ..< str.count + 1 {
            result.append(str[i ..< j])
        }
    }
    return result
}

readFile(inputPath, callback: solutionTwo)
print("solution 2 = " + String(numbers.reduce(0, +)))
