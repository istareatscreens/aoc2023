import Foundation

var engineSchematic: [[Character]] = []
var numberMap: [
    Int: [
        [String: Int]
    ]
] = [:]
var indexMap: [
    String: Int
] = [:]
let processLines: (Int, String) -> Void = { lineNumber, line in
    // create engineSchematic map
    if line.isEmpty {
        return
    }

    var engineSchematicRow: [Character] = []
    for char in line {
        engineSchematicRow.append(char)
    }
    engineSchematic.append(engineSchematicRow)

    // create number map and indexMap
    var number = ""
    var indeces: [(Int, Int)] = []
    for (index, char) in line.enumerated() {
        if char.isNumber {
            number += String(char)
            indeces.append((lineNumber, index))
            continue
        }

        // no number to process
        if number.isEmpty {
            continue
        }

        guard var result = numberMap[Int(number)!] else {
            var specificNumberMap: [String: Int] = [:]
            var specificNumberMapArray: [[String: Int]] = []
            for index in indeces {
                let indexKey = "\(index.0),\(index.1)"
                specificNumberMap[indexKey] = 1
                indexMap[indexKey] = Int(number)!
            }
            specificNumberMapArray.append(specificNumberMap)
            numberMap[Int(number)!] = specificNumberMapArray
            indeces = []
            number = ""
            continue
        }

        var specificNumberMap: [String: Int] = [:]
        for index in indeces {
            let indexKey = "\(index.0),\(index.1)"
            specificNumberMap[indexKey] = 1
            indexMap[indexKey] = Int(number)!
        }
        result.append(specificNumberMap)
        numberMap[Int(number)!] = result
        indeces = []
        number = ""
    }

    if number.isEmpty {
        return
    }

    guard var result = numberMap[Int(number)!] else {
        var specificNumberMap: [String: Int] = [:]
        var specificNumberMapArray: [[String: Int]] = []
        for index in indeces {
            let indexKey = "\(index.0),\(index.1)"
            specificNumberMap[indexKey] = 1
            indexMap[indexKey] = Int(number)!
        }
        specificNumberMapArray.append(specificNumberMap)
        numberMap[Int(number)!] = specificNumberMapArray
        return
    }

    var specificNumberMap: [String: Int] = [:]
    for index in indeces {
        let indexKey = "\(index.0),\(index.1)"
        specificNumberMap[indexKey] = 1
        indexMap[indexKey] = Int(number)!
    }
    result.append(specificNumberMap)
    numberMap[Int(number)!] = result
}

let inputPath = getPath("day3/input.txt")
readFile(inputPath, callback: processLines)

// part 1
func getSolutionOne(
    _ engineSchematic: [[Character]],
    _ numberMap: [Int: [[String: Int]]],
    _ indexMap: [String: Int]
) {
    var partsAdjacentToSymbol: [Int] = []
    var modifiedNumberMap = numberMap

    for (rowIndex, engineSchematicRow) in engineSchematic.enumerated() {
        for (columnIndex, char) in engineSchematicRow.enumerated() {
            // if not a symbol skip
            if Character(".") == char || char.isNumber {
                continue
            }

            for coordinate in [
                (rowIndex - 1, columnIndex - 1), (rowIndex - 1, columnIndex), (rowIndex - 1, columnIndex + 1),
                (rowIndex, columnIndex - 1), (rowIndex, columnIndex + 1),
                (rowIndex + 1, columnIndex - 1), (rowIndex + 1, columnIndex), (rowIndex + 1, columnIndex + 1),
            ] {
                let indexKey = "\(coordinate.0),\(coordinate.1)"
                guard let number = indexMap[indexKey] else {
                    continue
                }

                for (key, numberCoordianteMap) in modifiedNumberMap[number]!.enumerated() {
                    guard let value = numberCoordianteMap[indexKey] else {
                        continue
                    }

                    guard value > 0 else {
                        continue
                    }

                    partsAdjacentToSymbol.append(number)

                    var updatedCoordinateCountMap: [String: Int] = [:]
                    for (coordinateKey, _) in numberCoordianteMap {
                        updatedCoordinateCountMap[coordinateKey] = 0
                    }
                    modifiedNumberMap[number]![key] = updatedCoordinateCountMap
                }
            }
        }
    }
    printSolutionOne(
        partsAdjacentToSymbol.reduce(0, +)
    )
}

getSolutionOne(
    engineSchematic,
    numberMap,
    indexMap
)

// part 2
func getSolutionTwo(
    _ engineSchematic: [[Character]],
    _ numberMap: [Int: [[String: Int]]],
    _ indexMap: [String: Int]
) {
    var gearRatios: [Int] = []

    for (rowIndex, engineSchematicRow) in engineSchematic.enumerated() {
        for (columnIndex, char) in engineSchematicRow.enumerated() {
            // if not a symbol skip
            if Character("*") != char {
                continue
            }

            var modifiedNumberMap = numberMap
            var parts: [Int] = []
            Scan: for coordinate in [
                (rowIndex - 1, columnIndex - 1), (rowIndex - 1, columnIndex), (rowIndex - 1, columnIndex + 1),
                (rowIndex, columnIndex - 1), (rowIndex, columnIndex + 1),
                (rowIndex + 1, columnIndex - 1), (rowIndex + 1, columnIndex), (rowIndex + 1, columnIndex + 1),
            ] {
                let indexKey = "\(coordinate.0),\(coordinate.1)"
                guard let number = indexMap[indexKey] else {
                    continue
                }

                for (key, numberCoordianteMap) in modifiedNumberMap[number]!.enumerated() {
                    guard let value = numberCoordianteMap[indexKey] else {
                        continue
                    }

                    guard value > 0 else {
                        continue
                    }

                    guard parts.count < 3 else {
                        break Scan
                    }

                    parts.append(number)

                    var updatedCoordinateCountMap: [String: Int] = [:]
                    for (coordinateKey, _) in numberCoordianteMap {
                        updatedCoordinateCountMap[coordinateKey] = 0
                    }
                    modifiedNumberMap[number]![key] = updatedCoordinateCountMap
                }
            }
            if parts.count == 2 {
                gearRatios.append(parts[0] * parts[1])
            }
        }
    }
    printSolutionTwo(
        gearRatios.reduce(0, +)
    )
}

getSolutionTwo(
    engineSchematic,
    numberMap,
    indexMap
)
