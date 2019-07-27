//
//  day14.swift
//  
//
//  Created by Dornhoth on 27.07.19.
//

import Foundation

class Reindeer {
    var name: String
    var speed: Int
    var runningTime: Int
    var restTime: Int
    var cycleTime: Int {
        return runningTime + restTime
    }
    var distanceCycle: Int {
        return speed * runningTime
    }
    //part 2
    var point = 0
    var currentPosition = 0
    
    init(name: String, speed: Int, runningTime: Int, restTime: Int) {
        self.name = name
        self.speed = speed
        self.runningTime = runningTime
        self.restTime = restTime
    }
    
    func getDistanceAfter(seconds: Int) -> Int {
        let numberOfCycles = seconds / cycleTime
        
        if seconds % cycleTime > runningTime {
            return (numberOfCycles + 1) * distanceCycle
        }
            return numberOfCycles * distanceCycle + seconds % cycleTime * speed
    }
    
    func setNextPosition(time: Int) {
        if 0 < time % cycleTime && time % cycleTime <= runningTime {
            currentPosition += speed
        }
    }
    
    func addPoint() {
        point += 1
    }
}

func createReindeer(line: String) -> Reindeer {
    let lineSplit = line.components(separatedBy: " ")
    let name = String(lineSplit[0])
    let speed = Int(String(lineSplit[3]))!
    let runningTime = Int(String(lineSplit[6]))!
    let restTime = Int(String(lineSplit[13]))!
    return Reindeer(name: name, speed: speed, runningTime: runningTime, restTime: restTime)
}

func createReindeers(contents: String) -> [Reindeer] {
    var reindeers = [Reindeer]()
    let lines = contents.components(separatedBy: "\n")
    for line in lines {
        reindeers.append(createReindeer(line: line))
    }
    return reindeers
}

func getMaxDistanceOfAllReindersAfter(seconds: Int, reindeers: [Reindeer]) -> Int {
    var distances = [Int]()
    
    for reindeer in reindeers {
        distances.append(reindeer.getDistanceAfter(seconds: seconds))
    }
    return distances.max()!
}

func getMaxPointsOfAllReindersAfter(seconds: Int, reindeers: [Reindeer]) -> Int {
    for second in 1...seconds {
        for reindeer in reindeers {
            reindeer.setNextPosition(time: second)
        }
        var firstReindeers = [Reindeer]()
        for reindeer in reindeers {
            if firstReindeers.count == 0 || reindeer.currentPosition > firstReindeers[0].currentPosition {
                firstReindeers = [reindeer]
            } else if reindeer.currentPosition == firstReindeers[0].currentPosition {
                firstReindeers.append(reindeer)
            }
        }
        for reindeer in firstReindeers {
            reindeer.addPoint()
        }
    }
    return reindeers.map { $0.point }.max()!
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let reindeers = createReindeers(contents: contents)
    print("Result part 1: \(getMaxDistanceOfAllReindersAfter(seconds: 2503, reindeers: reindeers))")
    print("Result part 2: \(getMaxPointsOfAllReindersAfter(seconds: 2503, reindeers: reindeers))")
}
