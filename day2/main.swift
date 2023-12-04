import Foundation

let inputPath = getPath("day2/input.txt")
var games: [Int: [[String: Int]]] = [:]
let processLines: (Int, String) -> Void = { _, line in
    if line.isEmpty { return }
    let numberEnd = line.firstIndex(of: ":")!
    let numberStart = line.firstIndex(of: " ")!

    let gameNumber = Int(line[numberStart ..< numberEnd].trimmingCharacters(in: .whitespaces))!

    let game = String(line[numberEnd ..< line.endIndex]).trimmingCharacters(in: CharacterSet(charactersIn: ":"))
    let gameRounds = game.components(separatedBy: ";")
    var rounds: [[String: Int]] = []
    for round in gameRounds {
        var roundData: [String: Int] = [:]
        let cubeNumberAndColourData = round.components(separatedBy: ",")
        for cubeNumberAndColour in cubeNumberAndColourData {
            let numberAndColourArray = (cubeNumberAndColour.trimmingCharacters(in: .whitespaces)).components(separatedBy: " ")
            roundData[numberAndColourArray.last!] = Int(numberAndColourArray.first!)!
        }
        rounds.append(roundData)
    }
    games[gameNumber] = rounds
}

readFile(inputPath, callback: processLines)

// part 1
let possibeCubeColourAndMaxNumber: [String: Int] = [
    "red": 12,
    "green": 13,
    "blue": 14,
]
var possibleGames: [Int] = []
for (game, rounds) in games {
    var failed = false
    gameLoop: for round in rounds {
        for (cubeColour, cubeNumber) in round {
            guard let totalNumber = possibeCubeColourAndMaxNumber[cubeColour] else {
                failed = true
                break gameLoop
            }
            guard totalNumber >= cubeNumber else {
                failed = true
                break gameLoop
            }
        }
    }
    if !failed {
        possibleGames.append(game)
    }
}

printSolutionOne(possibleGames.reduce(0, +))

// part 2
var powerSets: [[String: Int]] = []
for (_, rounds) in games {
    var powerSet: [String: Int] = [:]
    for round in rounds {
        for (cubeColour, cubeNumber) in round {
            updateDictionary(
                key: cubeColour,
                value: cubeNumber,
                condition: { currentMax in
                    currentMax < cubeNumber
                },
                dict: &powerSet
            )
        }
    }
    powerSets.append(powerSet)
}

var sumOfPowerSets = 0
for powerSet in powerSets {
    var result = 1
    for (_, number) in powerSet {
        result *= number
    }
    sumOfPowerSets += result
}

printSolutionTwo(sumOfPowerSets)
