//
//  Puzzle6.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-04-01.
//

import SceneKit
import SpriteKit

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
    
    //Hints
    var hints: [Interactable?]
    var hint1: Interactable?
    var hint2: Interactable?
    var hint3: Interactable?
    var hint4: Interactable?
    
    var platformPositions: [SCNVector3]?
    var currPlatformPosIndex: Int?
    
    var puzzleStateArray = Array(repeating: false, count: 5)
    
    override init (puzzleID: Int, trackedEntities: [Int: Interactable], sceneTemplate: SceneTemplate) {
        solutionPedestals = []
        solutionBallOrder = []
        platformPositions = []
        storePedestals = []
        hints = []
        super.init(puzzleID: puzzleID, trackedEntities: trackedEntities, sceneTemplate: sceneTemplate)
        setupFileOverlay()
    }
    
    // Function called when entities assigned
    override func linkEntitiesToPuzzleLogic(){
        let objectPosOnPlayerNode = self.sceneTemplate.playerCharacter.getObjectHoldNode()
        
        storePedestals = [trackedEntities[0], trackedEntities[1], trackedEntities[2], trackedEntities[3], trackedEntities[4]]
        
        solutionBallOrder = [trackedEntities[5], trackedEntities[6], trackedEntities[7], trackedEntities[8], trackedEntities[9]]
        
        solutionPedestals = [trackedEntities[10], trackedEntities[11], trackedEntities[12], trackedEntities[13], trackedEntities[14]]
        
        hints = [trackedEntities[15], trackedEntities[16], trackedEntities[17], trackedEntities[18]]
        
        for i in 0 ..< storePedestals.count {
            let ped = storePedestals[i]
            ped!.setInteractDelegate(function: pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped!.node))
        }
        
        for i in 0 ..< solutionPedestals.count {
            let ped = solutionPedestals[i]!
            ped.setInteractDelegate(function: pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped.node, nameOfBall: solutionBallOrder[i]!.node.name!, index: i))
        }
        
        for i in 0 ..< hints.count {
            let hint = hints[i]
            hint!.setInteractDelegate(function: hintDelegateMaker(fileNodeName: "hint\(i+1)", btnNodeName: "btnCls\(i+1)"))
        }
        
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){
        let condition = self.puzzleStateArray.allSatisfy({$0 == true})
        if( condition ) {
//            print("Puzzle Complete")
            self.sceneTemplate.nextPuzzle()
        }
    }
    
    func hintDelegateMaker(fileNodeName: String, btnNodeName: String) -> () -> () {
        return {
            let fileNode = self.sceneTemplate.gvc.gameView.overlaySKScene?.childNode(withName: fileNodeName)
            let closeBtn = self.sceneTemplate.gvc.gameView.overlaySKScene?.childNode(withName: btnNodeName)
            
            let fadeIn = SKAction.fadeIn(withDuration: 1)
            fileNode!.isHidden = false
            fileNode?.run(fadeIn) {
                closeBtn!.isHidden = false
            }
        }
    }
    

    // Delagate for just pick up and drop off the ball on the pedestal
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
    
    // Delgate maker for the pesdestal that check for the win condition for the puzzle when the correct ball is placed on it
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
//        print("comparing ", batteryRoot.childNodes[0].name!, " and ", correctBallName)
        return batteryRoot.childNodes[0].name! == correctBallName
    }
    
    // Set up the hint overlay
    func setupFileOverlay() {
        self.sceneTemplate.gvc.gameView.overlaySKScene!.addChild(createHintTexture(nodeName: "hint1", texturePath: "art.scnassets/hintRiddle6/hint1_riddle6.png"))
        self.sceneTemplate.gvc.gameView.overlaySKScene!.addChild(createHintTexture(nodeName: "hint2", texturePath: "art.scnassets/hintRiddle6/hint2_riddle6.png"))
        self.sceneTemplate.gvc.gameView.overlaySKScene!.addChild(createHintTexture(nodeName: "hint3", texturePath: "art.scnassets/hintRiddle6/hint3_riddle6.png"))
        self.sceneTemplate.gvc.gameView.overlaySKScene!.addChild(createHintTexture(nodeName: "hint4", texturePath: "art.scnassets/hintRiddle6/hint4_riddle6.png"))
        self.sceneTemplate.gvc.gameView.overlaySKScene!.addChild(createCloseBtns(btnName: "btnCls1", nodeToHide: "hint1"))
        self.sceneTemplate.gvc.gameView.overlaySKScene!.addChild(createCloseBtns(btnName: "btnCls2", nodeToHide: "hint2"))
        self.sceneTemplate.gvc.gameView.overlaySKScene!.addChild(createCloseBtns(btnName: "btnCls3", nodeToHide: "hint3"))
        self.sceneTemplate.gvc.gameView.overlaySKScene!.addChild(createCloseBtns(btnName: "btnCls4", nodeToHide: "hint4"))
    }
    
    // Add the hint as a texture
    func createHintTexture(nodeName: String, texturePath: String) -> (SKSpriteNode) {
        let backgroundImage = UIImage(named: texturePath)!
        let texture = SKTexture(image: backgroundImage)
        let bound = self.sceneTemplate.gvc.gameView.bounds
        let hint = SKSpriteNode(texture: texture)
        hint.alpha = 0.1
        hint.name = nodeName
        hint.position = CGPointMake(bound.width/2, bound.height/2)
        hint.size = CGSize(width: bound.width/2, height: bound.height/2)
        hint.isHidden = true
        
        return hint
    }
    
    // Create close btns for the hints
    func createCloseBtns(btnName: String, nodeToHide: String) -> (JKButtonNode) {
        let interactButton = JKButtonNode(title: "X", state: .normal)
        interactButton.action = closeBtnDelgateMaker(skNodeToHide: nodeToHide)
        interactButton.setBackgroundsForState(normal: "art.scnassets/TextButtonNormal.png",highlighted: "", disabled: "")
        interactButton.size = CGSizeMake(45,45)
        interactButton.canPlaySounds = false
        interactButton.setPropertiesForTitle(fontName: "Monofur", size: 20, color: UIColor.red)
        interactButton.position.x = 750
        interactButton.position.y = 300
        interactButton.isHidden = true
        interactButton.name = btnName
        
        return interactButton
    }
    
    //Delegate maker for the close btn
    func closeBtnDelgateMaker(skNodeToHide: String) -> ((JKButtonNode)->()) {
        return {(_ sender: JKButtonNode) in
            sender.isHidden = true
            let skNode = self.sceneTemplate.gvc.gameView.overlaySKScene!.childNode(withName: skNodeToHide)!
            skNode.isHidden = true
            
        }
    }
    
}


