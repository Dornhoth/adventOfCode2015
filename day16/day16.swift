//
//  day16.swift
//  
//
//  Created by Dornhoth on 28.07.19.
//

import Foundation

struct AuntSue {
    var number: Int
    var children: Int
    var cats: Int
    var samoyeds: Int
    var pomeranians: Int
    var akitas: Int
    var vizslas: Int
    var goldfish: Int
    var trees: Int
    var cars: Int
    var perfumes: Int
}

func getAmountOf(object: String, line: String) -> Int {
    let searched = object + "\\:\\s([0-9][0-9]*)"
    let regex = try! NSRegularExpression(pattern: searched, options: NSRegularExpression.Options.caseInsensitive)
    let results = regex.matches(in: line,
                                range: NSMakeRange(0, line.count))
    let resultsAsString = results.map {
        String(line[Range($0.range, in: line)!]) }
    var amount = -1
    if resultsAsString.count > 0 {
        amount = Int(resultsAsString[0].components(separatedBy: ": ")[1])!
    }
    return amount
}

func createOneAuntSue(line: String) -> AuntSue {
    var lineSplit = line.components(separatedBy: ": ")
    let number = Int(String(lineSplit[0]).components(separatedBy: " ")[1])!
    let children = getAmountOf(object: "children", line: line)
    let cats = getAmountOf(object: "cats", line: line)
    let samoyeds = getAmountOf(object: "samoyeds", line: line)
    let pomeranians = getAmountOf(object: "pomeranians", line: line)
    let akitas = getAmountOf(object: "akitas", line: line)
    let vizslas = getAmountOf(object: "vizslas", line: line)
    let goldfish = getAmountOf(object: "goldfish", line: line)
    let trees = getAmountOf(object: "trees", line: line)
    let cars = getAmountOf(object: "cars", line: line)
    let perfumes = getAmountOf(object: "perfumes", line: line)

    return AuntSue(number: number, children: children, cats: cats, samoyeds: samoyeds,
                   pomeranians: pomeranians, akitas: akitas, vizslas: vizslas,
                   goldfish: goldfish, trees: trees, cars: cars, perfumes: perfumes)
}

func createAuntsSue(contents: String) -> [AuntSue] {
    var aunts = [AuntSue]()
    let lines = contents.components(separatedBy: "\n")
    for line in lines {
        aunts.append(createOneAuntSue(line: line))
    }
    return aunts
}

func getRightAuntsPart1(aunts: [AuntSue]) -> [AuntSue] {
    return aunts.filter {
        ($0.children == 3 || $0.children == -1)
        && ($0.cats == 7 || $0.cats == -1)
        && ($0.samoyeds == 2 || $0.samoyeds == -1)
        && ($0.pomeranians == 3 || $0.pomeranians == -1)
        && ($0.akitas == 0 || $0.akitas == -1)
        && ($0.vizslas == 0 || $0.vizslas == -1)
        && ($0.goldfish == 5 || $0.goldfish == -1)
        && ($0.trees == 3 || $0.trees == -1)
        && ($0.cars == 2 || $0.cars == -1)
        && ($0.perfumes == 1 || $0.perfumes == -1)
    }
}

func getRightAuntsPart2(aunts: [AuntSue]) -> [AuntSue] {
    return aunts.filter {
        ($0.children == 3 || $0.children == -1)
            && ($0.cats > 7 || $0.cats == -1)
            && ($0.samoyeds == 2 || $0.samoyeds == -1)
            && ($0.pomeranians < 3 || $0.pomeranians == -1)
            && ($0.akitas == 0 || $0.akitas == -1)
            && ($0.vizslas == 0 || $0.vizslas == -1)
            && ($0.goldfish < 5 || $0.goldfish == -1)
            && ($0.trees > 3 || $0.trees == -1)
            && ($0.cars == 2 || $0.cars == -1)
            && ($0.perfumes == 1 || $0.perfumes == -1)
    }
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let auntsSue = createAuntsSue(contents: contents)
   
    let auntsPart1 = getRightAuntsPart1(aunts: auntsSue)
    if auntsPart1.count == 1 {
        print("Result part 1: \(auntsPart1[0].number)")
    }

    let auntsPart2 = getRightAuntsPart2(aunts: auntsSue)
    if auntsPart2.count == 1 {
        print("Result part 2: \(auntsPart2[0].number)")
    }
}
