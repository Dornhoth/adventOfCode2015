//
//  File.swift
//  
//
//  Created by Dornhoth on 04.08.19.
//

import Foundation

func getLowestHouseNumberGettingInput(_ input: Int) -> Int {
    var houses=[Int]()
    
    for _ in 1...input / 10 {
        houses.append(0)
    }
    for i in 1...input / 10 {
        var j = i
        while j < input / 10 {
            houses[j] += i * 10
            j += i
        }
    }
    var index = 1
    var found = false

    while index < input / 10 && !found {
        found = houses[index] >= input
        index += 1
    }
    return (index - 1)
}

func getLowestHouseNumberGettingInputPart2(_ input: Int) -> Int {
    var houses=[Int]()
    
    for _ in 1...input / 10 {
        houses.append(0)
    }
    for i in 1...input/10 {
        var j = i
        var delivered = 0
        while j < input / 10 && delivered < 50 {
            houses[j] += i * 11
            j += i
            delivered += 1
        }
    }
    var index = 1
    var found = false
    
    while index < input / 10 && !found {
        found = houses[index] >= input
        index += 1
    }
    return (index - 1)
}

print("Enter input:");
if let inputAsString = readLine() {
    let input = Int(inputAsString)!

    print("Result part 1: \(getLowestHouseNumberGettingInput(input))")
    print("Result part 2: \(getLowestHouseNumberGettingInputPart2(input))")
}
