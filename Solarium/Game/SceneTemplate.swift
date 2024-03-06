//
//  SceneTemplate.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit

// Abstract class to hold the basic info for a scene
protocol SceneTemplate {
    
    // the scene itself in the scnasset folder
    var scene: SCNScene! { get }
    
    // flag to make the scene unloaded after the switch
    var isUnloadable: Bool { get }
    
    // list of all interactable
    var interactableEntities: [Interactable] {set get}
    
    // list of all deletable nodes
    var deletableNodes: [SCNNode] {get set}
    
    // preload for the scene
    func load(gameViewController: GameViewController)
    
    // delete the nodes from memeory
    func unload()
    
    // trihher any interactable in the scene based on conditions and priority
    @MainActor func triggerInteractables(gameViewController: GameViewController)
    
    // the rendering update for the scene
    @MainActor func update(gameViewController: GameViewController)
    
    // physics updates for the scene
    @MainActor func physicsWorldDidBegin(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact, gameViewController: GameViewController)

    // physics updates for the scene
    @MainActor func physicsWorldDidEnd(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact,  gameViewController: GameViewController)

    // physics updates for the scene
    @MainActor func physicsWorldDidUpdate(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact, gameViewController: GameViewController)
}
