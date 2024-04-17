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
        
        let leftWingWire = scene.rootNode.childNode(withName: "Dec_CenterRoomPipeLeft", recursively: true)!
        let leftWingLight = scene.rootNode.childNode(withName: "Light_Status_Water", recursively: true)!
        let rightWingWire = scene.rootNode.childNode(withName: "Dec_CenterRoomPipeRight", recursively: true)!
        let rightWingLight = scene.rootNode.childNode(withName: "Light_Status_Grow", recursively: true)!
        
        if (self.gvc.scenesPuzzleComplete[.SCN2]!) {
            let leftWingMat = SCNMaterial()
            leftWingMat.diffuse.contents = UIColor.yellow
            leftWingMat.emission.contents = UIColor.yellow
            leftWingWire.geometry!.firstMaterial = leftWingMat
            leftWingLight.geometry!.firstMaterial = leftWingMat
        } else {
            let leftWingMat = SCNMaterial()
            leftWingMat.diffuse.contents = UIColor.red
            leftWingMat.emission.contents = UIColor.red
            leftWingLight.geometry!.firstMaterial = leftWingMat
        }
        
        if (self.gvc.scenesPuzzleComplete[.SCN3]!) {
            let rightWingMat = SCNMaterial()
            rightWingMat.diffuse.contents = UIColor.yellow
            rightWingMat.emission.contents = UIColor.yellow
            rightWingWire.geometry!.firstMaterial = rightWingMat
            rightWingLight.geometry!.firstMaterial = rightWingMat
        } else {
            let rightWingMat = SCNMaterial()
            rightWingMat.diffuse.contents = UIColor.red
            rightWingMat.emission.contents = UIColor.red
            rightWingLight.geometry!.firstMaterial = rightWingMat
        }
        
        if (self.gvc.scenesPuzzleComplete[.SCN2]! && self.gvc.scenesPuzzleComplete[.SCN3]!) {
            _ = Door(node: self.scene.rootNode.childNode(withName: "D_Door_0", recursively: true)!, openState: true)
            
            let lightMat = SCNMaterial()
            lightMat.diffuse.contents = UIColor.green
            lightMat.emission.contents = UIColor.green
            leftWingLight.geometry!.firstMaterial = lightMat
            rightWingLight.geometry!.firstMaterial = lightMat
        }
        
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
