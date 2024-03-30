//
//  Puzzle4.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-28.
//

import SceneKit

class Puzzle4: Puzzle {
    
    // All the floors
    var floor1: Interactable?
    var floor2: Interactable?
    var floor3: Interactable?
    var floor4: Interactable?
    var floor5: Interactable?
    
    //Platform
    var platform: Interactable?
    var platformBtnUp: Interactable?
    
    //Puzzle Solutions
    /*
     balls - b1(blue),b2(yellow),b3(teal),b4(gree),b5(magenta)
     initial
        pF - b2
        p1 - nil
        p2 - b5
        p3 - b4
        p4 - b1
        p5 - b3
     sol
        pF - nil
        p1 - b1
        p2 - b2
        p3 - b3
        p4 - b4
        p5 - b5
     */
    
    //Pedestals
    var pedestalBtm: Interactable?
    var solutionPedestals: [Interactable?]
//    var pedestal1: Interactable?
//    var pedestal2: Interactable?
//    var pedestal3: Interactable?
//    var pedestal4: Interactable?
//    var pedestal5: Interactable?
    
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
        super.init(puzzleID: puzzleID, trackedEntities: trackedEntities, sceneTemplate: sceneTemplate)
        platformPositions = []
    }
    
    // Function called when entities assigned
    override func linkEntitiesToPuzzleLogic(){
        floor1 = trackedEntities[0]
        floor2 = trackedEntities[1]
        floor3 = trackedEntities[2]
        floor4 = trackedEntities[3]
        floor5 = trackedEntities[4]
        
        platformPositions!.append(floor1!.node.childNodes[1].worldPosition)
        platformPositions!.append(floor2!.node.childNodes[1].worldPosition)
        platformPositions!.append(floor3!.node.childNodes[1].worldPosition)
        platformPositions!.append(floor4!.node.childNodes[1].worldPosition)
        platformPositions!.append(floor5!.node.childNodes[1].worldPosition)
        
        platform = trackedEntities[5]
        platformBtnUp = trackedEntities[6]
        
        let objectPosOnPlayerNode = sceneTemplate.playerCharacter.modelNode.childNode(withName: "holdingObjectPosition", recursively: true)!
        
        solutionBallOrder = [trackedEntities[13], trackedEntities[14], trackedEntities[15], trackedEntities[16], trackedEntities[17]]
        //        ball1 = trackedEntities[13]
        //        ball2 = trackedEntities[14]
        //        ball3 = trackedEntities[15]
        //        ball4 = trackedEntities[16]
        //        ball5 = trackedEntities[17]
        
        pedestalBtm = trackedEntities[7]
        pedestalBtm!.setInteractDelegate(function: pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &pedestalBtm!.node))
        solutionPedestals = [trackedEntities[8], trackedEntities[9], trackedEntities[10], trackedEntities[11], trackedEntities[12]]
        //        pedestal1 = trackedEntities[8]
        //        //pedestal1!.setInteractDelegate(function: pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &pedestal1!.node))
        //        pedestal2 = trackedEntities[9]
        //        pedestal3 = trackedEntities[10]
        //        pedestal4 = trackedEntities[11]
        //        pedestal5 = trackedEntities[12]
        
        for i in 0 ..< solutionPedestals.count {
            let ped = solutionPedestals[i]!
            ped.setInteractDelegate(function: pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped.node, nameOfBall: solutionBallOrder[i]!.node.name!, index: i))
        }
       
        currPlatformPosIndex = 0
        platformBtnUp!.setInteractDelegate(function: movePlatformUpIntercatDelegate)
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){

    }
    
    func movePlatformUpIntercatDelegate() {
        currPlatformPosIndex = (currPlatformPosIndex! + 1) % platformPositions!.count
        
        let moveAction = SCNAction.move(to: platformPositions![currPlatformPosIndex!], duration: 5)
        
        platformBtnUp!.priority = .noPriority
        
        platform!.node.runAction(moveAction) {
            self.platformBtnUp!.priority = .mediumPriority
        }
        
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
    
    func pedestalDelegateMaker(playerBallPosNode: SCNNode, baseNode: inout SCNNode, nameOfBall: String, index: Int) -> () -> (){
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
                            let condition = self.puzzleStateArray.allSatisfy({$0 == true})
                            print(condition)
                        }
                    }
                }
            }
        }
    
    func checkIfBallIsInRightPlace(batteryRoot: SCNNode, correctBallName: String) -> Bool {
        return batteryRoot.childNodes[0].name == correctBallName
    }
    
}

