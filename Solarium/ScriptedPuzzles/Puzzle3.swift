//
//  Puzzle3.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-30.
//

import SceneKit

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
        btnCA = trackedEntities[7]
        btnAC = trackedEntities[8]
        
        let waterNodeBigdrain = bigDrain!.node.childNode(withName: "cylinder", recursively: true)!
        let waterNodeMeddrain = medDrain!.node.childNode(withName: "cylinder", recursively: true)!
        let waterNodeSmldrain = smlDrain!.node.childNode(withName: "cylinder", recursively: true)!
        
        btnAB!.setInteractDelegate(function: drainBtnDelegateMaker(NodeA: waterNodeBigdrain, NodeB: waterNodeMeddrain, NodeAMax: bigDrainMax, NodeBMax: medDrainMax, NodeACurr: &bigDrainCurrPos, NodeBCurr: &medDrainCurrPos))
        btnBA!.setInteractDelegate(function: drainBtnDelegateMaker(NodeA: waterNodeMeddrain, NodeB: waterNodeBigdrain, NodeAMax: medDrainMax, NodeBMax: bigDrainMax, NodeACurr: &medDrainCurrPos, NodeBCurr: &bigDrainCurrPos))
        
        btnBC!.setInteractDelegate(function: drainBtnDelegateMaker(NodeA: waterNodeMeddrain, NodeB: waterNodeSmldrain, NodeAMax: medDrainMax, NodeBMax: smlDrainMax, NodeACurr: &medDrainCurrPos, NodeBCurr: &smlDrainCurrPos))
        btnCB!.setInteractDelegate(function: drainBtnDelegateMaker(NodeA: waterNodeSmldrain, NodeB: waterNodeMeddrain, NodeAMax: smlDrainMax, NodeBMax: medDrainMax, NodeACurr: &smlDrainCurrPos, NodeBCurr: &medDrainCurrPos))
        
        btnCA!.setInteractDelegate(function: drainBtnDelegateMaker(NodeA: waterNodeSmldrain, NodeB: waterNodeBigdrain, NodeAMax: smlDrainMax, NodeBMax: bigDrainMax, NodeACurr: &smlDrainCurrPos, NodeBCurr: &bigDrainCurrPos))
        btnAC!.setInteractDelegate(function: drainBtnDelegateMaker(NodeA: waterNodeBigdrain, NodeB: waterNodeSmldrain, NodeAMax: bigDrainMax, NodeBMax: smlDrainMax, NodeACurr: &bigDrainCurrPos, NodeBCurr: &smlDrainCurrPos))
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){
        print("A -",bigDrainCurrPos, " B - ",medDrainCurrPos, " C - ", smlDrainCurrPos)
        if(self.medDrainCurrPos == 600 && self.bigDrainCurrPos == 600) {
            print("Puzzle Solved")
        }
    }
    
    func drainBtnDelegateMaker(NodeA: SCNNode, NodeB: SCNNode, NodeAMax: Int, NodeBMax: Int,  NodeACurr: inout Int, NodeBCurr: inout Int) -> () -> () {
        // Calculate New Values
        let amountToMove: Int = NodeACurr >= (NodeBMax - NodeBCurr) ? NodeBMax - NodeBCurr : NodeACurr
        let amountToStay: Int = NodeACurr - amountToMove
        
        // Set the new values
        NodeBCurr = NodeBCurr + amountToMove
        NodeACurr = amountToMove
        
        //print("Node A - ",NodeACurr, " node B - ", NodeBCurr)
        
        // get new pos child
        let newNodeAPos: String = String(NodeACurr)
        let newNodeBPos: String = String(NodeBCurr)
            return {
                //print(NodeA.parent!.name!," - ",newNodeAPos,NodeB.parent!.name!, " - ", newNodeBPos)
                let nodeInA = NodeA.parent!.childNode(withName: newNodeAPos, recursively: true)!
                let nodeInB = NodeB.parent!.childNode(withName: newNodeBPos, recursively: true)!
                
                let nodeAAction = SCNAction.move(to: nodeInA.worldPosition, duration: 1)
                let nodeBAction = SCNAction.move(to: nodeInB.worldPosition, duration: 1)
                self.checkPuzzleWinCon()
//                NodeA.runAction(nodeAAction)
//                NodeB.runAction(nodeBAction)
            }
        }	
    
}

