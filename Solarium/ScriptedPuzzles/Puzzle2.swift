//
//  Puzzle2.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-29.
//

import SceneKit

class Puzzle2 : Puzzle {
    var tubePuzzleState = Array(repeating:false, count:3)
    var isDoorOpen = false
    var tank = SCNNode()
    var sprinkler = SCNNode()
    override func linkEntitiesToPuzzleLogic() {
        let buttons = [ trackedEntities[0]!, trackedEntities[1]!, trackedEntities[2]! ]
        let waterTubes = [trackedEntities[3]!,  trackedEntities[4]!,  trackedEntities[5]! ]
        tank = trackedEntities[6]!.node
        let ball = trackedEntities[7]!
        let ped = trackedEntities[8]!
        let door = Door(node: trackedEntities[9]!.node, openState: false)
        sprinkler = trackedEntities[10]!.node
        
        for i in 0 ..< buttons.count {
            buttons[i].doInteractDelegate = tubePuzzleButtonDelegateMaker(sets: [
                i: waterTubes[i]
            ])
        }
        
        let objectPosOnPlayerNode = self.sceneTemplate.playerCharacter.modelNode.childNode(withName: "holdingObjectPosition", recursively: true)!
        ball.doInteractDelegate = ballPickUpDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, ball: ball)
        ped.doInteractDelegate = pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped.node, toggleFunc: {
            door.toggleDoor()
            self.isDoorOpen = door.isOpen
            self.checkPuzzleWinCon()
        })
    }
    
    override func checkPuzzleWinCon() {
        if (!solved && isDoorOpen) {
            print("Puzzle 0 Complete")
            solved = true
            sceneTemplate.nextPuzzle()
        }
    }
    
    func toggleSprinkler(){
        let toPos = sprinkler.worldPosition + SCNVector3(0, sprinkler.scale.y,0)
        let moveAction = SCNAction.move(to: toPos, duration: 1)
        sprinkler.runAction(moveAction)
    }
    
    func unfillTank(){
        if(tubePuzzleState[0] && tubePuzzleState[1] && tubePuzzleState[2]){
            let toPos = tank.worldPosition - SCNVector3(0, tank.scale.y,0)
            let moveAction = SCNAction.move(to: toPos, duration: 1)
            tank.runAction(moveAction){
                self.toggleSprinkler()
            }
        }
    }
    
    func tubePuzzleButtonDelegateMaker(sets: [Int: Interactable?]) -> () -> () {
        return {
            for set in sets {
                self.tubePuzzleState[set.key] = !self.tubePuzzleState[set.key]
                let tubePos = set.value!.node.worldPosition
                let toPos = self.tubePuzzleState[set.key] ? SCNVector3(x: tubePos.x, y: 20, z: tubePos.z): SCNVector3(x: tubePos.x, y: -20, z: tubePos.z)
                let moveAction = SCNAction.move(to: toPos, duration: 2)
                set.value?.node.runAction(moveAction){
                    self.unfillTank()
                }
            }
        }
    }
    
    func pedestalDelegateMaker(playerBallPosNode: SCNNode, baseNode: inout SCNNode, toggleFunc: @escaping () -> ()) -> () -> (){
        let batRootNode = baseNode.childNode(withName: "BatteryRoot", recursively: true)!
        let onToggleDo = toggleFunc
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
                onToggleDo()
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
                    onToggleDo()
                }
            }
        }
    }
    
    func ballPickUpDelegateMaker(playerBallPosNode: SCNNode, ball: Interactable) -> () -> () {
        // if the player isnt holdin smthg and the base node is the parent of the ball
        return{
            if (!self.sceneTemplate.playerCharacter.isHoldingSmthg) {
                let ballNode = ball.node
                ball.node = SCNNode()
                ball.priority = TriggerPriority.noPriority
                let toPos = playerBallPosNode.worldPosition
                let moveAction = SCNAction.move(to: toPos, duration: 1)
                ballNode.runAction(moveAction) {
                    let newPos = playerBallPosNode.worldPosition
                    playerBallPosNode.addChildNode(ballNode)
                    ballNode.worldPosition = newPos
                    self.sceneTemplate.playerCharacter.isHoldingSmthg = true
                }
            }
        }
    }
}
