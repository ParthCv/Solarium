//
//  Puzzle1.swift
//  Solarium
//
//  Created by Richard Le on 2024-03-12.
//

import SceneKit

class Puzzle1 : Puzzle {
    
    // Function called when entities assigned
    override func linkEntitiesToPuzzleLogic(){
//        trackedEntities[0]!.doInteractDelegate = teleportDelegateMaker(target: trackedEntities[1])
//        trackedEntities[1]!.doInteractDelegate = teleportDelegateMaker(target: trackedEntities[0])
//        trackedEntities[2]!.doInteractDelegate = teleportDelegateMaker(target: trackedEntities[3])
//        trackedEntities[3]!.doInteractDelegate = teleportDelegateMaker(target: trackedEntities[2])
//        
//        trackedEntities[4]!.doInteractDelegate = stateButtonDelegateMaker(sets: [
//            0: trackedEntities[7],
//            1: trackedEntities[8]
//        ])
//        trackedEntities[5]!.doInteractDelegate = stateButtonDelegateMaker(sets: [
//            0: trackedEntities[7],
//            1: trackedEntities[8],
//            2: trackedEntities[9]
//        ])
//        trackedEntities[6]!.doInteractDelegate = stateButtonDelegateMaker(sets: [
//            1: trackedEntities[8],
//            2: trackedEntities[9]
//        ])
//        trackedEntities[11]!.doInteractDelegate = Door(node: trackedEntities[12]!.node, openState: nil).toggleDoor
    }
    
    func setUpPedestal(baseNode: SCNNode, ballNode: SCNNode) {
        let batteryNodePos = baseNode.childNode(withName: "BatteryRoot", recursively: true)!
        
        baseNode.addChildNode(ballNode)
        ballNode.worldPosition = batteryNodePos.worldPosition
        print("ball - ", ballNode.position, " battery - ", batteryNodePos.worldPosition)
//        let objectPosOnPlayerNode = self.sceneTemplate.playerCharacter.modelNode.childNode(withName: "holdingObjectPosition", recursively: true)!
//        let objectPosOnPedNode = self.sceneTemplate.scene.rootNode.childNode(withName: "BatteryRoot", recursively: true)!
    }
    
    
    func pedestalDelegateMaker(objectPosOnPlayerNode: SCNNode,objectPosOnPedNode: SCNNode) -> () -> (){
        return {
            // if the player isnt holdin smthg and the base node is the parent of the ball
            if (!self.sceneTemplate.playerCharacter.isHoldingSmthg && !objectPosOnPedNode.childNodes.isEmpty) {
                print("pick up")
                // TODO: Replace with reparenting to objectPosOnPlayerNode and play pickup animation
                var ballNode = objectPosOnPedNode.childNodes[0]
                let currentBallPos = ballNode.worldPosition
                //Reparent to the root node
                self.sceneTemplate.scene.rootNode.addChildNode(ballNode)
                
                //Reset the position and scale back
                ballNode.worldPosition = currentBallPos
                ballNode.scale = SCNVector3(1, 1, 1)
                
                let toPos = objectPosOnPlayerNode.worldPosition
                
                let moveAction = SCNAction.move(to: toPos, duration: 1)
                
                ballNode.runAction(moveAction) {
                    let newPos = ballNode.worldPosition
                    objectPosOnPlayerNode.addChildNode(ballNode)
                    ballNode.scale = SCNVector3(1, 1, 1)
                    ballNode.worldPosition = newPos
                    self.sceneTemplate.playerCharacter.isHoldingSmthg = true
                }
                
            } else if (self.sceneTemplate.playerCharacter.isHoldingSmthg && objectPosOnPedNode.childNodes.isEmpty) {
                //Reparent to the root node
                
                print("drop")
                var ballNode = objectPosOnPlayerNode.childNodes[0]
                let currentBallPos = ballNode.worldPosition
                self.sceneTemplate.scene.rootNode.addChildNode(ballNode)
                
                //Reset the position and scale back
                ballNode.worldPosition = currentBallPos
                ballNode.scale = SCNVector3(1, 1, 1)
                
                let toPos = objectPosOnPedNode.worldPosition
                
                let moveAction = SCNAction.move(to: toPos, duration: 1)
                
                ballNode.runAction(moveAction) {
                    let newPos = ballNode.worldPosition
                    objectPosOnPedNode.addChildNode(ballNode)
                    ballNode.scale = SCNVector3(0.5, 0.5, 0.5)
                    ballNode.worldPosition = newPos
                    self.sceneTemplate.playerCharacter.isHoldingSmthg = false
                }
            }
        }
    }
}


