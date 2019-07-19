//
//  day7.swift
//  
//
//  Created by Dornhoth on 17.07.19.
//

import Foundation

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

private enum Actions: String{
    case OR, AND, RSHIFT, LSHIFT
}

func getValue(str: String, wires: [String: UInt16]) -> UInt16? {
    if str.isInt {
        return UInt16(str)
    }
    return wires[str]
}

func followInsructions(content: String, initB: UInt16?) -> UInt16 {
    var wires = [String: UInt16]()
    if let initialValue = initB {
        wires["b"] = initialValue
    }

    var lines = content.components(separatedBy: "\n");
    while lines.count > 0 {
        let line = lines.first!
        lines.removeFirst(1)
        var leftAndRifght = line.components(separatedBy: " -> ")
        let target = leftAndRifght[1]
        var leftCommand = leftAndRifght[0].split(separator: " ")

        if leftCommand.count == 1 {
            if let value = getValue(str: String(leftCommand[0]), wires: wires){
                if initB == nil || target != "b" {
                    wires[target] = value
                }
            } else {
                lines.append(line)
            }
        } else if leftCommand.count == 2 && leftCommand[0] == "NOT" {
            if String(leftCommand[1]).isInt {
                wires[target] = ~UInt16(leftCommand[1])!
            } else if let wire = wires[String(leftCommand[1])] {
                wires[target] = ~wire
            } else {
                lines.append(line)
            }
        } else if leftCommand.count == 3 {
            if let command = Actions(rawValue: String(leftCommand[1])) {
                let leftOptional = getValue(str: String(leftCommand[0]), wires: wires)
                let rightOptional = getValue(str: String(leftCommand[2]), wires: wires)
                
                if let left = leftOptional, let right = rightOptional {
                    switch(command) {
                    case Actions.OR:
                        wires[target] = left | right
                    case Actions.AND:
                        wires[target] = left & right
                    case Actions.RSHIFT:
                        wires[target] = left >> right
                    case Actions.LSHIFT:
                        wires[target] = left << right
                    }
                } else {
                    lines.append(line)
                }
            }
        }
    }
    return wires["a"]!
}


print("Enter input file path:");
var pathOptional = readLine();
if let path = pathOptional {
    let content = try String(contentsOfFile: path, encoding: .utf8);
    let resultPart1 = followInsructions(content: content, initB: nil)
    let resultPart2 = followInsructions(content: content, initB: resultPart1)

    print("Result part 1: \(resultPart1)")
    print("Result part 2: \(resultPart2)")
}
