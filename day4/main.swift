import BigInt
import Foundation

func power(base: Int, exponent: Int) -> Int {
    var result = 1

    for _ in 0 ..< exponent {
        result = base * result
    }

    return result
}

struct Card {
    var cardNumber: Int
    let winningNumbers: [String]
    let recievedNumbers: [String]
    var matchingNumbers: [String] = []
    var evaluated: Bool = false
}

var winningPoints: Int = 0
var cards: [Card] = []

let processSolutionOne: (Int, String) -> Void = { cardNumber, line in
    // create engineSchematic map
    if line.isEmpty { return }

    let numberEnd = line.firstIndex(of: ":")!

    let winningNumbersAndRecievedNumbers: [String] = (String(line[numberEnd ..< line.endIndex])
        .trimmingCharacters(in: CharacterSet(charactersIn: ":")))
        .components(separatedBy: CharacterSet(charactersIn: "|"))

    let winningNumbers = winningNumbersAndRecievedNumbers[0]
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: CharacterSet(charactersIn: " ")).filter { !$0.isEmpty }
    let recievedNumbers = winningNumbersAndRecievedNumbers[1]
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .components(separatedBy: CharacterSet(charactersIn: " ")).filter { !$0.isEmpty }

    var card = Card(
        cardNumber: cardNumber + 1,
        winningNumbers: winningNumbers,
        recievedNumbers: recievedNumbers
    )

    var exponent = -1
    for winningNumber in card.winningNumbers {
        for recievedNumber in card.recievedNumbers {
            guard winningNumber == recievedNumber else {
                continue
            }
            card.matchingNumbers.append(winningNumber)
            exponent += 1
        }
    }

    cards.append(card)
}

let inputPath = getPath("day4/input.txt")
readFile(inputPath, callback: processSolutionOne)

var winningPointScore = 0
for card in cards {
    if card.matchingNumbers.isEmpty {
        continue
    }
    winningPoints += power(base: 2, exponent: card.matchingNumbers.count - 1)
}

printSolutionOne(winningPoints)

var cardSet: [Int: Card] = [:]
for (key, card) in cards.enumerated() {
    cardSet[key + 1] = card
}

func computeFinalCardAmount(_ cards: [Card]) -> [Card] {
    var newCardSet: [Card] = []
    for card in cards {
        var card = card
        if card.evaluated {
            newCardSet.append(card)
            continue
        }
        card.evaluated = true
        if card.matchingNumbers.isEmpty {
            newCardSet.append(card)
            continue
        }
        newCardSet.append(card)
        for cardNumberSelection in (card.cardNumber + 1) ... (card.cardNumber + card.matchingNumbers.count) {
            guard cardSet[cardNumberSelection] != nil else {
                continue
            }
            var newCard = cardSet[cardNumberSelection]!
            newCard.evaluated = false
            newCardSet.append(newCard)
        }
    }

    if cards.count == newCardSet.count {
        return newCardSet
    }

    return computeFinalCardAmount(newCardSet)
}

printSolutionTwo(computeFinalCardAmount(cards).count)
