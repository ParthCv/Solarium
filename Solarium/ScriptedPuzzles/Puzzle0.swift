//
//  Puzzle0.swift
//  Solarium
//
//  Created by Richard Le on 2024-03-12.
//

/**
 
 JUST A TEST CLASS NOT USED ANYMORE
 
 */

import SceneKit

class Puzzle0 : Puzzle {
    var door: Door!
    override func linkEntitiesToPuzzleLogic() {
        door = GateDoor(node: self.trackedEntities[1]!.node, openState: nil)
        trackedEntities[0]!.doInteractDelegate = {
            self.door.toggleDoor()
            self.checkPuzzleWinCon()
        }
    }
    
    override func checkPuzzleWinCon() {
        if (!solved && self.door.isOpen) {
            solved = true
            (sceneTemplate as! s01_TutorialScene).nextPuzzle()
            self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Door")
        }
    }
}
