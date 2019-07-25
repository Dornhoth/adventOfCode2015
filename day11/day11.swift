//
//  day11.swift
//  
//
//  Created by Dornhoth on 25.07.19.
//

import Foundation

func incrementPassword(password: [Character], alphabet: [Character]) -> [Character] {
    let indexOfChar = alphabet.firstIndex(of: password[password.count - 1])!

    if indexOfChar < (alphabet.count - 1) {
        var newPassword = password
        newPassword[newPassword.count - 1] = alphabet[indexOfChar + 1]
        return newPassword
    }

    var incrementedBeginning = incrementPassword(password: Array(password[0..<password.count-1]), alphabet: alphabet)
    incrementedBeginning.append(alphabet[0])
    return incrementedBeginning
}

func containsThreeConsecutiveLetters(password: [Character], alphabet: [Character]) -> Bool {
    var contains = false;
    var i = 0;

    while !contains && i < password.count - 2 {
        let indexOfChar = alphabet.firstIndex(of: password[i])!
        if indexOfChar < 24 {
            contains = password[i + 1] == alphabet[indexOfChar + 1]
                && password[i + 2] == alphabet[indexOfChar + 2]
        }
        i += 1
    }
    return contains
}

func doesntContainForbiddenChar(password: String) -> Bool {
    return !password.contains("i")
        && !password.contains("o")
        && !password.contains("l")
}

func hasTwoEqualConsecutivesCharTwice(password: String) -> Bool {
    return password.range(of: #"([a-z])\1"#,
                     options: .regularExpression) != nil
}

func hasAtLeastTwoConsecutiveDuplicates(password: String) -> Bool {
    let regex = try! NSRegularExpression(pattern: #"([a-z])\1"#, options: NSRegularExpression.Options.caseInsensitive)
    let results = regex.matches(in: password,
                                range: NSMakeRange(0, password.count))
    
    return results.count > 1
}

func isPasswordValid(password: [Character], alphabet: [Character]) -> Bool {
    let passwordAsString = password.map { String($0) }.joined(separator: "")
    return containsThreeConsecutiveLetters(password: password, alphabet: alphabet)
        && doesntContainForbiddenChar(password: passwordAsString)
        && hasAtLeastTwoConsecutiveDuplicates(password: passwordAsString)
}

print("Enter input:");
if let input = readLine() {
    let aScalars = "a".unicodeScalars
    let aCode = aScalars[aScalars.startIndex].value
    
    let alphabet: [Character] = (0..<26).map {
        i in Character(UnicodeScalar(aCode + i)!)
    }

    var passwordAsArray = Array(input)
    passwordAsArray = incrementPassword(password: passwordAsArray, alphabet: alphabet)
    while !isPasswordValid(password: passwordAsArray, alphabet: alphabet) {
        passwordAsArray = incrementPassword(password: passwordAsArray, alphabet: alphabet)
    }
    print("Result part 1: \(passwordAsArray.map { String($0) }.joined(separator: ""))")
    
    passwordAsArray = incrementPassword(password: passwordAsArray, alphabet: alphabet)
    while !isPasswordValid(password: passwordAsArray, alphabet: alphabet) {
        passwordAsArray = incrementPassword(password: passwordAsArray, alphabet: alphabet)
    }
    print("Result part 2: \(passwordAsArray.map { String($0) }.joined(separator: ""))")
}
