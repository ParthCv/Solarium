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
    var bigDrainMax: Int = 1200
    var medDrainMax: Int = 800
    var smlDrainMax: Int = 500
    
    //Cur Position indices
    var bigDrainCurrPos: Int = 1200
    var medDrainCurrPos: Int = 0
    var smlDrainCurrPos: Int = 0
    
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
    
    //Puzzle Solutions
    /*
     GOAL => get a -> 600, b -> 600 & c->0
     
     START
        a = 1200
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
        
        let waterNodeBigdrain = bigDrain!.node.childNode(withName: "cylinder", recursively: true)!
        let waterNodeMeddrain = medDrain!.node.childNode(withName: "cylinder", recursively: true)!
        let waterNodeSmldrain = smlDrain!.node.childNode(withName: "cylinder", recursively: true)!
        
        setupFileOverlay()
        
        btnAB!.setInteractDelegate(function: {
            //A->B
            let nodeA = waterNodeBigdrain
            let nodeACurr = self.bigDrainCurrPos
            
            let nodeB = waterNodeMeddrain
            let nodeBMax = self.medDrainMax
            let nodeBCurr = self.medDrainCurrPos
            
            let amountToMove: Int = nodeACurr >= (nodeBMax - nodeBCurr) ? nodeBMax - nodeBCurr : nodeACurr
            let amountToStay: Int = nodeACurr - amountToMove
            print("Move Amount in \(nodeB.parent!.name!) - \(amountToMove) Amount stay in \(nodeA.parent!.name!) -\(amountToStay)")
            // Set the new values
            self.medDrainCurrPos = self.medDrainCurrPos + amountToMove
            self.bigDrainCurrPos = amountToStay
            
            // get new pos child
            let newNodeAPos: String = String(self.bigDrainCurrPos)
            let newNodeBPos: String = String(self.medDrainCurrPos)
            //print(nodeA.parent!.name!," - ",newNodeAPos,nodeB.parent!.name!, " - ", newNodeBPos)
            let nodeInA = nodeA.parent!.childNode(withName: newNodeAPos, recursively: true)!
            let nodeInB = nodeB.parent!.childNode(withName: newNodeBPos, recursively: true)!

            let nodeAAction = SCNAction.move(to: nodeInA.position, duration: 1)
            let nodeBAction = SCNAction.move(to: nodeInB.position, duration: 1)
            nodeA.runAction(nodeAAction)
            nodeB.runAction(nodeBAction)
            self.checkPuzzleWinCon()
        })
        
        btnBA!.setInteractDelegate(function: {
            //B->A
            let nodeA = waterNodeMeddrain
            let nodeACurr = self.medDrainCurrPos

            let nodeB = waterNodeBigdrain
            let nodeBMax = self.bigDrainMax
            let nodeBCurr = self.bigDrainCurrPos

            let amountToMove: Int = nodeACurr >= (nodeBMax - nodeBCurr) ? nodeBMax - nodeBCurr : nodeACurr
            let amountToStay: Int = nodeACurr - amountToMove
            print("Move Amount in \(nodeB.parent!.name!) - \(amountToMove) Amount stay in \(nodeA.parent!.name!) -\(amountToStay)")
            // Set the new values
            self.bigDrainCurrPos = self.bigDrainCurrPos + amountToMove
            self.medDrainCurrPos = amountToStay

            // get new pos child
            let newNodeAPos: String = String(self.medDrainCurrPos)
            let newNodeBPos: String = String(self.bigDrainCurrPos)
            //print(nodeA.parent!.name!," - ",newNodeAPos,nodeB.parent!.name!, " - ", newNodeBPos)
            let nodeInA = nodeA.parent!.childNode(withName: newNodeAPos, recursively: true)!
            let nodeInB = nodeB.parent!.childNode(withName: newNodeBPos, recursively: true)!

            let nodeAAction = SCNAction.move(to: nodeInA.position, duration: 1)
            let nodeBAction = SCNAction.move(to: nodeInB.position, duration: 1)
            nodeA.runAction(nodeAAction)
            nodeB.runAction(nodeBAction)
            self.checkPuzzleWinCon()
        })
        
        btnBC!.setInteractDelegate(function: {
            //B->C
            let nodeA = waterNodeMeddrain
            let nodeACurr = self.medDrainCurrPos

            let nodeB = waterNodeSmldrain
            let nodeBMax = self.smlDrainMax
            let nodeBCurr = self.smlDrainCurrPos

            let amountToMove: Int = nodeACurr >= (nodeBMax - nodeBCurr) ? nodeBMax - nodeBCurr : nodeACurr
            let amountToStay: Int = nodeACurr - amountToMove
            print("Move Amount in \(nodeB.parent!.name!) - \(amountToMove) Amount stay in \(nodeA.parent!.name!) -\(amountToStay)")
            // Set the new values
            self.smlDrainCurrPos = self.smlDrainCurrPos + amountToMove
            self.medDrainCurrPos = amountToStay

            // get new pos child
            let newNodeAPos: String = String(self.medDrainCurrPos)
            let newNodeBPos: String = String(self.smlDrainCurrPos)
            //print(nodeA.parent!.name!," - ",newNodeAPos,nodeB.parent!.name!, " - ", newNodeBPos)
            let nodeInA = nodeA.parent!.childNode(withName: newNodeAPos, recursively: true)!
            let nodeInB = nodeB.parent!.childNode(withName: newNodeBPos, recursively: true)!

            let nodeAAction = SCNAction.move(to: nodeInA.position, duration: 1)
            let nodeBAction = SCNAction.move(to: nodeInB.position, duration: 1)
            nodeA.runAction(nodeAAction)
            nodeB.runAction(nodeBAction)
            self.checkPuzzleWinCon()
        })
        
        btnCB!.setInteractDelegate(function: {
            //C->B
            let nodeA = waterNodeSmldrain
            let nodeACurr = self.smlDrainCurrPos

            let nodeB = waterNodeMeddrain
            let nodeBMax = self.medDrainMax
            let nodeBCurr = self.medDrainCurrPos

            let amountToMove: Int = nodeACurr >= (nodeBMax - nodeBCurr) ? nodeBMax - nodeBCurr : nodeACurr
            let amountToStay: Int = nodeACurr - amountToMove
            print("Move Amount in \(nodeB.parent!.name!) - \(amountToMove) Amount stay in \(nodeA.parent!.name!) -\(amountToStay)")
            // Set the new values
            self.medDrainCurrPos = self.medDrainCurrPos + amountToMove
            self.smlDrainCurrPos = amountToStay

            // get new pos child
            let newNodeAPos: String = String(self.smlDrainCurrPos)
            let newNodeBPos: String = String(self.medDrainCurrPos)
            //print(nodeA.parent!.name!," - ",newNodeAPos,nodeB.parent!.name!, " - ", newNodeBPos)
            let nodeInA = nodeA.parent!.childNode(withName: newNodeAPos, recursively: true)!
            let nodeInB = nodeB.parent!.childNode(withName: newNodeBPos, recursively: true)!

            let nodeAAction = SCNAction.move(to: nodeInA.position, duration: 1)
            let nodeBAction = SCNAction.move(to: nodeInB.position, duration: 1)
            nodeA.runAction(nodeAAction)
            nodeB.runAction(nodeBAction)
            self.checkPuzzleWinCon()
        })
        
        btnCA!.setInteractDelegate(function: {
            //C->A
            let nodeA = waterNodeSmldrain
            let nodeACurr = self.smlDrainCurrPos

            let nodeB = waterNodeBigdrain
            let nodeBMax = self.bigDrainMax
            let nodeBCurr = self.bigDrainCurrPos

            let amountToMove: Int = nodeACurr >= (nodeBMax - nodeBCurr) ? nodeBMax - nodeBCurr : nodeACurr
            let amountToStay: Int = nodeACurr - amountToMove

            print("Move Amount in \(nodeB.parent!.name!) - \(amountToMove) Amount stay in \(nodeA.parent!.name!) -\(amountToStay)")

            // Set the new values
            self.bigDrainCurrPos = self.bigDrainCurrPos + amountToMove
            self.smlDrainCurrPos = amountToStay

            // get new pos child
            let newNodeAPos: String = String(self.smlDrainCurrPos)
            let newNodeBPos: String = String(self.bigDrainCurrPos)
            //print(nodeA.parent!.name!," - ",newNodeAPos,nodeB.parent!.name!, " - ", newNodeBPos)
            let nodeInA = nodeA.parent!.childNode(withName: newNodeAPos, recursively: true)!
            let nodeInB = nodeB.parent!.childNode(withName: newNodeBPos, recursively: true)!

            let nodeAAction = SCNAction.move(to: nodeInA.position, duration: 1)
            let nodeBAction = SCNAction.move(to: nodeInB.position, duration: 1)
            nodeA.runAction(nodeAAction)
            nodeB.runAction(nodeBAction)
            self.checkPuzzleWinCon()
        })
        
        btnAC!.setInteractDelegate(function: {
            //A->C
            let nodeA = waterNodeBigdrain
            let nodeACurr = self.bigDrainCurrPos

            let nodeB = waterNodeSmldrain
            let nodeBMax = self.smlDrainMax
            let nodeBCurr = self.smlDrainCurrPos

            let amountToMove: Int = nodeACurr >= (nodeBMax - nodeBCurr) ? nodeBMax - nodeBCurr : nodeACurr
            let amountToStay: Int = nodeACurr - amountToMove
            print("Move Amount in \(nodeB.parent!.name!) - \(amountToMove) Amount stay in \(nodeA.parent!.name!) -\(amountToStay)")
            // Set the new values
            self.smlDrainCurrPos = self.smlDrainCurrPos + amountToMove
            self.bigDrainCurrPos = amountToStay

            // get new pos child
            let newNodeAPos: String = String(self.bigDrainCurrPos)
            let newNodeBPos: String = String(self.smlDrainCurrPos)
            //print(nodeA.parent!.name!," - ",newNodeAPos,nodeB.parent!.name!, " - ", newNodeBPos)
            let nodeInA = nodeA.parent!.childNode(withName: newNodeAPos, recursively: true)!
            let nodeInB = nodeB.parent!.childNode(withName: newNodeBPos, recursively: true)!

            let nodeAAction = SCNAction.move(to: nodeInA.position, duration: 1)
            let nodeBAction = SCNAction.move(to: nodeInB.position, duration: 1)
            nodeA.runAction(nodeAAction)
            nodeB.runAction(nodeBAction)
            self.checkPuzzleWinCon()
        })
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){
        print("A -",bigDrainCurrPos, " B - ",medDrainCurrPos, " C - ", smlDrainCurrPos)
        if(self.medDrainCurrPos == 600 && self.bigDrainCurrPos == 600) {
            print("Puzzle Solved")
        }
    }
    
    func setupFileOverlay() {
        let backgroundImage = UIImage(named: "art.scnassets/files.png")!.alpha(0.85)
        
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
        
        //fileImageNode.isHidden = true
        let interactButton = JKButtonNode(title: "X", state: .normal)
        interactButton.action = hideHintCallBack
        
        interactButton.setBackgroundsForState(normal: "art.scnassets/TextButtonNormal.png",highlighted: "", disabled: "")
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
        fileNode!.isHidden = false
        textNode!.isHidden = false
        closeBtn!.isHidden = false
    }
}


