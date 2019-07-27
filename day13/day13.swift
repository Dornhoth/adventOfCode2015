//
//  day13.swift
//  
//
//  Created by Dornhoth on 27.07.19.
//

import Foundation

struct ChangeInHappiness {
    var of: String
    var nextTo: String
    var happiness: Int
}

func absValueOfHappinessInString(str: String) -> Int {
    let regex = try! NSRegularExpression(pattern: #"([1-9][0-9]*)"#, options: NSRegularExpression.Options.caseInsensitive)
    let results = regex.matches(in: str,
                                    range: NSMakeRange(0, str.count))
    return Int(String(str[Range(results[0].range, in: str)!]))!
}

func treatLine(line: String) -> ChangeInHappiness {
    let gains = line.contains("gain")
    let lineSplit = line.components(separatedBy: " ")
    let of = String(lineSplit[0])
    let nextTo = String(String(lineSplit[lineSplit.count - 1]).dropLast())
    let valueOfHappiness = absValueOfHappinessInString(str: line)
    return ChangeInHappiness(of: of, nextTo: nextTo, happiness: gains ? valueOfHappiness : -1 * valueOfHappiness )
}

func createChangesOfHappiness(contents: String) -> [ChangeInHappiness] {
    var changesInHappiness = [ChangeInHappiness]()
    let lines = contents.components(separatedBy: "\n")
    for line in lines {
        changesInHappiness.append(treatLine(line: line))
    }
    return changesInHappiness
}

func getAllParticipants(changesInHappiness: [ChangeInHappiness]) -> [String] {
    var participants = [String]()
    for change in changesInHappiness {
        if !participants.contains(change.of) {
            participants.append(change.of)
        }
    }
    return participants
}

func getAllPossibleOrders(participants: [String]) -> [[String]] {
    var allPossibleOrders = [[String]]()
    if participants.count == 1 {
        return [participants]
    }
    for (index, participant) in participants.enumerated() {
        var copy = participants
        copy.remove(at: index)
        let possibleOrders = getAllPossibleOrders(participants: copy)
        for possibleOrder in possibleOrders {
            var copyOfOrder = possibleOrder
            copyOfOrder.append(participant)
            allPossibleOrders.append(copyOfOrder)
        }
    }
    return allPossibleOrders
}

func getTotalHappinessChangeOfOrder(order: [String], changesInHappiness: [ChangeInHappiness]) -> Int {
    var happinessChange = 0

    for i in 0..<order.count - 1 {
        let changeOneWay = (changesInHappiness.filter { $0.of == order[i] && $0.nextTo == order[i + 1]})[0]
        let changeSecondWay = (changesInHappiness.filter { $0.of == order[i + 1] && $0.nextTo == order[i]})[0]
        happinessChange += changeOneWay.happiness + changeSecondWay.happiness
    }
    
    let lastChangeOneWay = (changesInHappiness.filter { $0.of == order[order.count - 1] && $0.nextTo == order[0]})[0]
    let lastChangeSecondWay = (changesInHappiness.filter { $0.of == order[0] && $0.nextTo == order[order.count - 1]})[0]
    happinessChange += lastChangeOneWay.happiness + lastChangeSecondWay.happiness
    return happinessChange
}

func getMaxHappiness(changesInHappiness: [ChangeInHappiness]) -> Int {
    var allHappinesses = [Int]()

    var participants = getAllParticipants(changesInHappiness: changesInHappiness)
    // we can fix the first participant, so that we don't treat the same order many times
    // ["Alice", "Bob", "Max"] is the same as ["Max", "Alice", "Bob"]
    let firstParticipant = participants[0]
    participants.remove(at: 0)
    let allPossibleOrdersWithoutFirstParticipant = getAllPossibleOrders(participants: participants)
    for possibleOrder in allPossibleOrdersWithoutFirstParticipant {
        var order = possibleOrder
        order.append(firstParticipant)
        allHappinesses.append(getTotalHappinessChangeOfOrder(order: order, changesInHappiness: changesInHappiness))
    }
    return allHappinesses.max()!
}

func addMyselfToTheChanges(changesInHappiness: [ChangeInHappiness]) -> [ChangeInHappiness] {
    let participants = getAllParticipants(changesInHappiness: changesInHappiness)
    var newChanges = [ChangeInHappiness]()
    newChanges.append(contentsOf: changesInHappiness)
    for participant in participants {
        newChanges.append(ChangeInHappiness(of: "Me", nextTo: participant, happiness: 0))
        newChanges.append(ChangeInHappiness(of: participant, nextTo: "Me", happiness: 0))
    }
    return newChanges
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let changes = createChangesOfHappiness(contents: contents)
    print("Result part 1: \(getMaxHappiness(changesInHappiness: changes))")
    
    let changesOfHappinessWithMe = addMyselfToTheChanges(changesInHappiness: changes)
    print("Result part 2: \(getMaxHappiness(changesInHappiness: changesOfHappinessWithMe))")
}
