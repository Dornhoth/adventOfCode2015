//
//  day18.swift
//  
//
//  Created by Dornhoth on 30.07.19.
//

import Foundation


class Lamp {
    var on: Bool
    var corner = false
    var willBeOn = false
    
    init(on: Bool) {
        self.on = on
    }
    
    func calculateNextState(onNeighbors: Int) {
        if corner || onNeighbors == 3  || (on && onNeighbors == 2) {
            willBeOn = true
        } else {
            willBeOn = false
        }
    }
    
    func setNextState() {
        on = willBeOn
        willBeOn = false
    }
}

struct Grid {
    var lamps: [[Lamp]]
    
    init(input: String, blockedCorner: Bool) {
        lamps = [[Lamp]]()
        let lines = input.components(separatedBy: "\n")
        for line in lines {
            let elements = Array(line)
            var lineOfLamps = [Lamp]()
            for element in elements {
                if element == "." {
                    lineOfLamps.append(Lamp(on: false))
                } else {
                    lineOfLamps.append(Lamp(on: true))
                }
            }
            lamps.append(lineOfLamps)
        }
        if blockedCorner {
            let yMaxIndex = lamps[0].count - 1
            let xMaxIndex = lamps.count - 1
            lamps[0][0].on = true
            lamps[0][0].corner = true
            lamps[0][yMaxIndex].on = true
            lamps[0][yMaxIndex].corner = true
            lamps[xMaxIndex][yMaxIndex].on = true
            lamps[xMaxIndex][yMaxIndex].corner = true
            lamps[xMaxIndex][0].on = true
            lamps[xMaxIndex][0].corner = true
        }
    }
    
    func nextStep() {
        for i in 0..<lamps.count {
            for j in 0..<lamps[i].count {
                var onNeighbors = 0
                for k in i-1...i+1 {
                    for l in j-1...j+1 {
                        if (i != k || j != l)
                            && k >= 0 && k < lamps.count
                            && l >= 0 && l < lamps[i].count
                            && lamps[k][l].on {
                            onNeighbors += 1
                        }
                    }
                }
                lamps[i][j].calculateNextState(onNeighbors: onNeighbors)
            }
        }
        for i in 0..<lamps.count {
            for j in 0..<lamps[i].count {
                lamps[i][j].setNextState()
            }
        }
    }
    
    func getAmountLampsOn() -> Int {
        var amountOn = 0
        for i in 0..<lamps.count {
            for j in 0..<lamps[i].count {
                if lamps[i][j].on {
                    amountOn += 1
                }
            }
        }
        return amountOn
    }
    
    func toString() -> String {
        var lines = "";
        for i in 0..<lamps.count {
            for j in 0..<lamps.count {
                if lamps[i][j].on {
                    lines += "#"
                } else {
                    lines += "."
                }
            }
            lines += "\n"
        }
        return lines;
    }
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let gridPart1 = Grid(input: contents, blockedCorner: false)
    let gridPart2 = Grid(input: contents, blockedCorner: true)
    for _ in 0..<100 {
        gridPart1.nextStep()
        gridPart2.nextStep()
    }
    print("Result part 1: \(gridPart1.getAmountLampsOn())")
    print("Result part 2: \(gridPart2.getAmountLampsOn())")
}
