//
//  s03_Lights.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-29.
//

import SceneKit

class s03_Lights: SceneTemplate{
    
    override init() {
        super.init()
        scene = SCNScene(named: "scenes.scnassets/s03_Lights.scn")
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
        //TODO: Add puzzles
    }
    
}

extension s03_Lights {
    
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
