//
//  SceneTemplate.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit

protocol SceneTemplate {
    
    //var sceneFile: String
    
    var scene: SCNScene! { get }
    
    var isUnloadable: Bool { get }
    
    func load()
    
    func unload()
    
    func update()
    
    @MainActor func physicsWorldDidBegin(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact , gameViewController: GameViewController)

    func physicsWorldDidEnd(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact)

    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact)
}
