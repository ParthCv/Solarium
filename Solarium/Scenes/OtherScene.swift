//
//  OtherScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit

class OtherScene: SceneTemplate{
   
    var scene: SCNScene!
    
    var isUnloadable: Bool = true
    
    init() {
       scene = SCNScene(named: "art.scnassets/ship.scn")
   }
    
    func load() {
        
    }
    
    func unload() {
        
    }

    
    func update() {
        
    }
    
    func physicsWorldDidBegin(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact) {
        
    }
    
    func physicsWorldDidEnd(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact) {
        
    }
    
    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact) {
        
    }
    
}
