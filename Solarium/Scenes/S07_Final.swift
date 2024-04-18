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
//        scene.rootNode.addChildNode(createFloor())
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
        let nodes = scene.rootNode.childNodes
        var tubes: [Tube] = []
        for node in nodes {
            if ((node.name?.contains("theTUBE")) != nil){
                tubes.append(Tube(node: node, openState: nil))
            }
        }
        
        var eves: [Eve] = []
        for node in nodes {
            if ((node.name?.contains("SK_Eve")) != nil){
                eves.append(Eve(node: node, openState: nil))
            }
        }
        
        if(true){ // self.gvc.scenesPuzzleComplete[.SCN2]! && self.gvc.scenesPuzzleComplete[.SCN3]!
//            for tube in tubes {
//                tube.rise()
//            }
            
//            for eve in eves {
//                eve.playBootUpAnimation()
//            }
        }
    }
}
