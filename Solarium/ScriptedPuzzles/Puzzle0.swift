//
//  Puzzle0.swift
//  Solarium
//
//  Created by Richard Le on 2024-03-12.
//

import SceneKit

class Puzzle0 : Puzzle {
    
    
    var doorButton : Interactable?
    var door : Interactable?
    
    override init (puzzleID: Int, trackedEntities: [Int: Interactable]) {
        super.init(puzzleID: puzzleID, trackedEntities: trackedEntities)
        
        doorButton = nil
        door = nil
    }
    
    
    override func linkEntitiesToPuzzleLogic() {
        // Single button
        if trackedEntities[0] != nil {
            doorButton = trackedEntities[0]!
            
            doorButton!.node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            doorButton!.node.physicsBody!.categoryBitMask = SolariumCollisionBitMask.interactable.rawValue
            doorButton!.node.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue |
            SolariumCollisionBitMask.ground.rawValue | 1
        }
        
        if trackedEntities[1] != nil {
            door = trackedEntities[1]!
        }
        
        doorButton!.doInteractDelegate = doorButtonDelegate
    }
    
    override func checkPuzzleWinCon() {
        if door!.node.isHidden {
            print("Puzzle 0 Complete")
        }
    }
    
    // To be called on doorButton DoInteract
    func doorButtonDelegate() {
        door!.node.isHidden = true
        self.checkPuzzleWinCon()
    }
    

}
