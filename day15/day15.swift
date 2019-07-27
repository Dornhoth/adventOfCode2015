//
//  day15.swift
//  
//
//  Created by Dornhoth on 27.07.19.
//

import Foundation

struct Ingredient {
    var name: String
    var capacity: Int
    var durability: Int
    var flavor: Int
    var texture: Int
    var calories: Int
}

func createIngredient(line: String) -> Ingredient {
    var lineSplit = line.components(separatedBy: ": ")
    let name = String(lineSplit[0])
    let regex = try! NSRegularExpression(pattern: #"(-?[0-9][0-9]*)"#, options: NSRegularExpression.Options.caseInsensitive)
    let valuesAsString = lineSplit[1]
    let results = regex.matches(in: valuesAsString,
                                range: NSMakeRange(0, valuesAsString.count))
    let resultsAsInt = results.map {
        Int(String(valuesAsString[Range($0.range, in: valuesAsString)!]))! }
    return Ingredient(name: name, capacity: resultsAsInt[0], durability: resultsAsInt[1],
                      flavor: resultsAsInt[2], texture: resultsAsInt[3], calories: resultsAsInt[4])
}

func createIngredients(contents: String) -> [Ingredient] {
    var ingredients = [Ingredient]()
    let lines = contents.components(separatedBy: "\n")
    for line in lines {
        ingredients.append(createIngredient(line: line))
    }
    return ingredients
}

func getAllPossibleCombinations(arrayLength: Int, teaspoonAmount: Int) -> [[Int]] {
    var possibleCombinations = [[Int]]()
    if arrayLength == 1 {
        return [[teaspoonAmount]]
    }
    for i in 0...teaspoonAmount {
        let allCombinationsWithLeft = getAllPossibleCombinations(arrayLength: arrayLength - 1,
                                                                 teaspoonAmount: teaspoonAmount - i)
        for combination in allCombinationsWithLeft {
            var totalCombation = [i]
            totalCombation.append(contentsOf: combination)
            possibleCombinations.append(totalCombation)
        }
    }
    return possibleCombinations
}

func getMaximumScore(possibleCombinations: [[Int]], ingredients: [Ingredient]) -> Int {
    var maxScore = 0

    for combination in possibleCombinations {
        var totalCapacity = 0
        var totalDurability = 0
        var totalFlavor = 0
        var totalTexture = 0
        var totalCalories = 0
        
        for i in 0..<combination.count {
            totalCapacity += combination[i] * ingredients[i].capacity
            totalDurability += combination[i] * ingredients[i].durability
            totalFlavor += combination[i] * ingredients[i].flavor
            totalTexture += combination[i] * ingredients[i].texture
            totalCalories += combination[i] * ingredients[i].calories
        }
        
        // total calories check only for part 2
        if totalCalories == 500 {
            let score = max(totalCapacity, 0) * max(totalDurability, 0) * max(totalFlavor, 0) * max(totalTexture, 0)
            
            if score > maxScore {
                maxScore = score
            }
        }
    }
    return maxScore
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let ingredients = createIngredients(contents: contents)
    let allCombinations = getAllPossibleCombinations(arrayLength: ingredients.count, teaspoonAmount: 100)
    print("Result: \(getMaximumScore(possibleCombinations: allCombinations, ingredients: ingredients))")
}
