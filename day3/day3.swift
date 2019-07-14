//
//  day3.swift
//  
//
//  Created by Heloise Parein on 14.07.19.
//

import Foundation

class House {
    var x: Int;
    var y: Int;
    
    init(x: Int, y: Int) {
        self.x = x;
        self.y = y;
    }
}

class DeliveryGuy {
    static var visited = [House(x: 0, y: 0)]
    static func reset() {
        DeliveryGuy.visited = [House]()
    }
    
    var location: House;
    
    init() {
        self.location = House(x: 0, y: 0);
    }
    
    func goTo(house: House) {
        let alreadyVisited = DeliveryGuy.visited.filter {$0.x == house.x && $0.y == house.y}
        if alreadyVisited.count == 0 {
            DeliveryGuy.visited.append(house);
        }
        location = house;
    }

    func goNorth() {
        goTo(house: House(x: location.x, y: location.y + 1));
    }

    func goSouth() {
        goTo(house: House(x: location.x, y: location.y - 1));
    }

    func goEast() {
        goTo(house: House(x: location.x - 1, y: location.y));
    }

    func goWest() {
        goTo(house: House(x: location.x + 1, y: location.y));
    }

    func followInstruction(instruction: String) {
        switch(instruction) {
        case "^":
            goNorth();
        case "v":
            goSouth();
        case ">":
            goEast();
        case "<":
            goWest();
        default:
            goWest();
        }
    }
}

func getVisitedHousesWithOneDeliveryGuy(input: String) -> Int{
    let santa = DeliveryGuy();
    let instructions = Array(input);
    
    for instruction in instructions {
        santa.followInstruction(instruction: String(instruction));
    }
    return DeliveryGuy.visited.count;
}

func getVisitedHousesWithTwoDeliveryGuys(input: String) -> Int{
    let santa = DeliveryGuy();
    let roboSanta = DeliveryGuy();

    let instructions = Array(input);
    
    for i in 0..<instructions.count {
        let instruction = instructions[i];
        if i % 2 == 0 {
              santa.followInstruction(instruction: String(instruction));
        } else {
                roboSanta.followInstruction(instruction: String(instruction));
        }
    }
    return DeliveryGuy.visited.count;
}

print("Enter input file path:");
if let path = readLine() {
    let input = try String(contentsOfFile: path, encoding: .utf8);
    let resultPart1 = getVisitedHousesWithOneDeliveryGuy(input: input);
    DeliveryGuy.reset();
    let resultPart2 = getVisitedHousesWithTwoDeliveryGuys(input: input);
    
    print("Result part 1 : \(resultPart1)");
    print("Result part 2 : \(resultPart2)");
}
