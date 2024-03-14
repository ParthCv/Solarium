//
//  PedestalScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-14.
//

import SceneKit

class PedestalScene: SceneTemplate {
    var scene: SCNScene!
    
    var isUnloadable: Bool = false
    
    var puzzles: [Puzzle]
    
    var deletableNodes: [SCNNode]
    
    var currentPuzzle: Puzzle?
    
    init() {
        scene = SCNScene(named: "scenes.scnassets/parthPedestalScene.scn")
        deletableNodes = []
        puzzles = []
        currentPuzzle = nil
    }
    
    func load() {
        scene.rootNode.addChildNode(createFloor())
    }
    
    func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
        }
    }
    
    func gameInit() {
        
    }
    
    func triggerInteractables(gameViewController: GameViewController) {
        var highestPriority: TriggerPriority? = nil
        var interactableObject: Interactable? = nil
        
        for interactableEntity in currentPuzzle!.trackedEntities{
            if interactableEntity.value.node.distanceToNode(to: gameViewController.playerCharacter.modelNode) < interactableEntity.value.triggerVolume! && highestPriority ?? TriggerPriority.noPriority < interactableEntity.value.priority {
                highestPriority = interactableEntity.value.priority
                interactableObject = interactableEntity.value
            }
        }
        
        if (interactableObject == nil) {
            gameViewController.interactButton.action = nil
            gameViewController.interactButton.title.text = ""
            gameViewController.interactButton.isHidden = true
        } else {
            gameViewController.interactButton.action = interactableObject!.doInteract
            gameViewController.interactButton.title.text = interactableObject!.displayText
            gameViewController.interactButton.isHidden = false
        }
    }
    
    func update(gameViewController: GameViewController) {
        
    }
    
    func physicsWorldDidBegin(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    func physicsWorldDidEnd(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    func getPuzzleTrackedEntities(puzzleObj: Puzzle) {
        
    }
    
    
}


extension PedestalScene {
    
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grid.png"

        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        floorNode.physicsBody?.categoryBitMask = SolariumCollisionBitMask.ground.rawValue
        floorNode.physicsBody?.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.interactable.rawValue | 1
        
        return floorNode
    }
    
    func setUpPedestal() {
        var baseNode = scene.rootNode.childNode(withName: "P0_0_PowerPedestal", recursively: true)!
        var ballNode = scene.rootNode.childNode(withName: "P0_1_PowerSphere", recursively: true)!
        
        baseNode.childNode[0]
    }
    
}
