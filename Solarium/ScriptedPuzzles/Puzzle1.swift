//
//  Puzzle1.swift
//  Solarium
//
//  Created by Richard Le on 2024-03-12.
//

import SceneKit

class Puzzle1 : Puzzle {
    
    var isFinalDoorOpen = false
    
    var introPlatform: SCNNode?
    
    
    // Function called when entities assigned
    override func linkEntitiesToPuzzleLogic(){
        let ball = trackedEntities[0]!
        let ped1 = trackedEntities[1]!
        let ped2 = trackedEntities[2]!
        let button = trackedEntities[3]!
        let door = GateDoor(node: trackedEntities[4]!.node, openState: nil)
        
        let finBtn = trackedEntities[5]!
        
        finBtn.setInteractDelegate {
            self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Energy")
            self.sceneTemplate.scene.rootNode.childNode(withName: "EndPlatform", recursively: true)!.runAction(SCNAction.moveBy(x: 0, y: 20, z: 0, duration: 4)) {
                self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Button")
                DispatchQueue.main.async{
                    
                    self.sceneTemplate.handleSceneChangeInteraction(targetScene: SceneEnum.SCN6, targetSpawnPoint: 0)
                    //gvc.switchScene(currScn: self.sceneTemplate.gvc.currentScene, nextScn: SceneEnum.SCN6)
                }
            }
        }
        
        let objectPosOnPlayerNode = self.sceneTemplate.playerCharacter.getObjectHoldNode()
        
        ped1.doInteractDelegate = pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped1.node)
        ped2.doInteractDelegate = pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped2.node)
        
        setUpPedestal(baseNode: ped1.node, ballNode: ball.node)
        
        button.doInteractDelegate = {
            if !ped2.node.childNode(withName: "BatteryRoot", recursively: true)!.childNodes.isEmpty {
                door.toggleDoor()
                self.isFinalDoorOpen = door.isOpen
                self.checkPuzzleWinCon()
            }
        }
        
        introPlatform = self.sceneTemplate.scene.rootNode.childNode(withName: "IntroPlatform", recursively: true)!
        let startAction = SCNAction.moveBy(x: 0, y: 12, z: 0, duration: 4)
        let player = self.sceneTemplate.playerCharacter.modelNode
        let bootUpAction = SCNAction.customAction(duration: 1.5) { (node, elapsedTime) -> () in }
        self.introPlatform!.runAction(startAction) {
            self.sceneTemplate.playerCharacter.playBootUpAnimation()
            player!.runAction(bootUpAction) {
                self.sceneTemplate.playerCharacter.playIdleAnimation()
            }
        }
        
        
    }
    
    override func checkPuzzleWinCon(){
        if (!solved && isFinalDoorOpen) {
            self.solved = true
            (sceneTemplate as! s01_TutorialScene).allPuzzlesDone() //TODO: EW GROSS change SceneTemplate from protocol to class
            self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Door")
        }
    }
    
    func setUpPedestal(baseNode: SCNNode, ballNode: SCNNode) {
        let batteryNodePos = baseNode.childNode(withName: "BatteryRoot", recursively: true)!
        
        batteryNodePos.addChildNode(ballNode)
        ballNode.worldPosition = batteryNodePos.worldPosition
    }
    
    
    func pedestalDelegateMaker(playerBallPosNode: SCNNode, baseNode: inout SCNNode) -> () -> (){
        let batRootNode = baseNode.childNode(withName: "BatteryRoot", recursively: true)!
        return {
            // if the player isnt holdin smthg and the base node is empty -> pick up the ball
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
                self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Orb")
                
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
                self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Orb")
            }
        }
    }
}


