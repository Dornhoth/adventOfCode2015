//
//  day5.swift
//  
//
//  Created by Dornhoth on 16.07.19.
//

import Foundation

func hasTwoEqualConsecutivesChar(str: String) -> Bool {
    return str.range(of: #"([a-z])\1"#,
                      options: .regularExpression) != nil
}

func hasAtLeastThreeVocals(str: String) -> Bool {
    return str.range(of: #"([aeiou](.*)){3}"#,
                  options: .regularExpression) != nil
}

func doesntContainForbiddenStrings(str: String) -> Bool {
    return !str.contains("ab")
        && !str.contains("cd")
        && !str.contains("pq")
        && !str.contains("xy")
}

func hasRepeatingPair(str: String) -> Bool {
    return str.range(of: #"([a-z]{2})(?=.*\1)"#,
                     options: .regularExpression) != nil
}

func hasOneReatingCharWithOneInBetween(str: String) -> Bool {
    return str.range(of: #"([a-z])(?=.\1)"#,
                      options: .regularExpression) != nil
}

func amountOfNiceStringsPart1(input: [String]) -> Int {
    var result = 0;
    for str in input {
        if (doesntContainForbiddenStrings(str: str)
            && hasAtLeastThreeVocals(str: str)
            && hasTwoEqualConsecutivesChar(str: str)) {
            result += 1;
        }
    }
    return result;
}

func amountOfNiceStringsPart2(input: [String]) -> Int {
    var result = 0;
    for str in input {
        if (hasRepeatingPair(str: str)
            && hasOneReatingCharWithOneInBetween(str: str)) {
            result += 1;
        }
    }
    return result;
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8);
    let lines = contents.components(separatedBy: "\n");
    let resultPart1 = amountOfNiceStringsPart1(input: lines);
    let resultPart2 = amountOfNiceStringsPart2(input: lines);

    
    print("Result part 1 : \(resultPart1)");
    print("Result part 2 : \(resultPart2)");
}
