//
//  Puzzle6.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-04-01.
//

import SceneKit

class Puzzle6: Puzzle {
    //Puzzle Solutions
    /*
     balls - b1(yellow),b2(red),b3(purple),b4(blue),b5(orange)
     initial
        all balls in base nodes
     sol
        b1 - 1
        b2 - 2
        b3 - 3
        b4 - 4
        b5 - 5
     1,2,3,4,5 are the pedestal numbers
     */
    
    //Pedestals
    var storePedestals: [Interactable?]
    var solutionPedestals: [Interactable?]
    
    //Balls
    var ball1: Interactable?
    var ball2: Interactable?
    var ball3: Interactable?
    var ball4: Interactable?
    var ball5: Interactable?
    var solutionBallOrder: [Interactable?]
    
    var platformPositions: [SCNVector3]?
    var currPlatformPosIndex: Int?
    
    var puzzleStateArray = Array(repeating: false, count: 5)
    
    override init (puzzleID: Int, trackedEntities: [Int: Interactable], sceneTemplate: SceneTemplate) {
        solutionPedestals = []
        solutionBallOrder = []
        platformPositions = []
        storePedestals = []
        super.init(puzzleID: puzzleID, trackedEntities: trackedEntities, sceneTemplate: sceneTemplate)
    }
    
    // Function called when entities assigned
    override func linkEntitiesToPuzzleLogic(){
        let objectPosOnPlayerNode = sceneTemplate.playerCharacter.modelNode.childNode(withName: "holdingObjectPosition", recursively: true)!
        
        storePedestals = [trackedEntities[0], trackedEntities[1], trackedEntities[2], trackedEntities[3], trackedEntities[4]]
        
        solutionBallOrder = [trackedEntities[5], trackedEntities[6], trackedEntities[7], trackedEntities[8], trackedEntities[9]]
        
        solutionPedestals = [trackedEntities[10], trackedEntities[11], trackedEntities[12], trackedEntities[13], trackedEntities[14]]
        
        for i in 0 ..< storePedestals.count {
            let ped = storePedestals[i]
            ped!.setInteractDelegate(function: pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped!.node))
        }
        
        for i in 0 ..< solutionPedestals.count {
            let ped = solutionPedestals[i]!
            ped.setInteractDelegate(function: pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped.node, nameOfBall: solutionBallOrder[i]!.node.name!, index: i))
        }
        
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){
        let condition = self.puzzleStateArray.allSatisfy({$0 == true})
        if( condition ) {print("Puzzle Complete")}
    }
    

    // 1-off pedestal that is not part of the puzzle (Closest pedestal to spawn for testing)
    func pedestalDelegateMaker(playerBallPosNode: SCNNode, baseNode: inout SCNNode) -> () -> () {
        
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
    
    func pedestalDelegateMaker(playerBallPosNode: SCNNode, baseNode: inout SCNNode, nameOfBall: String, index: Int) -> () -> () {
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
                    self.puzzleStateArray[index] = false
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
                    if self.checkIfBallIsInRightPlace(batteryRoot: batRootNode, correctBallName: nameOfBall) {
                        self.puzzleStateArray[index] = true
                        //check puzzlestate
                        self.checkPuzzleWinCon()
                    }
                }
            }
        }
    }
    
    func checkIfBallIsInRightPlace(batteryRoot: SCNNode, correctBallName: String) -> Bool {
        print("comparing ", batteryRoot.childNodes[0].name!, " and ", correctBallName)
        return batteryRoot.childNodes[0].name! == correctBallName
    }
    
}


