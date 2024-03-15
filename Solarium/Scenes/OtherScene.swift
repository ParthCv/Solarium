//
//  OtherScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit

class OtherScene: SceneTemplate{
    var mainCamera: SCNNode
    
    @MainActor func update(gameViewController: GameViewController, updateAtTime time: TimeInterval) {
        triggerInteractables(gameViewController: gameViewController)
        // Move and rotate the player from the inputs of the d-pad
        playerCharacter.playerController.movePlayerInXAndYDirection(
            changeInX: gameViewController.normalizedInputDirection.x,
            changeInZ: gameViewController.normalizedInputDirection.y,
            rotAngle: gameViewController.degree,
            deltaTime: time - gameViewController.lastTickTime
        )
        
        // Make the camera follow the player
        playerCharacter.playerController.repositionCameraToFollowPlayer(mainCamera: mainCamera)
    }
    
    var playerCharacter: PlayerCharacter
    
    func getPuzzleTrackedEntities(puzzleObj: Puzzle) {
        
    }
    
    
    var puzzles: [Puzzle]
    
    func gameInit() {
        
    }
    
    var deletableNodes: [SCNNode]
    
    var interactableEntities: [Interactable]
       
    var scene: SCNScene!
    
    var isUnloadable: Bool = true
    
    init() {
        scene = SCNScene(named: "scenes.scnassets/ship.scn")
        interactableEntities = []
        deletableNodes = []
        puzzles = []
        playerCharacter = PlayerCharacter(modelFilePath: "art.scnassets/SM_ModelTester.scn", nodeName: "PlayerNode_Wife")
        mainCamera = SCNNode()   }
    
    func load() {
        // Add the player to the scene
        scene.rootNode.addChildNode(playerCharacter.loadPlayerCharacter(spawnPosition: SCNVector3(0, 10, 0)))
        
        // Add a camera to the scene
        mainCamera = scene.rootNode.childNode(withName: "mainCamera", recursively: true) ?? SCNNode()
    }
    
    func unload() {
        
    }
    
    func triggerInteractables(gameViewController: GameViewController) {
//        print("scn2 ",interactableEntities.count)
//        for interactableEntity in interactableEntities {
//            if interactableEntity.distanceToNode(to: gameViewController.playerCharacter.modelNode) > interactableEntity.triggerVolume {
//                print("triggerable ", interactableEntity.displayText)
//            }
//        }
    }
    
    func physicsWorldDidBegin(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController:  GameViewController) {
        
    }
    
    func physicsWorldDidEnd(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController:  GameViewController) {
        
    }
    
    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController:  GameViewController) {
        
    }
    
}
