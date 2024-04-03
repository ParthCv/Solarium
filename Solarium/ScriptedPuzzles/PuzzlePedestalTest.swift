//
//  Puzzle_Pedestal_Test.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-14.
//

/**
 
 JUST A TEST CLASS NOT USED ANYMORE
 
 */

import SceneKit

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
        
        baseNode!.doInteractDelegate = self.pedestalInteractDelegate
        
        //ballNode!.setInteractDelegate(function: pedestalInteractDelegate)
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){
        if (ballNode!.node.isHidden) {
            print("Puzzle Complete")
            self.solved = true
        }
    }
    
    func pedestalInteractDelegate() {
        let objectPosOnPlayerNode = sceneTemplate.playerCharacter.modelNode.childNode(withName: "holdingObjectPosition", recursively: true)!
        
        let objectPosOnPedNode = sceneTemplate.scene.rootNode.childNode(withName: "BatteryRoot", recursively: true)!
        
        let currentBallPos = self.ballNode!.node.worldPosition

        // if the player isnt holdin smthg and the base node is the parent of the ball
        if (!sceneTemplate.playerCharacter.isHoldingSmthg && (ballNode!.node.parent!.name == baseNode!.node.name || ballNode!.node.parent!.name == objectPosOnPedNode.name)) {
            print("pick up")
            
            //Reparent to the root node
            sceneTemplate.scene.rootNode.addChildNode(self.ballNode!.node)
            
            //Reset the position and scale back
            ballNode!.node.worldPosition = currentBallPos
            ballNode!.node.scale = SCNVector3(1, 1, 1)
            
            let toPos = objectPosOnPlayerNode.worldPosition
            
            let moveAction = SCNAction.move(to: toPos, duration: 1)
            
            ballNode!.node.runAction(moveAction) {
                let newPos = self.ballNode!.node.worldPosition
                objectPosOnPlayerNode.addChildNode(self.ballNode!.node)
                self.ballNode!.node.scale = SCNVector3(1, 1, 1)
                self.ballNode!.node.worldPosition = newPos
                self.sceneTemplate.playerCharacter.isHoldingSmthg = true
            }
            
        } else if (sceneTemplate.playerCharacter.isHoldingSmthg && ballNode!.node.parent!.name == objectPosOnPlayerNode.name) {
            //Reparent to the root node
            
            print("drop")
            
            sceneTemplate.scene.rootNode.addChildNode(self.ballNode!.node)
            
            //Reset the position and scale back
            ballNode!.node.worldPosition = currentBallPos
            ballNode!.node.scale = SCNVector3(1, 1, 1)
            
            let toPos = objectPosOnPedNode.worldPosition
            
            let moveAction = SCNAction.move(to: toPos, duration: 1)
            
            ballNode!.node.runAction(moveAction) {
                let newPos = self.ballNode!.node.worldPosition
                objectPosOnPedNode.addChildNode(self.ballNode!.node)
                self.ballNode!.node.scale = SCNVector3(0.5, 0.5, 0.5)
                self.ballNode!.node.worldPosition = newPos
                self.sceneTemplate.playerCharacter.isHoldingSmthg = false
            }
        }
        
    }
    
}
