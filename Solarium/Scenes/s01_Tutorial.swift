//
//  01_TutorialScene.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-04.
//

import SceneKit

class s01_TutorialScene: SceneTemplate{
    
    required init(gvc: GameViewController) {
        super.init(gvc: gvc)
        scene = SCNScene(named: "scenes.scnassets/s01_Tutorial.scn")
    }
    
    override func load() {
        scene.rootNode.addChildNode(addAmbientLighting())
        //scene.rootNode.addChildNode(createFloor())
        super.load()
    }
    
    override func gameInit() {
        if (self.gvc.scenesPuzzleComplete[.SCN2]! && self.gvc.scenesPuzzleComplete[.SCN3]!) {
            _ = Door(node: self.scene.rootNode.childNode(withName: "D_Door_0", recursively: true)!, openState: true)
        }

        // let leftWingWire = scene.rootNode.childNode(withName: "LeftWingWire", recursively: true)!
        // let leftWingLight = scene.rootNode.childNode(withName: "LeftWingLight", recursively: true)!
        // let rightWingWire = scene.rootNode.childNode(withName: "RightWingWire", recursively: true)!
        // let rightWingLight = scene.rootNode.childNode(withName: "RightWingLight", recursively: true)!

        // let leftWingMat = (self.gvc.scenesPuzzleComplete[.SCN2]!) ? : 
        // leftWingWire.geometry!.firstMaterial! = leftWingMat
        // leftWingLight.geometry!.firstMaterial! = leftWingMat

        // let rightWingMat = (self.gvc.scenesPuzzleComplete[.SCN3]!) ? : 
        // rightWingWire.geometry!.firstMaterial! = rightWingMat
        // rightWingLight.geometry!.firstMaterial! = rightWingMat
        
        let puzzle0 : Puzzle = Puzzle0(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(puzzle0)
        
        let puzzle1 : Puzzle = Puzzle1(puzzleID: 1, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(puzzle1)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
    }
}

extension s01_TutorialScene {

}
