//
//  day10.swift
//  
//
//  Created by Dornhoth on 24.07.19.
//

import Foundation


func createNextArray(array: [Int]) -> [Int] {
    var newArray = [Int]()
    
    var i = 0
    while i < array.count {
        var j = i + 1
        let next = array[i]
        var amountOfNext = 1
        while j < array.count && array[j] == next {
            amountOfNext += 1
            j += 1
        }
        newArray.append(amountOfNext)
        newArray.append(next)
        i = j
    }
    return newArray
}

print("Enter input:");
if let input = readLine() {
    var nextArray = Array(input).map { Int(String($0))! }
    for _ in 0...49 { //39 for part 1
        nextArray = createNextArray(array: nextArray)
    }
    print(nextArray.count )
}
