//
//  day8.swift
//
//  Created by Dornhoth on 20.07.19.
//

import Foundation

func replaceCharsPart1(str: String) -> String {
    let regex = try! NSRegularExpression(pattern: #"(\\\\)|(\\")|(\\x[0-9a-f]{2})"#, options: NSRegularExpression.Options.caseInsensitive)
    let range = NSMakeRange(0, str.count)
    let modString = regex.stringByReplacingMatches(in: str, options: [], range: range, withTemplate: "P")
    return modString
}

func replaceCharsPart2(str: String) -> String {
    let regexAsciiCode = try! NSRegularExpression(pattern: #"\\x[0-9a-f]{2}"#, options: NSRegularExpression.Options.caseInsensitive)
    let regexBackSlashOrDoubleQuotes = try! NSRegularExpression(pattern: #"(\\\\)|(\\")"#, options: NSRegularExpression.Options.caseInsensitive)
    
    var range = NSMakeRange(0, str.count)
    let modString = regexAsciiCode.stringByReplacingMatches(in: str, options: [], range: range, withTemplate: "PPPPP")
    range = NSMakeRange(0, modString.count)
    let modString2 = regexBackSlashOrDoubleQuotes.stringByReplacingMatches(in: modString, options: [], range: range, withTemplate: "PPPP")
    return modString2
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let lines = contents.components(separatedBy: "\n")
    var resultPart1 = 0
    var resultPart2 = 0
    for line in lines {
        resultPart1 += line.count + 2
        resultPart2 -= line.count

        let newStr1 = replaceCharsPart1(str: line)
        let newStr2 = replaceCharsPart2(str: line)

        resultPart1 -= newStr1.count
        resultPart2 += newStr2.count + 4
    }
    print("Result part 1: \(resultPart1)")
    print("Result part 2: \(resultPart2)")
}
