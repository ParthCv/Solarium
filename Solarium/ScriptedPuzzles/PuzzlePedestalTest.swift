//
//  Puzzle_Pedestal_Test.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-14.
//

import SceneKit

//TODO: rename later
enum PickUpType {
    case RedPickable, BluePickable
}

class PuzzlePedestalTest: Puzzle {
    var baseNode: Interactable?
    var ballNode: Interactable?
    var pedestalType: PickUpType = PickUpType.BluePickable
    
    override init (puzzleID: Int, trackedEntities: [Int: Interactable], sceneTemplate: SceneTemplate) {
        super.init(puzzleID: puzzleID, trackedEntities: trackedEntities, sceneTemplate: sceneTemplate)
        ballNode = nil
        baseNode = nil
    }
    
    // Function called when entities assigned
    override func linkEntitiesToPuzzleLogic(){
        if trackedEntities[0] != nil {
            baseNode = trackedEntities[0]
        }
        if trackedEntities[1] != nil {
            ballNode = trackedEntities[1]
        }
        
        ballNode!.doInteractDelegate = pedestalInteractDelegate
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){
        if (ballNode!.node.isHidden) {
            print("Puzzle Complete")
            self.solved = true
        }
    }
    
    func pedestalInteractDelegate() {
        let sphereNode =  sceneTemplate.playerCharacter.modelNode.childNode(withName: "Power_Sphere", recursively: true)
        if (!ballNode!.node.isHidden && sphereNode!.isHidden) {
            print("Interacting")
            ballNode!.node.isHidden = true
            
            sphereNode?.isHidden = false
        } else if (ballNode!.node.isHidden && !sphereNode!.isHidden){
            print("Interacting")
            ballNode!.node.isHidden = false
            
            sphereNode?.isHidden = true
        }
        
    }
    
}
