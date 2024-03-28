//
//  PuzzleMovingPlatformTest.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-27.
//

import SceneKit

class PuzzleMovingPlatformTest: Puzzle {
    var platformNode: Interactable?
    var triggerButtonNode: Interactable?
    var platformStart: Interactable?
    var platformEnd: Interactable?
    
    override init (puzzleID: Int, trackedEntities: [Int: Interactable], sceneTemplate: SceneTemplate) {
        super.init(puzzleID: puzzleID, trackedEntities: trackedEntities, sceneTemplate: sceneTemplate)
        platformNode = nil
        triggerButtonNode = nil
        platformStart = nil
        platformEnd = nil
    }
    
    // Function called when entities assigned
    override func linkEntitiesToPuzzleLogic(){
        if trackedEntities[0] != nil {
            platformNode = trackedEntities[0]
        }
        if trackedEntities[1] != nil {
            triggerButtonNode = trackedEntities[1]
        }
        if trackedEntities[2] != nil {
            platformStart = trackedEntities[2]
        }
        if trackedEntities[3] != nil {
            platformEnd = trackedEntities[3]
        }
        
        triggerButtonNode!.setInteractDelegate(function: pedestalInteractDelegate)
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){

    }
    
    func pedestalInteractDelegate() {
        print("BTN pressed")
        
    }
    
}
