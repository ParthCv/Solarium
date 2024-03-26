//
//  PedestalScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-14.
//

import SceneKit

class PedestalScene: SceneTemplate {
    var mainCamera: SCNNode
    
    var playerCharacter: PlayerCharacter
    
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
        playerCharacter = PlayerCharacter(modelFilePath: "art.scnassets/SM_ModelTester_collider_on_head.scn", nodeName: "PlayerNode_Wife")
        mainCamera = SCNNode()
    }
    
    func load() {
        scene.rootNode.addChildNode(createFloor())
        // Add the player to the scene
        scene.rootNode.addChildNode(playerCharacter.loadPlayerCharacter(spawnPosition: SCNVector3(0, 10, 0)))
        
        // Add a camera to the scene
        mainCamera = scene.rootNode.childNode(withName: "mainCamera", recursively: true)!
        setUpPedestal()
    }
    
    func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
        }
    }
    
    func gameInit() {
        let pedPuzzle :Puzzle = PuzzlePedestalTest(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(pedPuzzle)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
        
        currentPuzzle = puzzles[0]
    }
    
    func triggerInteractables(gameViewController: GameViewController) {
        var highestPriority: TriggerPriority? = nil
        var interactableObject: Interactable? = nil
        
        for interactableEntity in currentPuzzle!.trackedEntities{
            if interactableEntity.value.node.distanceToNode(to: playerCharacter.modelNode) < interactableEntity.value.triggerVolume! && highestPriority ?? TriggerPriority.noPriority < interactableEntity.value.priority {
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
    
    func physicsWorldDidBegin(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    func physicsWorldDidEnd(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    func getPuzzleTrackedEntities(puzzleObj: Puzzle) {
        var foundKeyValuePairs : [Int: Interactable] = [Int: Interactable]()

        scene.rootNode.childNodes(passingTest:  { (node, stop) -> Bool in
            if let name = node.name, name.range(of: "P\(puzzleObj.puzzleID)_", options: .regularExpression) != nil {
                let nameParts = name.components(separatedBy: "_")
                print(nameParts)
                if nameParts.count >= 2, let interactableIndex = (nameParts[1].first), let intCast = Int(String(interactableIndex)) {
                    foundKeyValuePairs[intCast] = Interactable(node: node, priority: TriggerPriority.allCases[Int(nameParts[2]) ?? 0], displayText: nameParts[3])
                    print(foundKeyValuePairs[intCast]?.priority)
                }
                
                return true
            }
            
            return false;
        })
        
        puzzleObj.trackedEntities = foundKeyValuePairs
        puzzleObj.linkEntitiesToPuzzleLogic()
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
        let baseNode: SCNNode = scene.rootNode.childNode(withName: "P0_0_2_PowerPedestal", recursively: true)!
        let ballNode: SCNNode = scene.rootNode.childNode(withName: "P0_1_0_PowerSphere", recursively: true)!

        let batteryNodePos = baseNode.childNode(withName: "BatteryRoot", recursively: true)!
        
        baseNode.addChildNode(ballNode)
        ballNode.worldPosition = batteryNodePos.worldPosition
        print("ball - ", ballNode.position, " battery - ", batteryNodePos.worldPosition)
    }
    
}
