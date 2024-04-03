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
        if (!solved && self.door.isOpen) {
            solved = true
            (sceneTemplate as! s01_TutorialScene).nextPuzzle() //TODO: EW GROSS change SceneTemplate from protocol to class
            self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Door")
        }
    }
}
