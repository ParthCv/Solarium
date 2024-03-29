//
//  Puzzle0.swift
//  Solarium
//
//  Created by Richard Le on 2024-03-12.
//

import SceneKit

class Puzzle0 : Puzzle {
    var door: Door!
    override func linkEntitiesToPuzzleLogic() {
        door = Door(node: self.trackedEntities[1]!.node, openState: nil)
        trackedEntities[0]!.doInteractDelegate = {
            self.door.toggleDoor()
            self.checkPuzzleWinCon()
        }
    }
    
    override func checkPuzzleWinCon() {
        if self.door.isOpen {
            print("Puzzle 0 Complete")
            solved = true
        }
    }
}
