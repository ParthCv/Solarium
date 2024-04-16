//Bit Mask values
enum SolariumCollisionBitMask: Int {
    case ground = 1, player = 2, interactable = 4
}

// Pussle Hint Text

var PuzzleHints = [
    "Puzzle_3_0" : " A -> ^ \n  -> C \n $ -> & \n \n ^ -> C \n & -> B \n ^ -> $ \n \n C ->  \n "
]

// old hint/*"Puzzle_3_0" : "With tank A full, here's how to equalize the reservoir: Fill tank B, then tank C with water only from B. Move the water from tank C back to tank A. Fill tank C again with the remaining water from tank B, then refill tank B from tank A. Again, fill tank C with water only from tank B, and then move it back to tank A. If you make a mistake and get stuck, just fill everything back into tank A and start over."*/
