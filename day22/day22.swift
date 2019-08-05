//
//  day21.swift
//
//
//  Created by Dornhoth on 04.08.19.
//

import Foundation

enum SpellError: Error {
    case unknown
}

struct Spell {
    var name: String
    var mana: Int
}

struct Effect {
    var spell: Spell
    var endEffect: Int
}

class Character {
    var armor: Int
    var damage: Int
    var hp: Int
    var mana: Int
    var effects: [Effect]
    
    init(armor: Int, damage: Int, hp: Int, mana: Int, effects: [Effect]) {
        self.armor = armor
        self.damage = damage
        self.hp = hp
        self.mana = mana
        self.effects = effects
    }
    
    func getAttackedBy(character: Character) {
        hp -= max(1, character.damage - armor)
    }
    
    func useSpell(spell: Spell, character: Character) throws {
        switch spell.name {
        case "Magic Missile":
            mana -= 53
            character.hp -= 4
        case "Drain":
            mana -= 73
            character.hp -= 2
            hp += 2
        case "Shield":
            mana -= 113
            armor = 7
            effects.append(Effect(spell: spell, endEffect: 6))
        case "Poison":
            mana -= 173
            character.effects.append(Effect(spell: spell, endEffect: 6))
        case "Recharge":
            mana -= 229
            effects.append(Effect(spell: spell, endEffect: 5))
        default:
            throw SpellError.unknown
        }
    }
    
    func applyEffects() {
        var newEffects = [Effect]()
        armor = 0
        for effect in effects {
            if effect.endEffect > 0 {
                var newEffect = effect
                newEffect.endEffect -= 1
                if newEffect.spell.name == "Shield" {
                    armor = 7
                }
                if newEffect.spell.name == "Poison" {
                    hp -= 3
                }
                if newEffect.spell.name == "Recharge" {
                    mana += 101
                }
                if newEffect.endEffect > 0 {
                    newEffects.append(newEffect)
                }
            }
        }
        effects = newEffects
    }
}

var minSoFarPart1 = Int.max

func getMinimumManaUsedPart1(boss: Character, me: Character, manaUsed: Int, allSpells: [Spell]) -> Int {
    boss.applyEffects()
    me.applyEffects()
    if me.hp <= 0 {
        return Int.max
    }
    if boss.hp <= 0 {
        return manaUsed
    }
    if manaUsed >= minSoFarPart1 {
        return minSoFarPart1
    }
    
    var usedEffects = [Spell]()
    usedEffects.append(contentsOf: boss.effects.map { $0.spell })
    usedEffects.append(contentsOf: me.effects.map { $0.spell })
    var availableSpells = [Spell]()
    for spell in allSpells {
        if (usedEffects.filter { $0.name == spell.name }).count == 0 && me.mana >= spell.mana {
            availableSpells.append(spell)
        }
    }
    if availableSpells.count == 0 {
        return Int.max
    }
    var results = [Int]()
    for spell in availableSpells {
        let newBoss = Character(armor: boss.armor, damage: boss.damage, hp: boss.hp, mana: 0, effects: boss.effects)
        let newMe = Character(armor: me.armor, damage: me.damage, hp: me.hp, mana: me.mana, effects: me.effects)
        var resultForSpell = Int.max
        try! newMe.useSpell(spell: spell, character: newBoss)
        let newManaUsed = manaUsed + spell.mana
        if newBoss.hp <= 0 {
            resultForSpell = newManaUsed
        } else {
            newBoss.applyEffects()
            newMe.applyEffects()
            if newBoss.hp <= 0 {
                resultForSpell = newManaUsed
            } else {
                newMe.getAttackedBy(character: newBoss)
                if newMe.hp > 0 {
                    resultForSpell = getMinimumManaUsedPart1(boss: newBoss, me: newMe, manaUsed: newManaUsed, allSpells: allSpells)
                }
            }
        }
        results.append(resultForSpell)
    }
    
    let min = results.min()!
    if min < minSoFarPart1 {
        minSoFarPart1 = min
        print(minSoFarPart1)
    }
    return minSoFarPart1
}

var minSoFarPart2 = Int.max

func getMinimumManaUsedPart2(boss: Character, me: Character, manaUsed: Int, allSpells: [Spell]) -> Int {
    me.hp -= 1
    if me.hp <= 0 {
        return Int.max
    }
    boss.applyEffects()
    me.applyEffects()
    if me.hp <= 0 {
        return Int.max
    }
    if boss.hp <= 0 {
        return manaUsed
    }
    if manaUsed >= minSoFarPart2 {
        return minSoFarPart2
    }
    
    var usedEffects = [Spell]()
    usedEffects.append(contentsOf: boss.effects.map { $0.spell })
    usedEffects.append(contentsOf: me.effects.map { $0.spell })
    var availableSpells = [Spell]()
    for spell in allSpells {
        if (usedEffects.filter { $0.name == spell.name }).count == 0 && me.mana >= spell.mana {
            availableSpells.append(spell)
        }
    }
    if availableSpells.count == 0 {
        return Int.max
    }
    var results = [Int]()
    for spell in availableSpells {
        let newBoss = Character(armor: boss.armor, damage: boss.damage, hp: boss.hp, mana: 0, effects: boss.effects)
        let newMe = Character(armor: me.armor, damage: me.damage, hp: me.hp, mana: me.mana, effects: me.effects)
        var resultForSpell = Int.max
        try! newMe.useSpell(spell: spell, character: newBoss)
        let newManaUsed = manaUsed + spell.mana
        if newBoss.hp <= 0 {
            resultForSpell = newManaUsed
        } else {
            newMe.hp -= 1
            if newMe.hp > 0 {
                newBoss.applyEffects()
                newMe.applyEffects()
                if newBoss.hp <= 0 {
                    resultForSpell = newManaUsed
                } else {
                    newMe.getAttackedBy(character: newBoss)
                    if newMe.hp > 0 {
                        resultForSpell = getMinimumManaUsedPart2(boss: newBoss, me: newMe, manaUsed: newManaUsed, allSpells: allSpells)
                    }
                }
            }
        }
        results.append(resultForSpell)
    }
    
    let min = results.min()!
    if min < minSoFarPart2 {
        minSoFarPart2 = min
        print(minSoFarPart2)
    }
    return minSoFarPart2
}

func createBoss(input: String) -> Character {
    let lines = input.components(separatedBy: "\n")
    let hp = Int(String(lines[0].components(separatedBy: ": ")[1]))!
    let damage = Int(String(lines[1].components(separatedBy: ": ")[1]))!
    return Character(armor: 0, damage: damage, hp: hp, mana: 0, effects: [Effect]())
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let boss = createBoss(input: contents)
    let spells = [
        Spell(name: "Magic Missile", mana: 53),
        Spell(name: "Drain", mana: 73),
        Spell(name: "Shield", mana: 113),
        Spell(name: "Poison", mana: 173),
        Spell(name: "Recharge", mana: 229),
    ]
    let me = Character(armor: 0, damage: 0, hp: 50, mana: 500, effects: [Effect]())
    print("Result part 1: \(getMinimumManaUsedPart1(boss: boss, me: me, manaUsed: 0, allSpells: spells))")
    print("Result part 2: \(getMinimumManaUsedPart2(boss: boss, me: me, manaUsed: 0, allSpells: spells))")
}
