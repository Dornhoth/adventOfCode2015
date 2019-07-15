//
//  day4.swift
//  
//
//  Created by Dornhoth on 15.07.19.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

func MD5(string: String) -> Data {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: length)
    
    _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
        messageData.withUnsafeBytes { messageBytes -> UInt8 in
            if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                let messageLength = CC_LONG(messageData.count)
                CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
            }
            return 0
        }
    }
    return digestData
}

func MD5Hex(string : String) -> String {
    let md5Data = MD5(string: string)
    let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
    return md5Hex
}

func firstHashWith( input: String, numberOfZeros : Int, start: Int) -> Int {
    var result = start
    var hash = MD5Hex(string: input + "\(result)")
    var expected = ""
    for _ in 0..<numberOfZeros {
        expected += "0"
    }
    
    while hash.prefix(numberOfZeros) != expected {
        result += 1
        hash = MD5Hex(string: input + "\(result)")
    }
    
    return result;
}

print("Enter input:")
if let input = readLine() {
    let resultPart1 = firstHashWith(input: input, numberOfZeros: 5, start: 1)
    let resultPart2 = firstHashWith(input: input, numberOfZeros: 6, start: resultPart1)
    
    print("Result part 1 : \(resultPart1)")
    print("Result part 2 : \(resultPart2)")
}


