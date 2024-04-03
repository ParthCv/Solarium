//
//  Puzzle2.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-29.
//

import SceneKit

class Puzzle2 : Puzzle {
    var tubePuzzleState = Array(repeating:false, count:4)
    var isDoorOpen = false
    var tank = SCNNode()
    var sprinkler = SCNNode()
    override func linkEntitiesToPuzzleLogic() {
        
        tank = trackedEntities[0]!.node
        let doorA = Door(node: trackedEntities[1]!.node, openState: false)
        let doorB = Door(node: trackedEntities[13]!.node, openState: false)
        sprinkler = trackedEntities[2]!.node
        
//        let ball = trackedEntities[3]!
//        let ped = trackedEntities[4]!
        
        let buttons = [ trackedEntities[3]!, trackedEntities[4]!, trackedEntities[5]!, trackedEntities[6]!]
        let waterTubes = [trackedEntities[7]!, trackedEntities[8]!, trackedEntities[9]!, trackedEntities[10]! ]
        for i in 0 ..< buttons.count {
            var sets = [ i: waterTubes[i] ]
            if (i != 0) { sets[i-1] = waterTubes[i-1] }
            if (i != buttons.count - 1) { sets[i+1] = waterTubes[i+1] }
            buttons[i].doInteractDelegate = tubePuzzleButtonDelegateMaker(sets: sets)
        }
        
        let buttonA = trackedEntities[11]!
        buttonA.doInteractDelegate = {
            if self.tubePuzzleState.allSatisfy({$0 == true}){
                doorA.toggleDoor()
                self.isDoorOpen = doorA.isOpen
                self.checkPuzzleWinCon()
                self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Door")
            }
        }
        
        let buttonB = trackedEntities[12]!
        buttonB.doInteractDelegate = {
            if self.tubePuzzleState.allSatisfy({$0 == true}){
                if (doorA.isOpen) { doorA.toggleDoor() }
                doorB.toggleDoor()
                self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Door")
            }
        }
        
//        let objectPosOnPlayerNode = self.sceneTemplate.playerCharacter.modelNode.childNode(withName: "holdingObjectPosition", recursively: true)!
//        ball.doInteractDelegate = ballPickUpDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, ball: ball)
//        ped.doInteractDelegate = pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped.node, toggleFunc: {
//            door.toggleDoor()
//            self.isDoorOpen = door.isOpen
//            self.checkPuzzleWinCon()
//        })
    }
    
    override func checkPuzzleWinCon() {
        if (!solved && isDoorOpen) {
            print("Puzzle 0 Complete")
            solved = true
            sceneTemplate.nextPuzzle()
            self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Door")
        }
    }
    
    func toggleSprinkler(){
        let toPos = sprinkler.worldPosition + SCNVector3(0, sprinkler.scale.y,0)
        let moveAction = SCNAction.move(to: toPos, duration: 1)
        sprinkler.runAction(moveAction)
        // Play water sound in the future
    }
    
    func unfillTank(){
        if(tubePuzzleState.allSatisfy({$0 == true})){
            let toPos = tank.worldPosition - SCNVector3(0, tank.boundingBox.max.y,0)
            let moveAction = SCNAction.move(to: toPos, duration: 1)
            tank.runAction(moveAction){
                self.toggleSprinkler()
            }
        }
    }
    
    func tubePuzzleButtonDelegateMaker(sets: [Int: Interactable?]) -> (() -> ()) {
        return {
            for set in sets {
                self.tubePuzzleState[set.key] = !self.tubePuzzleState[set.key]
                let tubePos = set.value!.node.worldPosition
                let toPos = self.tubePuzzleState[set.key] ? SCNVector3(x: tubePos.x, y: 30, z: tubePos.z): SCNVector3(x: tubePos.x, y: 60, z: tubePos.z)
                let moveAction = SCNAction.move(to: toPos, duration: 2)
                set.value?.node.runAction(moveAction){
                    self.unfillTank()
                }
                self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Button")
            }
        }
    }
    
//    func pedestalDelegateMaker(playerBallPosNode: SCNNode, baseNode: inout SCNNode, toggleFunc: @escaping () -> ()) -> (() -> ()){
//        let batRootNode = baseNode.childNode(withName: "BatteryRoot", recursively: true)!
//        let onToggleDo = toggleFunc
//        return {
//            // if the player isnt holdin smthg and the base node is the parent of the ball
//            if (!self.sceneTemplate.playerCharacter.isHoldingSmthg && !batRootNode.childNodes.isEmpty) {
//                // TODO: Replace with reparenting to objectPosOnPlayerNode and play pickup animation
//                let ballNode = batRootNode.childNodes[0]
//                let currentBallPos = ballNode.worldPosition
//                self.sceneTemplate.scene.rootNode.addChildNode(ballNode)
//                //Reset the position and scale back
//                ballNode.worldPosition = currentBallPos
//                
//                let toPos = playerBallPosNode.worldPosition
//                let moveAction = SCNAction.move(to: toPos, duration: 1)
//                onToggleDo()
//                ballNode.runAction(moveAction) {
//                    let newPos = playerBallPosNode.worldPosition
//                    playerBallPosNode.addChildNode(ballNode)
//                    ballNode.worldPosition = newPos
//                    self.sceneTemplate.playerCharacter.isHoldingSmthg = true
//                }
//                
//            } else if (self.sceneTemplate.playerCharacter.isHoldingSmthg && batRootNode.childNodes.isEmpty) {
//                //Reparent to the root node
//                let ballNode = playerBallPosNode.childNodes[0]
//                let currentBallPos = ballNode.worldPosition
//                self.sceneTemplate.scene.rootNode.addChildNode(ballNode)
//                //Reset the position and scale back
//                ballNode.worldPosition = currentBallPos
//                
//                let toPos = batRootNode.worldPosition
//                let moveAction = SCNAction.move(to: toPos, duration: 1)
//                self.sceneTemplate.playerCharacter.isHoldingSmthg = false
//                ballNode.runAction(moveAction) {
//                    let newPos = ballNode.worldPosition
//                    batRootNode.addChildNode(ballNode)
//                    ballNode.worldPosition = newPos
//                    onToggleDo()
//                }
//            }
//        }
//    }
    
    
}
