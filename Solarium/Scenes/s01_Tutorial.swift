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
        // Setup collision of scene objects
        scene.rootNode.addChildNode(createFloor())
        super.load()
    }
    
    override func gameInit() {
        super.gameInit()
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
    
    func addAmbientLighting() -> SCNNode {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        deletableNodes.append(ambientLight)
        return ambientLight
    }
    
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grid.png"

        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        deletableNodes.append(floorNode)
        return floorNode
    }
    
}
