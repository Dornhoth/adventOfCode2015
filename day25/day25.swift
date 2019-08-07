//
//  File.swift
//  
//
//  Created by Dornhoth on 07.08.19.
//

import Foundation


func findNumberAtRowColumn(row: Int, column: Int) -> Int {
    // the diagonal number is the axis index if we follow the diagonal up to the first row
    let diagonalAxisIndex = row + column - 1
    
    // the k-th diagonal has k elements, so the n-th diagonal first element is n(n-1)/2 + 1 (there are "sum k from 1 to n - 1" elements before
    let diagonalFirstNumber = (diagonalAxisIndex * diagonalAxisIndex - diagonalAxisIndex) / 2 + 1

    var number = diagonalFirstNumber
    var k = diagonalAxisIndex
    var l = 1
    
    while k != row && l != column {
        number += 1
        k -= 1
        l += 1
    }
    return number
}

func calculateCode(row: Int, column: Int) -> Int {
    let number = findNumberAtRowColumn(row: row, column: column)
    let a = 252533
    let b = 33554393
    var result = 20151125
    for _ in 1..<number {
        result = (result * a ) % b
    }
    return result
}

var row = 0
var column = 0
print("Enter row:");
if let input = readLine() {
  row = Int(input)!
}
print("Enter column:");
if let input = readLine() {
    column = Int(input)!
}

print("Result part 1: \(calculateCode(row: row, column: column))")
