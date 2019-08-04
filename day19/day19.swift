//  day19.swift
//  
//
//  Created by Dornhoth on 01.08.19.
//

import Foundation


struct Iteration {
    var molecule: String
    var length: Int
}

struct Transformation {
    var from: String
    var to: String
}

func getAllTransformations(lines: [String]) -> [Transformation] {
    var transformations = [Transformation]()
    
    for line in lines {
        if line.count > 0 {
            let parts = line.components(separatedBy: " => ")
            transformations.append(Transformation(from: parts[0], to: parts[1]))
        }
    }
    return transformations
}

func getElements(input: String) -> [String] {
    let regex = try! NSRegularExpression(pattern: #"e|[A-Z][a-z]?"#)
    let results = regex.matches(in: input,
                                range: NSMakeRange(0, input.count))
    let resultsAsString = results.map {
        String(input[Range($0.range, in: input)!]) }
    return resultsAsString
}

func getAllPossibleNextForElement(element: String, transformations: [Transformation]) -> [String] {
    return transformations.filter { $0.from == element}.map { $0.to }
}

func getAllPossibleNextReplacingOneAtOnce(elements: [String], transformations: [Transformation]) -> [String] {
    var result = [String]()
    for (index, element) in elements.enumerated() {
        let allPossibleForElement = getAllPossibleNextForElement(element: element, transformations: transformations)
        var newPossibleFront = ""
        var newPossibleBack = ""
        for i in 0..<index {
            newPossibleFront += elements[i]
        }
        for i in (index+1)..<elements.count {
            newPossibleBack += elements[i]
        }
        for possible in allPossibleForElement {
            let newPossible = newPossibleFront + possible + newPossibleBack
            if !result.contains(newPossible) {
                result.append(newPossible)
            }
        }
    }
    return result
}

func getAmountArAndRn(input: String) -> Int {
    let regex = try! NSRegularExpression(pattern: #"Ar|Rn"#)
    let results = regex.matches(in: input,
                                range: NSMakeRange(0, input.count))
    return results.count
}

func getAmountY(input: String) -> Int {
    let regex = try! NSRegularExpression(pattern: #"Y"#)
    let results = regex.matches(in: input,
                                range: NSMakeRange(0, input.count))
    return results.count
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let lines = contents.components(separatedBy: "\n");
    
    let transformations = getAllTransformations(lines: Array(lines[0...lines.count - 3]))
    let elements = getElements(input: lines[(lines.count - 1)])
    let allPossible = getAllPossibleNextReplacingOneAtOnce(elements: elements, transformations: transformations)

    print("Result part 1: \(allPossible.count)")

    // by looking at the input file, it comes down to an easy formula
    // check https://www.reddit.com/r/adventofcode/comments/3xflz8/day_19_solutions/
    let amountArAndRn = getAmountArAndRn(input:lines[(lines.count - 1)])
    let amountY = getAmountY(input:lines[(lines.count - 1)])
    print("Result part 2: \(elements.count - amountArAndRn - 2 * amountY - 1)")
}
