//
//  OtherScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit

class OtherScene: SceneTemplate{
    var interactableEntities: [Interactables]
       
    var scene: SCNScene!
    
    var isUnloadable: Bool = true
    
    init() {
        scene = SCNScene(named: "art.scnassets/ship.scn")
        interactableEntities = []
   }
    
    func load() {
        
    }
    
    func unload() {
        
    }
    
    func triggerInteractables(gameViewController: GameViewController) {
        print("scn2 ",interactableEntities.count)
        for interactableEntity in interactableEntities {
            if interactableEntity.distanceToNode(to: gameViewController.playerCharacter.modelNode) > interactableEntity.triggerVolume {
                print("triggerable ", interactableEntity.displayText)
            }
        }
    }

    
    func update(gameViewController: GameViewController) {
        triggerInteractables(gameViewController: gameViewController)
    }
    
    func physicsWorldDidBegin(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController:  GameViewController) {
        
    }
    
    func physicsWorldDidEnd(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController:  GameViewController) {
        
    }
    
    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController:  GameViewController) {
        
    }
    
}
