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
        super.load()
    }
    
    override func gameInit() {
        // Check if both left (argiculture) scene puzzles + right (light room) scene puzzles are completed
        // Opens door leading up to the Solarium
        if (self.gvc.scenesPuzzleComplete[.SCN2]! && self.gvc.scenesPuzzleComplete[.SCN3]!) {
            _ = Door(node: self.scene.rootNode.childNode(withName: "D_Door_0", recursively: true)!, openState: true)
            
            gvc.audioManager?.playInteractSound(interactableName: "CentralDoorPowered")
        }
        
        let leftWingWire = scene.rootNode.childNode(withName: "Dec_CenterRoomPipeLeft", recursively: true)!
        let leftWingLight = scene.rootNode.childNode(withName: "Light_Status_Water", recursively: true)!
        let rightWingWire = scene.rootNode.childNode(withName: "Dec_CenterRoomPipeRight", recursively: true)!
        let rightWingLight = scene.rootNode.childNode(withName: "Light_Status_Grow", recursively: true)!
        
        // Switch the materials on the wires and lights based on the puzzle completion of the left and right wings
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
        
        setUpButtonsOnPlatform()
        
        // Create the two tutorial puzzles
        let puzzle0 : Puzzle = Puzzle0(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(puzzle0)
        
        let puzzle1 : Puzzle = Puzzle1(puzzleID: 1, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(puzzle1)
        
        // Set up the puzzles with their tracked entities
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
    }
}

extension s01_TutorialScene {
    func setUpButtonsOnPlatform() {
        let platformNode: SCNNode = scene.rootNode.childNode(withName: "EndPlatform", recursively: true)!
        let upButtonNode: SCNNode = scene.rootNode.childNode(withName: "P1_5_3_Up", recursively: true)!
        
        let curBtnWolrdPos = upButtonNode.worldPosition
        platformNode.addChildNode(upButtonNode)
        upButtonNode.scale = SCNVector3(0.25, 0.25, 0.25	)
        upButtonNode.worldPosition = curBtnWolrdPos
    }
}
