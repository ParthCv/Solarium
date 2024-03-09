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
    
    // the list of puzzles for this scene
    var puzzles: [Puzzle] {set get}
    
    // list of all interactable
    var interactableEntities: [Interactable] {set get}
    
    // list of all deletable nodes
    var deletableNodes: [SCNNode] {get set}
    
    // preload for the scene
    func load()
    
    // delete the nodes from memeory
    func unload()
    
    // The function called on the scene to perform Solarium game setup logic
    @MainActor func gameInit()
    
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
