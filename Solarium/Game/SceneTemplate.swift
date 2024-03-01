//
//  SceneTemplate.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit

class SceneTemplate {
    
    //var sceneFile: String
    
    var scene: SCNScene!
    
    init(sceneFile: String){
        scene = SCNScene(named: sceneFile)
        doSetUp()
    }
    
    func doSetUp(){
        
    }
    
    func update(){
        
    }
    
    func physicsWorldDidBegin(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact) {
       
        
    }

    func physicsWorldDidEnd(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact) {
        
    }

    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact) {
        
    }
}
