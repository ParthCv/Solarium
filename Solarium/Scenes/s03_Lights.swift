//
//  s03_Lights.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-29.
//

import SceneKit

class s03_Lights: SceneTemplate{
    
    required init(gvc: GameViewController) {
        super.init(gvc: gvc)
        scene = SCNScene(named: "scenes.scnassets/s03_Lights.scn")
    }
    
    override func load() {
        scene.rootNode.addChildNode(addAmbientLighting())
        // Setup collision of scene objects
        scene.rootNode.addChildNode(createFloor())
        
        super.load()
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
        deletableNodes.append(ambientLight)
        return ambientLight
    }
    
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grid.png"

        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        floorNode.physicsBody!.rollingFriction = 1
        floorNode.physicsBody!.friction = 1
        deletableNodes.append(floorNode)
        return floorNode
    }
    
}
