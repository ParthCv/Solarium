//
//  TeleportScene.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-26.
//

import SceneKit

class TeleportScene: SceneTemplate{
    var mainCamera: SCNNode
    
    var playerCharacter: PlayerCharacter
    
    var puzzles: [Puzzle]
    var deletableNodes: [SCNNode]
    var currentPuzzle: Puzzle?
    
    var interactableEntities: [Interactable]
    
    var scene: SCNScene!
    
    var isUnloadable: Bool = true
    
    
    init() {
        scene = SCNScene(named: "scenes.scnassets/TeleportScene.scn")
        interactableEntities = []
        deletableNodes = []
        puzzles = []
        playerCharacter = PlayerCharacter(modelFilePath: "art.scnassets/SM_ModelTester.scn", nodeName: "PlayerNode_Wife")
        mainCamera = SCNNode()
    }
    
    
    func load() {
        scene.rootNode.addChildNode(createFloor())
        // Add the player to the scene
        scene.rootNode.addChildNode(playerCharacter.loadPlayerCharacter(spawnPosition: SCNVector3(0, 10, 0)))
        
        // Add a camera to the scene
        mainCamera = scene.rootNode.childNode(withName: "mainCamera", recursively: true)!
        //              setUpPedestal()
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
    
    @MainActor
    func update(gameViewController: GameViewController, updateAtTime time: TimeInterval) {
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
    
    func physicsWorldDidBegin(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    func physicsWorldDidEnd(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController:  GameViewController) {
        
    }
    
    func triggerInteractables(gameViewController: GameViewController) {
        var highestPriority: TriggerPriority? = nil
        var interactableObject: Interactable? = nil
        
        
        //        for interactableEntity in currentPuzzle!.trackedEntities{
        //            if interactableEntity.value.node.distanceToNode(to: playerCharacter.modelNode) < interactableEntity.value.triggerVolume! && highestPriority ?? TriggerPriority.noPriority < interactableEntity.value.priority {
        //                highestPriority = interactableEntity.value.priority
        //                interactableObject = interactableEntity.value
        //            }
        //        }
        
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
    
    func getPuzzleTrackedEntities(puzzleObj: Puzzle) {
        
    }
}

extension TeleportScene {
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grid.png"
        
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        //        floorNode.physicsBody?.categoryBitMask = SolariumCollisionBitMask.ground.rawValue
        //        floorNode.physicsBody?.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.interactable.rawValue
        
        return floorNode
    }
}

class TeleportPuzzle: Puzzle{
    var tele1: TeleportInteractable?
    var tele2: TeleportInteractable?
    var hasTaken = false
    
    // Function called when entities assigned
    override func linkEntitiesToPuzzleLogic(){
        // Get trackedEntity Start
        // Get trackedEntity End
        // Init
    
        tele1!.doInteractDelegate = teleportDelegate
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){
        if (hasTaken) {
            print("Puzzle Complete")
            self.solved = true
        }
    }
    
    func teleportDelegate(){
        //Do teleport
    }
}

class TeleportInteractable: Interactable{
    
}
