//
//  day2.swift
//  
//
//  Created by Dornhoth on 14.07.19.
//

import Foundation


// Part 1
func getAreaOfAllSides(dimensionsAsString: String) -> [Int] {
    let dimensions = dimensionsAsString.components(separatedBy: "x").map { Int($0)! };
    var arrayOfAreas = [
        dimensions[0] * dimensions[1],
        dimensions[0] * dimensions[2],
        dimensions[1] * dimensions[2]
    ];
    arrayOfAreas.sort();
    return arrayOfAreas;
}

func getAreaOfPaperNeededForOnePacket(arrayOfAreas: [Int]) -> Int {
    return 3 * arrayOfAreas[0] + 2 * arrayOfAreas[1] + 2 * arrayOfAreas[2];
}

func getTotalAreaOfPaperNeeded(packets: [String]) -> Int {
    var sum = 0;
    for packet in packets {
        let arrayOfAreas = getAreaOfAllSides(dimensionsAsString: packet);
        sum += getAreaOfPaperNeededForOnePacket(arrayOfAreas: arrayOfAreas);
    }
    return sum;
}

//Part 2
func getDimensions(dimensionsAsString: String) -> [Int] {
    var dimensions = dimensionsAsString.components(separatedBy: "x").map { Int($0)! };
    dimensions.sort();
    return dimensions;
}

func getVolume(dimensions: [Int]) -> Int {
    return dimensions[0] * dimensions[1] * dimensions[2];
}

func getSmallestPerimeter(dimensions: [Int]) -> Int {
    return 2 * dimensions[0] + 2 * dimensions[1];
}

func getTotalLengthOfRubanNeeded(packets: [String]) -> Int {
    var sum = 0;
    for packet in packets {
        let packetDimensions = getDimensions(dimensionsAsString: packet);
        sum += getVolume(dimensions: packetDimensions) + getSmallestPerimeter(dimensions: packetDimensions);
    }
    return sum;
}

print("Enter input file path:");
if let path = readLine() {
	
    let resultPart1 = getTotalAreaOfPaperNeeded(packets: packets);
    let resultPart2 = getTotalLengthOfRubanNeeded(packets: packets);

    print("Result part 1 : \(resultPart1)");
    print("Result part 2 : \(resultPart2)");
}
