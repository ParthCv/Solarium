//
//  Puzzle3.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-30.
//

import SceneKit
import SpriteKit

class Puzzle3: Puzzle {
    
    //Max amount for drains
    let bigDrainMax: Int = 60
    let medDrainMax: Int = 40
    let smlDrainMax: Int = 25
    
    var drainCurrPos = [60, 0, 0]
    
    //Drains
    var bigDrain: Interactable?
    var medDrain: Interactable?
    var smlDrain: Interactable?
    
    //Btns
    var btnAB: Interactable?
    var btnBA: Interactable?
    var btnBC: Interactable?
    var btnCB: Interactable?
    var btnCA: Interactable?
    var btnAC: Interactable?
    
    //Platform
    var platform: Interactable?
    var platformBtnUp: Interactable?
    
    //Hint
    var file: Interactable?
    var tankDoor: Door?
    var ped: Interactable?
    
    //Puzzle Solutions
    /*
     GOAL => get a -> 30, b -> 30 & c->0
     
     START
        a = 60
        b = 0
        c = 0
     
     SOL ORDER
        a->b
        b->c
        c->a
        b->c
        a->b
        b->c
        c->a
     
     if u fuk up refill a and the do it again
     */
    
    override init (puzzleID: Int, trackedEntities: [Int: Interactable], sceneTemplate: SceneTemplate) {
        super.init(puzzleID: puzzleID, trackedEntities: trackedEntities, sceneTemplate: sceneTemplate)
    }
    
