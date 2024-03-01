//
//  BaseScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit

class BaseScene: SceneTemplate{
    
    init() {
        super.init(sceneFile: "art.scnassets/ParthModelSpawn.scn")
    }
    
    override func doSetUp() {
        //Setup
    }
    
    override func update(){
        
    }
    
    override func physicsWorldDidBegin(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact) {
       
        
    }

    override func physicsWorldDidEnd(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact) {
        
    }

    override func physicsWorldDidUpdate(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact) {
        
    }
}
