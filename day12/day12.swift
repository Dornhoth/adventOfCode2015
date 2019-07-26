//
//  day12.swift
//  
//
//  Created by Dornhoth on 26.07.19.
//

import Foundation

func getAllNumbersSum(str: String) -> Int {
    let regex = try! NSRegularExpression(pattern: #"(-?[1-9][0-9]*)"#, options: NSRegularExpression.Options.caseInsensitive)
    let results = regex.matches(in: str,
                                range: NSMakeRange(0, str.count))
    
    return results.map {
        Int(String(str[Range($0.range, in: str)!]))! }.reduce(0, { x, y in x + y})
}

func sumOverAllJsonArray(json: [Any]) -> Int {
    var sums = [Int]()
    for child in json {
        sums.append(addNumbersExceptIfObjectIsRed(json: child))
    }
    return sums.reduce(0, { x, y in x + y})
}

func addNumbersExceptIfObjectIsRed(json: Any) -> Int {
    if let intKey = json as? Int {
        return intKey
    } else if let jsonArray = json as? [Any] {
        return sumOverAllJsonArray(json: jsonArray)
    } else if let jsonAsDictionary = json as? [String: Any] {
        var sumOfObject = 0
        var isRed = false
        
        for (_, value) in jsonAsDictionary {
            if let stringValue = value as? String, stringValue == "red"  {
                isRed = true
            } else if let intValue = value as? Int {
                sumOfObject += intValue
            } else if let jsonArray = value as? [Any] {
                sumOfObject += sumOverAllJsonArray(json: jsonArray)
            } else {
                sumOfObject += addNumbersExceptIfObjectIsRed(json: value)
            }
        }
        return isRed ? 0 : sumOfObject
    }
    return 0
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    print("Result part 1: \(getAllNumbersSum(str: contents))")

    let json = try! JSONSerialization.jsonObject(with: Data(contents.utf8), options: [])
    print("Result part 2: \(addNumbersExceptIfObjectIsRed(json: json))")
}
