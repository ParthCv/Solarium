//
//  S07_Final.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-04-17.
//

import SceneKit

class s07_Final: SceneTemplate {
    
    required init(gvc: GameViewController) {
        super.init(gvc: gvc)
        scene = SCNScene(named: "scenes.scnassets/S07_Final.scn")
    }
    
    override func load() {
        scene.rootNode.addChildNode(createFloor())
        super.load()
        
        
    }
    
    override func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
        }
    }
    
    override func gameInit() {
        currentPuzzle = 0
    }
}
