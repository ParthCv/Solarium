//
//  BaseScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit

class BaseScene: SceneTemplate{
    var mainCamera: SCNNode
    
    var playerCharacter: PlayerCharacter
    
    func getPuzzleTrackedEntities(puzzleObj: Puzzle) {
        
    }
    
    
    var puzzles: [Puzzle]
    

    
    var deletableNodes: [SCNNode]
    
    var interactableEntities: [Interactable]
    
    var scene: SCNScene!
    
    var isUnloadable: Bool = true
    
    init() {
        scene = SCNScene(named: "scenes.scnassets/ParthModelSpawn.scn")
        interactableEntities = []
        deletableNodes = []
        puzzles = []
        playerCharacter = PlayerCharacter(modelFilePath: "art.scnassets/SM_ModelTester.scn", nodeName: "PlayerNode_Wife")
        mainCamera = SCNNode()
    }
    
    func triggerInteractables(gameViewController: GameViewController) {
        var highestPriority: TriggerPriority? = nil
        var interactableObject: Interactable? = nil
        
        for interactableEntity in interactableEntities {
            if interactableEntity.node.distanceToNode(to: playerCharacter.modelNode) < interactableEntity.triggerVolume! && highestPriority ?? TriggerPriority.noPriority < interactableEntity.priority {
                highestPriority = interactableEntity.priority
                interactableObject = interactableEntity
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
    
    func load() {
        scene.rootNode.addChildNode(addCube())
        scene.rootNode.addChildNode(addAmbientLighting())
        scene.rootNode.addChildNode(createFloor())
        scene.rootNode.addChildNode(addConsumeableCube())
        // Add the player to the scene
        scene.rootNode.addChildNode(playerCharacter.loadPlayerCharacter(spawnPosition: SCNVector3(0, 10, 0)))
        
        // Add a camera to the scene
        mainCamera = scene.rootNode.childNode(withName: "mainCamera", recursively: true) ?? SCNNode()
    }
    
    func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
        }
    }
    
    func gameInit() {
        print("jas wuz here")
    }
    
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
    
    func physicsWorldDidBegin(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        switch contact.nodeA.physicsBody!.categoryBitMask {
            
        case SolariumCollisionBitMask.interactable.rawValue:
            break
            
        default:
            break
        }
        
    }
    
    func physicsWorldDidEnd(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        switch contact.nodeA.physicsBody!.categoryBitMask {
            
        case SolariumCollisionBitMask.interactable.rawValue:
            break
            
        default:
            break
        }
    }
    
    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController:  GameViewController) {
    
        switch contact.nodeA.physicsBody!.categoryBitMask {
            
        case SolariumCollisionBitMask.interactable.rawValue:
            break
            
        default:
            break
        }
    }

}

extension BaseScene {
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grid.png"

        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        floorNode.physicsBody?.categoryBitMask = SolariumCollisionBitMask.ground.rawValue
        floorNode.physicsBody?.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.interactable.rawValue
        
        return floorNode
    }
    
    func addAmbientLighting() -> SCNNode {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        
        return ambientLight
    }
    
    func addCube() -> SCNNode {
//        let cubeNode = SceneChangeInteractable(displayText: "Go to next Scene", priority: .highPriority, triggerVolume: 5.0, mesh: SCNGeometry())
//        cubeNode.geometry = SCNBox(width: 1, height: 1, length: 10, chamferRadius: 0)
//        cubeNode.name = "cube_sceneChange"
//        cubeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//        cubeNode.position = SCNVector3(x: 2.5, y: 1, z: 1)
//        
//        cubeNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.interactable.rawValue
//        cubeNode.physicsBody!.contactTestBitMask = SolariumCollisionBitMask.player.rawValue
//        cubeNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.ground.rawValue
//        self.interactableEntities.append(cubeNode)
//        return cubeNode
        return SCNNode()
    }
    
    func addConsumeableCube() -> SCNNode {
//        let cubeNode = ConsumableInteractable(displayText: "Consume", priority: .mediumPriority, triggerVolume: 15.0, sceneTemp: self, mesh: SCNGeometry())
//        cubeNode.geometry = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
//        cubeNode.name = "cube_consumable"
//        cubeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//        cubeNode.position = SCNVector3(x: -2.5, y: 1, z: 1)
//        
//        cubeNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.interactable.rawValue
//        cubeNode.physicsBody!.contactTestBitMask = SolariumCollisionBitMask.player.rawValue
//        cubeNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.ground.rawValue
//        self.interactableEntities.append(cubeNode)
//        //self.deletableNodes.append(cubeNode)
//        return cubeNode
        return SCNNode()
    }
    
    func deleteNodes() {
        if (!self.deletableNodes.isEmpty) {
            for node in self.deletableNodes {
                
                //TODO: Parth -> rn we dont delete the interactable from the list (! we need to delete it in this loop, otherwise the array might be accessed in some other frame while we are removing the elelment [Race condition])
                
                // remove if interactable
//                if let interactableToRemove = node as? Interactables {
//                    for interactableEntity in self.interactableEntities {
//                        if (interactableEntity == interactableToRemove)
//                            self.interactableEntities.
//                    }
//                }
                
                // remove SceneKit SCNNode
                node.geometry!.firstMaterial!.normal.contents = nil
                node.geometry!.firstMaterial!.diffuse.contents = nil
                node.removeFromParentNode()
            }
        }
    }
}
