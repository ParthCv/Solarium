//
//  PuzzleMovingPlatformTest.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-27.
//

/**
 
 JUST A TEST CLASS NOT USED ANYMORE
 
 */

import SceneKit

class PuzzleMovingPlatformTest: Puzzle {
    var platformNode: Interactable?
    var triggerButtonNode: Interactable?
    var platformStart: Interactable?
    var platformEnd: Interactable?
    
    var platformPositions: [SCNVector3]?
    var currPlatformPosIndex: Int?
    
    override init (puzzleID: Int, trackedEntities: [Int: Interactable], sceneTemplate: SceneTemplate) {
        super.init(puzzleID: puzzleID, trackedEntities: trackedEntities, sceneTemplate: sceneTemplate)
        platformNode = nil
        triggerButtonNode = nil
        platformStart = nil
        platformEnd = nil
        platformPositions = []
    }
    
    // Function called when entities assigned
    override func linkEntitiesToPuzzleLogic(){
        if trackedEntities[0] != nil {
            platformNode = trackedEntities[0]
        }
        if trackedEntities[1] != nil {
            triggerButtonNode = trackedEntities[1]
        }
        if trackedEntities[3] != nil {
            platformStart = trackedEntities[3]
            platformPositions?.append(platformStart!.node.childNodes[1].worldPosition)
        }
        if trackedEntities[2] != nil {
            platformEnd = trackedEntities[2]
            platformPositions?.append(platformEnd!.node.childNodes[1].worldPosition)
        }
       
        currPlatformPosIndex = 0
        triggerButtonNode!.setInteractDelegate(function: pedestalInteractDelegate)
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){

    }
    
    func pedestalInteractDelegate() {
        print("BTN pressed")
        
        currPlatformPosIndex = (currPlatformPosIndex!+1) % platformPositions!.count
        
        let startPos = platformStart!.node.childNodes[1].worldPosition
        let endPos = platformPositions![currPlatformPosIndex!]

        print("curr pos ", currPlatformPosIndex!)
        
        let moveAction = SCNAction.move(to: endPos, duration: 10)
        
        triggerButtonNode?.priority = .noPriority

        platformNode!.node.runAction(moveAction) {
            self.triggerButtonNode?.priority = .mediumPriority
        }
        

        
    }

    
}
