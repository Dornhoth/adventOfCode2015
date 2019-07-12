// Part 1

func getFloor(instructions: String) -> Int {
    var floor = 0;
    var characters = Array(instructions);
    for i in 0..<instructions.count {
        let instruction = characters[i];
        if(instruction == "(") {
            floor += 1;
        } else if(instruction == ")") {
            floor -= 1;
        }
    }
    return floor;
}

// Part 2
func getPositionBasement(instructions: String) -> Int {
    var floor = 0;
    var characters = Array(instructions);
    var index = 0;
    while floor >= 0 && index < characters.count {
        let instruction = characters[index];
        if(instruction == "(") {
            floor += 1;
        } else if(instruction == ")") {
            floor -= 1;
        }
        index += 1;
    }
    return index;
}
