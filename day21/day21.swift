//
//  day21.swift
//  
//
//  Created by Dornhoth on 04.08.19.
//

import Foundation

struct Item {
    var damage: Int
    var armor: Int
    var cost: Int
}

struct Character {
    var armor: Int
    var damage: Int
    var hp: Int

    mutating func getAttackedBy(character: Character) {
        hp -= max(1, character.damage - armor)
    }
}

func doIWin(inputBoss: String, equipment: [Item]) -> Bool {
    var boss = createBoss(input: inputBoss)
    var totalArmorEquipment = 0
    var totalDamageEquipment = 0
    for item in equipment {
        totalArmorEquipment += item.armor
        totalDamageEquipment += item.damage
    }
    var me = Character(armor: totalArmorEquipment, damage: totalDamageEquipment, hp: 100)
    var bossDead = false
    var meDead = false
    while !bossDead && !meDead {
        boss.getAttackedBy(character: me)
        if boss.hp <= 0 {
            bossDead = true
        }
        me.getAttackedBy(character: boss)
        if me.hp <= 0 {
            meDead = true
        }
    }
    return bossDead
}

func getAllRingsCombinations(rings: [Item]) -> [[Item]] {
    var combinations =  [[Item]]()
    combinations.append([])
    for (index, ring) in rings.enumerated() {
        combinations.append([ring])
        for i in (index+1)..<rings.count {
            combinations.append([ring, rings[i]])
        }
    }
    return combinations
}

func getAllCombinations(weapons: [Item], armor: [Item], rings: [Item]) -> [[Item]] {
    var allCombinations = [[Item]]()
    let allRingsCombination = getAllRingsCombinations(rings: rings)
    
    for combination in allRingsCombination {
        for weapon in weapons {
            var new = combination
            new.append(weapon)
            allCombinations.append(new)
            for mail in armor {
                var withMail = new
                withMail.append(mail)
                allCombinations.append(withMail)
            }
        }
    }
    return allCombinations
}

func getCostOfEquipment(_ equipment: [Item]) -> Int {
    var sum: Int = 0
    for item in equipment {
        sum += item.cost
    }
    return sum
}

func selectCheaperEquipment(input: String, allCombinations: [[Item]]) -> [Item] {
    var copy = allCombinations
    copy.sort { getCostOfEquipment($0) < getCostOfEquipment($1) }
    var found = false
    var index = 0
    
    while !found && index < copy.count {
        if doIWin(inputBoss: input, equipment: copy[index]) {
            found = true
        }
        index += 1
    }
    return copy[index - 1]
}

func selectMostExpensiveEquipment(input: String, allCombinations: [[Item]]) -> [Item] {
    var copy = allCombinations
    copy.sort { getCostOfEquipment($0) > getCostOfEquipment($1) }
    var found = false
    var index = 0
    
    while !found && index < copy.count {
        if !doIWin(inputBoss: input, equipment: copy[index]) {
            found = true
        }
        index += 1
    }
    return copy[index - 1]
}

func createBoss(input: String) -> Character {
    let lines = input.components(separatedBy: "\n")
    let hp = Int(String(lines[0].components(separatedBy: ": ")[1]))!
    let damage = Int(String(lines[1].components(separatedBy: ": ")[1]))!
    let armor = Int(String(lines[2].components(separatedBy: ": ")[1]))!
    return Character(armor: armor, damage: damage, hp: hp)
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let weapons = [
        Item(damage: 4, armor: 0, cost: 8),
        Item(damage: 5, armor: 0, cost: 10),
        Item(damage: 6, armor: 0, cost: 25),
        Item(damage: 7, armor: 0, cost: 40),
        Item(damage: 8, armor: 0, cost: 74),
    ]
    let armor = [
        Item(damage: 0, armor: 1, cost: 13),
        Item(damage: 0, armor: 2, cost: 31),
        Item(damage: 0, armor: 3, cost: 53),
        Item(damage: 0, armor: 4, cost: 75),
        Item(damage: 0, armor: 5, cost: 102),
    ]
    let rings = [
        Item(damage: 1, armor: 0, cost: 25),
        Item(damage: 2, armor: 0, cost: 50),
        Item(damage: 3, armor: 0, cost: 100),
        Item(damage: 0, armor: 1, cost: 20),
        Item(damage: 0, armor: 2, cost: 40),
        Item(damage: 0, armor: 3, cost: 80),
    ]
    let allCombinations = getAllCombinations(weapons: weapons, armor: armor, rings: rings)
    let equipmentPart1 = selectCheaperEquipment(input: contents, allCombinations: allCombinations)
    let equipmentPart2 = selectMostExpensiveEquipment(input: contents, allCombinations: allCombinations)

    
    print("Result part 1: \(getCostOfEquipment(equipmentPart1))")
    print("Result part 2: \(getCostOfEquipment(equipmentPart2))")
}