    // Function called when entities assigned
    override func linkEntitiesToPuzzleLogic(){
        bigDrain = trackedEntities[0]
        medDrain = trackedEntities[1]
        smlDrain = trackedEntities[2]
        
        btnAB = trackedEntities[3]
        btnBA = trackedEntities[4]
        btnBC = trackedEntities[5]
        btnCB = trackedEntities[6]
        btnAC = trackedEntities[7]
        btnCA = trackedEntities[8]
        
        file = trackedEntities[9]
        file!.setInteractDelegate(function: fileDelegate)
        
        tankDoor = Door(node: trackedEntities[10]!.node, openState: false)
        let ball = trackedEntities[11]!
        ped = trackedEntities[12]!
        
        // Get the nodes that actually move
        let waterNodeABigdrain = bigDrain!.node
        let waterNodeBMeddrain = medDrain!.node
        let waterNodeCSmldrain = smlDrain!.node
        
        // Setup the overlay for the hint
        setupFileOverlay()
        
        //Set up delegates for all the buttons
        btnAB?.doInteractDelegate = AtoBDelegateMaker(nodeA: waterNodeABigdrain, nodeB: waterNodeBMeddrain, nodeAIndex: 0, nodeBIndex: 1, nodeBMax: medDrainMax)
        btnBA?.doInteractDelegate = AtoBDelegateMaker(nodeA: waterNodeBMeddrain, nodeB: waterNodeABigdrain, nodeAIndex: 1, nodeBIndex: 0, nodeBMax: bigDrainMax)
        btnBC?.doInteractDelegate = AtoBDelegateMaker(nodeA: waterNodeBMeddrain, nodeB: waterNodeCSmldrain, nodeAIndex: 1, nodeBIndex: 2, nodeBMax: smlDrainMax)
        btnCB?.doInteractDelegate = AtoBDelegateMaker(nodeA: waterNodeCSmldrain, nodeB: waterNodeBMeddrain, nodeAIndex: 2, nodeBIndex: 1, nodeBMax: medDrainMax)
        btnAC?.doInteractDelegate = AtoBDelegateMaker(nodeA: waterNodeABigdrain, nodeB: waterNodeCSmldrain, nodeAIndex: 0, nodeBIndex: 2, nodeBMax: smlDrainMax)
        btnCA?.doInteractDelegate = AtoBDelegateMaker(nodeA: waterNodeCSmldrain, nodeB: waterNodeABigdrain, nodeAIndex: 2, nodeBIndex: 0, nodeBMax: bigDrainMax)
        
        let objectPosOnPlayerNode = self.sceneTemplate.playerCharacter.getObjectHoldNode()
        ball.doInteractDelegate = ballPickUpDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, ball: ball)
        ped!.doInteractDelegate = pedestalDelegateMaker(playerBallPosNode: objectPosOnPlayerNode, baseNode: &ped!.node)
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){
        if ( !solved && !(ped!.node.childNode(withName: "BatteryRoot", recursively: true)!.childNodes.isEmpty)){
            solved = true
            sceneTemplate.nextPuzzle()
            self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Door")
        }
    }
    
    func checkTankDoor(){
        if(self.drainCurrPos[0] == 30 && self.drainCurrPos[1] == 30) {
            tankDoor!.toggleDoor()
        }
    }
    
    func AtoBDelegateMaker(nodeA: SCNNode, nodeB: SCNNode,  nodeAIndex: Int, nodeBIndex: Int, nodeBMax: Int) -> ( ()->()) {
        // the array for the indices of the drain position is made a unowned reference cuz there is a string reference cycle
        return { [unowned self] () in

            let nodeACurr = self.drainCurrPos[nodeAIndex]

            let nodeBCurr = self.drainCurrPos[nodeBIndex]
            
            // Calc the amount that needs to stay and move
            let amountToMove: Int = nodeACurr >= (nodeBMax - nodeBCurr) ? nodeBMax - nodeBCurr : nodeACurr
            let amountToStay: Int = nodeACurr - amountToMove
           
            // Set the new values
            self.drainCurrPos[nodeBIndex] = nodeBCurr + amountToMove
            self.drainCurrPos[nodeAIndex] = amountToStay

            // Get the position the node has to move to
            let nodeAMoveToPos = SCNVector3(nodeA.position.x, Float(self.drainCurrPos[nodeAIndex]), nodeA.position.z)
            let nodeBMoveToPos = SCNVector3(nodeB.position.x, Float(self.drainCurrPos[nodeBIndex]), nodeB.position.z)

            let nodeAAction = SCNAction.move(to: nodeAMoveToPos, duration: 1)
            let nodeBAction = SCNAction.move(to: nodeBMoveToPos, duration: 1)
            
            nodeA.runAction(nodeAAction)
            nodeB.runAction(nodeBAction)
            
            self.checkTankDoor()
            self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Button")
        }
    }
    
    func setupFileOverlay() {
        let backgroundImage = UIImage(named: "art.scnassets/hintPuzzle4/files.png")!.alpha(1)
        let texture = SKTexture(image: backgroundImage)
        let bound = self.sceneTemplate.gvc.gameView.bounds
        let fileImageNode = SKSpriteNode(texture: texture)
        fileImageNode.name = "fileImage"
        fileImageNode.position = CGPointMake(bound.width/2, bound.height/2)
        fileImageNode.size = bound.size
        fileImageNode.isHidden = true
        
        let hintText = PuzzleHints["Puzzle_3_0"]!
        let hintLabel = SKLabelNode()        
        hintLabel.text = hintText
        hintLabel.fontSize = 20
        hintLabel.fontColor = .white
        hintLabel.fontName = "Monofur"
        hintLabel.name = "Hint1"
        hintLabel.verticalAlignmentMode = .center
        hintLabel.horizontalAlignmentMode = .center
        hintLabel.position = CGPointMake(bound.width/2, bound.height/2)
        hintLabel.lineBreakMode = .byWordWrapping
        hintLabel.preferredMaxLayoutWidth = 500
        hintLabel.numberOfLines = 0
        hintLabel.isHidden = true
        
        let interactButton = JKButtonNode(title: "X", state: .normal)
        interactButton.action = hideHintCallBack
        interactButton.setBackgroundsForState(normal: "art.scnassets/UI/TextButtonNormal.png",highlighted: "", disabled: "")
        interactButton.size = CGSizeMake(45,45)
        interactButton.canPlaySounds = false
        interactButton.setPropertiesForTitle(fontName: "Monofur", size: 20, color: UIColor.red)
        interactButton.position.x = 750
        interactButton.position.y = 300
        interactButton.isHidden = true
        interactButton.name = "CloseBtn"
        
        self.sceneTemplate.gvc.gameView.overlaySKScene?.addChild(fileImageNode)
        self.sceneTemplate.gvc.gameView.overlaySKScene?.addChild(hintLabel)
        self.sceneTemplate.gvc.gameView.overlaySKScene?.addChild(interactButton)
    }
    
    func hideHintCallBack(_ sender: JKButtonNode) {
        sender.isHidden = true
        let fileNode = self.sceneTemplate.gvc.gameView.overlaySKScene?.childNode(withName: "fileImage")
        let textNode = self.sceneTemplate.gvc.gameView.overlaySKScene?.childNode(withName: "Hint1")
        fileNode!.isHidden = true
        textNode!.isHidden = true
    }
    
    func fileDelegate() {
        let fileNode = self.sceneTemplate.gvc.gameView.overlaySKScene?.childNode(withName: "fileImage")
        let textNode = self.sceneTemplate.gvc.gameView.overlaySKScene?.childNode(withName: "Hint1")
        let closeBtn = self.sceneTemplate.gvc.gameView.overlaySKScene?.childNode(withName: "CloseBtn")
        
        let fadeIn = SKAction.fadeAlpha(to: 0.70, duration: 1)
        fileNode!.isHidden = false
        fileNode?.run(fadeIn) {
            textNode!.isHidden = false
            closeBtn!.isHidden = false
        }
    }
    
    func ballPickUpDelegateMaker(playerBallPosNode: SCNNode, ball: Interactable) -> (() -> ()) {
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
                self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Orb")
            }
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
                    self.checkPuzzleWinCon()
                }
                self.sceneTemplate.gvc.audioManager?.playInteractSound(interactableName: "Orb")
            }
        }
    }
}


