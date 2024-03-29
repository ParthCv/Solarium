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
        let ball = trackedEntities[0]!
        let ped1 = trackedEntities[1]!
        let ped2 = trackedEntities[2]!
        let button = trackedEntities[3]!
        let door = Door(node: trackedEntities[4]!.node, openState: nil)
        
        var objectPosOnPlayerNode = self.sceneTemplate.playerCharacter.modelNode.childNode(withName: "holdingObjectPosition", recursively: true)!
        
        ped1.doInteractDelegate = pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped1.node)
        ped2.doInteractDelegate = pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped2.node)
        
        setUpPedestal(baseNode: ped1.node, ballNode: ball.node)
        
        button.doInteractDelegate = {
            if !ped2.node.childNode(withName: "BatteryRoot", recursively: true)!.childNodes.isEmpty {
                door.toggleDoor()
                self.checkPuzzleWinCon()
            }
        }
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
    
    override func checkPuzzleWinCon(){
        
    }
    
    func setUpPedestal(baseNode: SCNNode, ballNode: SCNNode) {
        let batteryNodePos = baseNode.childNode(withName: "BatteryRoot", recursively: true)!
        
        batteryNodePos.addChildNode(ballNode)
        ballNode.worldPosition = batteryNodePos.worldPosition
        print("ball - ", ballNode.position, " battery - ", batteryNodePos.worldPosition)
//        let objectPosOnPedNode = self.sceneTemplate.scene.rootNode.childNode(withName: "BatteryRoot", recursively: true)!
    }
    
    
    func pedestalDelegateMaker(playerBallPosNode: SCNNode, baseNode: inout SCNNode) -> () -> (){
        let batRootNode = baseNode.childNode(withName: "BatteryRoot", recursively: true)!
        return {
            // if the player isnt holdin smthg and the base node is the parent of the ball
            if (!self.sceneTemplate.playerCharacter.isHoldingSmthg && !batRootNode.childNodes.isEmpty) {
                // TODO: Replace with reparenting to objectPosOnPlayerNode and play pickup animation
                let ballNode = batRootNode.childNodes[0]
                let currentBallPos = ballNode.worldPosition
                self.sceneTemplate.scene.rootNode.addChildNode(ballNode)
                //Reset the position and scale back
                ballNode.worldPosition = currentBallPos
                
                let toPos = playerBallPosNode.worldPosition
                let moveAction = SCNAction.move(to: toPos, duration: 1)
                ballNode.runAction(moveAction) {
                    let newPos = playerBallPosNode.worldPosition
                    playerBallPosNode.addChildNode(ballNode)
                    ballNode.worldPosition = newPos
                    self.sceneTemplate.playerCharacter.isHoldingSmthg = true
                }
                
            } else if (self.sceneTemplate.playerCharacter.isHoldingSmthg && batRootNode.childNodes.isEmpty) {
                //Reparent to the root node
                let ballNode = playerBallPosNode.childNodes[0]
                let currentBallPos = ballNode.worldPosition
                self.sceneTemplate.scene.rootNode.addChildNode(ballNode)
                //Reset the position and scale back
                ballNode.worldPosition = currentBallPos
                
                let toPos = batRootNode.worldPosition
                let moveAction = SCNAction.move(to: toPos, duration: 1)
                self.sceneTemplate.playerCharacter.isHoldingSmthg = false
                ballNode.runAction(moveAction) {
                    let newPos = ballNode.worldPosition
                    batRootNode.addChildNode(ballNode)
                    ballNode.worldPosition = newPos
                }
            }
        }
    }
}


