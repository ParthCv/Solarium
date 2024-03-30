//
//  s02_Agriculture.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-29.
//

import SceneKit

class s02_Agriculture: SceneTemplate{
    
    override init() {
        super.init()
        scene = SCNScene(named: "scenes.scnassets/s02_Agriculture.scn")
    }
    
    override func load() {
        scene.rootNode.addChildNode(addAmbientLighting())
        // Setup collision of scene objects
        scene.rootNode.addChildNode(createFloor())
        
        // Add the player to the scene
        scene.rootNode.addChildNode(playerCharacter.loadPlayerCharacter(spawnPosition: SCNVector3(0, 10, 0)))
        // Add a camera to the scene
        mainCamera = scene.rootNode.childNode(withName: "mainCamera", recursively: true) ?? SCNNode()
    }
    
    override func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
        }
    }
    
    override func gameInit() {
        let puzzle0 : Puzzle = Puzzle2(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(puzzle0)
        
//        let puzzle1 : Puzzle = Puzzle2(puzzleID: 1, trackedEntities: [Int: Interactable](), sceneTemplate: self)
//        puzzles.append(puzzle1)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
    }
    
}

extension s02_Agriculture {
    
    func addAmbientLighting() -> SCNNode {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        
        return ambientLight
    }
    
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grid.png"
        
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        return floorNode
    }
    
}
