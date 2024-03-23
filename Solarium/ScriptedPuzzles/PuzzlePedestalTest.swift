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
        
        // if ball noed parent is the pedestal and if the player isnt holding anything at the moment
        // nvm the sphere node ncan be a child
        // actually i cn
        if (!sceneTemplate.playerCharacter.isHoldingSmthg && ballNode!.node.parent!.name == baseNode!.node.name) {
            let currPor = self.ballNode!.node.worldPosition
            
            sceneTemplate.scene.rootNode.addChildNode(ballNode!.node)
            
            //ballNode
            
            let movepos = objectPosOnPlayerNode.worldPosition - objectPosOnPedNode.worldPosition
            //objectPosOnPlayerNode.worldPosition - objectPosOnPedNode.worldPosition
            
            //TODO: Fix the action and find where to  put ball on the player
            
            let moveActio = SCNAction.move(by: movepos, duration: 4)
            //self.sceneTemplate.scene.rootNode.addChildNode(self.ballNode!.node)
            
            
            
            ballNode!.node.runAction(moveActio) {
                objectPosOnPlayerNode.addChildNode(self.ballNode!.node)
            }
            
            sceneTemplate.playerCharacter.isHoldingSmthg = true
            
            
        } else if (sceneTemplate.playerCharacter.isHoldingSmthg && ballNode!.node.parent!.name == sceneTemplate.playerCharacter.nodeName) {
            //var movepos = sceneTemplate.scene.rootNode.childNode(withName: "Power_Sphere", recursively: true)!.worldPosition
            
            //movepos = sceneTemplate.playerCharacter.modelNode.position
            
            var movepos = objectPosOnPedNode.worldPosition
            
            //TODO: Fix the action and find where to  put ball on the player
            
            let moveActio = SCNAction.move(to: movepos, duration: 1)
            
            ballNode!.node.runAction(moveActio) {
                //self.sceneTemplate.playerCharacter.modelNode.addChildNode(self.ballNode!.node)
                objectPosOnPedNode.addChildNode(self.ballNode!.node)
            }
            
            sceneTemplate.playerCharacter.isHoldingSmthg = false
        }
        
        
//        if (!ballNode!.node.isHidden && sphereNode!.isHidden) {
//
//            ballNode!.node.isHidden = true
//            
//            sphereNode?.isHidden = false
//        } 
//        else if (ballNode!.node.isHidden && !sphereNode!.isHidden){
//
//            ballNode!.node.isHidden = false
//            
//            sphereNode?.isHidden = true
//        }
        
    }
    
}
