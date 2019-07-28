//
//  day17.swift
//  
//
//  Created by Dornhoth on 28.07.19.
//

import Foundation


func getAvailableSizes(contents: String) -> [Int] {
    var availableSizes = [Int]()
    let lines = contents.components(separatedBy: "\n")
    for line in lines {
        availableSizes.append(Int(line)!)
    }
    return availableSizes
}

func getAllPossibleCombinations(availableSizes: [Int], goal: Int) -> [[Int]] {
    if availableSizes.count == 1 {
        if goal == 0 {
            return [[0]]
        }
        if goal == availableSizes[0] {
            return [[1]]
        }
        return []
    }
    
    var allPossibleCombinations = [[Int]]()
    let firstOne = availableSizes[0]
    var newAvailableSizes = availableSizes
    newAvailableSizes.remove(at: 0)
    var amountOfFirstOne = 0
    
    while firstOne * amountOfFirstOne <= goal && amountOfFirstOne <= 1 {
        let goalLeft = goal - firstOne * amountOfFirstOne
        let possibleWithTheRest = getAllPossibleCombinations(availableSizes: newAvailableSizes, goal: goalLeft )
        for possible in possibleWithTheRest {
            var completeCombination = [amountOfFirstOne]
            completeCombination.append(contentsOf: possible)
            allPossibleCombinations.append(completeCombination)
        }
        amountOfFirstOne += 1
    }
    return allPossibleCombinations
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let availableSizes = getAvailableSizes(contents: contents)
    let allPossibleCombinations = getAllPossibleCombinations(availableSizes: availableSizes, goal: 150)
    print("Result part 1: \(allPossibleCombinations.count)")
    print("Result part 2: \((allPossibleCombinations.map { $0.filter { $0 > 0} }.map { $0.count }).min()!)")
}
