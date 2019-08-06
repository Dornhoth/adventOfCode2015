//
//  day23.swift
//  
//
//  Created by Dornhoth on 06.08.19.
//

import Foundation

struct Intstruction {
    var name: String
    var argument: String
}


func runInstructions(instructions: [Intstruction], initialValues: [Int]) -> [Int] {
    var results = initialValues
    
    var nextInstructionIndex = 0
    
    while nextInstructionIndex >= 0 && nextInstructionIndex < instructions.count {
        let nextInstruction = instructions[nextInstructionIndex]
        
        if nextInstruction.name == "hlf" {
            if nextInstruction.argument == "a" {
                results[0] /= 2
            } else if nextInstruction.argument == "b" {
                results[1] /= 2
            }
            nextInstructionIndex += 1
        }
        
        if nextInstruction.name == "tpl" {
            if nextInstruction.argument == "a" {
                results[0] *= 3
            } else if nextInstruction.argument == "b" {
                results[1] *= 3
            }
            nextInstructionIndex += 1
        }
        
        if nextInstruction.name == "inc" {
            if nextInstruction.argument == "a" {
                results[0] += 1
            } else if nextInstruction.argument == "b" {
                results[1] += 1
            }
            nextInstructionIndex += 1
        }
        
        if nextInstruction.name == "jmp" {
            nextInstructionIndex += Int(nextInstruction.argument)!
        }
        
        if nextInstruction.name == "jie" {
            let argumentSplit = nextInstruction.argument.components(separatedBy: ", ").map { String($0) }
            if (argumentSplit[0] == "a" && results[0] % 2 == 0)
            || (argumentSplit[0] == "b" && results[1] % 2 == 0) {
                nextInstructionIndex += Int(argumentSplit[1])!
            } else {
                nextInstructionIndex += 1
            }
        }
        
        if nextInstruction.name == "jio" {
            let argumentSplit = nextInstruction.argument.components(separatedBy: ", ").map { String($0) }
            if (argumentSplit[0] == "a" && results[0] == 1)
                || (argumentSplit[0] == "b" && results[1] == 1) {
                nextInstructionIndex += Int(argumentSplit[1])!
            } else {
                nextInstructionIndex += 1
            }
        }
    }
    
    return results
}

func createInstructions(input: String) -> [Intstruction] {
    let lines = input.components(separatedBy: "\n")
    var instructions = [Intstruction]()
    
    for line in lines {
        let lineSplit = line.split(separator: " ", maxSplits: 1)
        instructions.append(Intstruction(name: String(lineSplit[0]), argument: String(lineSplit[1])))
    }
    return instructions
}


print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let instructions = createInstructions(input: contents)
    let resultsPart1 = runInstructions(instructions: instructions, initialValues: [0, 0])
    let resultsPart2 = runInstructions(instructions: instructions, initialValues: [1, 0])
    print("Result part 1: \(resultsPart1[1])")
    print("Result part 2: \(resultsPart2[1])")
}
