//
//  OpenQuizz
//
//  Created by Dornhoth on 16.07.19.
//

//
//  day6.swift
//
//  Created by Dornhoth on 16.07.19.
//

import Foundation

private class Light {
    var on = false;
    var brightness = 0;
    
    public func toggle() {
        on = !self.on
        brightness += 2
    }
    
    public func turnOn() {
        on = true;
        brightness += 1
    }
    
    public func turnOff() {
        on = false
        if brightness > 0 {
            brightness -= 1
        }
    }
}

private class Grid {
    var lights: [[Light]]
    
    init() {
        lights = []
        
        for i in 0...999 {
            lights.append([])
            for _ in 0...999 {
                lights[i].append(Light())
            }
        }
    }
    
    public func turnOn(start: [Int], end: [Int]) {
        for i in start[0]...end[0] {
            for j in start[1]...end[1] {
                lights[i][j].turnOn()
            }
        }
    }
    
    public func turnOff(start: [Int], end: [Int]) {
        for i in start[0]...end[0] {
            for j in start[1]...end[1] {
                lights[i][j].turnOff()
            }
        }
    }
    
    public func toggle(start: [Int], end: [Int]) {
        for i in start[0]...end[0] {
            for j in start[1]...end[1] {
                lights[i][j].toggle()
            }
        }
    }
    
    public func amountOfLightsOn() -> Int {
        var amount = 0;
        for i in 0...999 {
            for j in 0...999 {
                if lights[i][j].on {
                    amount += 1
                }
            }
        }
        return amount
    }
    
    public func totalBrightness() -> Int {
        var amount = 0;
        for i in 0...999 {
            for j in 0...999 {
                amount += lights[i][j].brightness
            }
        }
        return amount
    }
}

private func readLine(line: String, grid: Grid) {
    var leftAndRifght = line.components(separatedBy: " through ")
    let end = leftAndRifght[1].split(separator: ",").map { Int($0)! }
    var leftInstruction = leftAndRifght[0].split(separator: " ");
    let start = leftInstruction[leftInstruction.count - 1 ]
        .split(separator: ",")
        .map { Int($0)! }
    
    if leftInstruction.count == 3 && leftInstruction[0] == "turn"  {
        if leftInstruction[1] == "on" {
            grid.turnOn(start: start, end: end)
        } else if leftInstruction[1] == "off" {
            grid.turnOff(start: start, end: end)
        }
    } else if leftInstruction.count == 2 && leftInstruction[0] == "toggle" {
        grid.toggle(start: start, end: end)
    }
}

print("Enter input file path:");
var pathOptional = readLine();
if let path = pathOptional {
    let contents = try String(contentsOfFile: path, encoding: .utf8);
    let lines = contents.components(separatedBy: "\n");
    
    let grid = Grid();
    for line in lines {
        readLine(line: line, grid: grid)
    }
    print("Result part 1: \(grid.amountOfLightsOn())")
    print("Result part 2: \(grid.totalBrightness())")
    
}
