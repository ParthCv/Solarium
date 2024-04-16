//
//  s02_Agriculture.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-29.
//

import SceneKit

class s02_Agriculture: SceneTemplate{
    
    required init(gvc: GameViewController) {
        super.init(gvc: gvc)
        scene = SCNScene(named: "scenes.scnassets/s02_Agriculture.scn")
    }
    
    override func load() {
        //scene.rootNode.addChildNode(addAmbientLighting())        
        super.load()
    }
    
    override func gameInit() {
        let puzzle0 : Puzzle = Puzzle2(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(puzzle0)
        
        let puzzle1 : Puzzle = Puzzle3(puzzleID: 1, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(puzzle1)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
    }
    
}

extension s02_Agriculture {
    
}
