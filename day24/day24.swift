//
//  File.swift
//  
//
//  Created by Dornhoth on 06.08.19.
//

import Foundation

func getGroupQuantumEntanglement(group: [Int]) -> Int {
    return group.reduce(1, { x, y in
        x * y
    })
}

func createPackets(input: String) -> [Int] {
    let lines = input.components(separatedBy: "\n")
    var packets = [Int]()
    
    for line in lines {
        packets.append(Int(String(line))!)
    }
    packets.sort { $0 > $1 }
    return packets
}

func getSum(packets: [Int]) -> Int {
    return packets.reduce(0, { x, y in
        x + y
    })
}

func findElementsAddingUpToSumInRestPackets(packets: [Int], sum: Int, elements: [Int]) -> [Int] {
    var copy = packets
    let first = packets[0]
    copy.remove(at: 0)

    if sum < 0 {
        return [Int]()
    }
    if first == sum {
        return elements
    }
    if copy.count > 0 {
        var newElementsCopy = elements
        newElementsCopy.append(first)
        var newElements = findElementsAddingUpToSumInRestPackets(packets: copy, sum: (sum - first), elements: newElementsCopy)
        if newElements.count > 0 {
            return newElements
        }
        newElements = findElementsAddingUpToSumInRestPackets(packets: copy, sum: sum, elements: elements)
        return newElements
    }
    return [Int]()
}

func findIElementsAddingUpToSum(i: Int, sum: Int, packets: [Int]) -> [[Int]] {
    if i == 1 {
        for index in 0..<packets.count {
            if packets[index] == sum {
                return [[sum]]
            }
        }
        return []
    }
    var results = [[Int]]()
    for (index, element) in packets.enumerated() {
        if element < sum {
            var packetsCopy = packets
            packetsCopy = [Int]()
            for j in (index+1)..<packets.count {
                packetsCopy.append(packets[j])
            }
            let findIMinus1Elements = findIElementsAddingUpToSum(i: (i-1), sum: (sum - element), packets: packetsCopy)
            if findIMinus1Elements.count > 0 {
                for cases in findIMinus1Elements {
                    var copy = cases
                    copy.append(element)
                    results.append(copy)
                }
            }
        }
    }
    return results
}

func getMinimumQuantumEntanglement(packets: [Int]) -> Int {
    var sizeOfGroup1 = 0
    let sum = getSum(packets: packets)/3
    var elements = [[Int]]()

    // we start looking for a group 1 with 1 element, then 2, ..., until we find at least one
    while elements.count == 0 && sizeOfGroup1 < packets.count {
        sizeOfGroup1 += 1
        let elementsFound = findIElementsAddingUpToSum(i: sizeOfGroup1, sum: sum, packets: packets)
        
        // we need to check that we can split the other elements into two groups of equal sum
        // it is enough to check if we can find elements whose sum is *sum*, it means the rest has to sum up to *sum* as well
        for cases in elementsFound {
            var packetsLeft = [Int]()
            for packet in packets {
                if !cases.contains(packet) {
                    packetsLeft.append(packet)
                }
            }
            if findElementsAddingUpToSumInRestPackets(packets: packetsLeft, sum: sum, elements: [Int]()).count > 0 {
                elements.append(cases)
            }
        }
    }
    let quantumEntanglement = elements.map { getGroupQuantumEntanglement(group: $0) }
    return quantumEntanglement.min()!
}

func getMinimumQuantumEntanglementWith4Groups(packets: [Int]) -> Int {
    var sizeOfGroup1 = 0
    let sum = getSum(packets: packets)/4

    var elements = [[Int]]()
    while elements.count == 0 && sizeOfGroup1 < packets.count {
        sizeOfGroup1 += 1
        let elementsFound = findIElementsAddingUpToSum(i: sizeOfGroup1, sum: sum, packets: packets)
        
        // we need to check that we can split the other elements into three groups of equal sum
        // it is enough to check if we can find elements whose sum is *sum*,
        // and then again in the elements left if we can find elements whose sum is *sum*
        for cases in elementsFound {
            var packetsLeft = [Int]()
            for packet in packets {
                if !cases.contains(packet) {
                    packetsLeft.append(packet)
                }
            }
            let elementsAddingUp = findElementsAddingUpToSumInRestPackets(packets: packetsLeft, sum: sum, elements: [Int]());
            if elementsAddingUp.count > 0 {
                var packetsLeft2 = [Int]()
                for packet in packets {
                    if !cases.contains(packet) && !elementsAddingUp.contains(packet) {
                        packetsLeft2.append(packet)
                    }
                }
                let elementsAddingUp2 = findElementsAddingUpToSumInRestPackets(packets: packetsLeft2, sum: sum, elements: [Int]());
                if elementsAddingUp2.count > 0 {
                    elements.append(cases)
                }
            }
        }
    }
    let quantumEntanglement = elements.map { getGroupQuantumEntanglement(group: $0) }
    return quantumEntanglement.min()!
}

print("Enter input file path:");
if let path = readLine() {
    let contents = try String(contentsOfFile: path, encoding: .utf8)
    let packets = createPackets(input: contents)
    print("Result part 1: \(getMinimumQuantumEntanglement(packets: packets))")
    print("Result part 2: \(getMinimumQuantumEntanglementWith4Groups(packets: packets))")
}
