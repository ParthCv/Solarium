//
//  BaseScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit

class BaseScene: SceneTemplate{
    var interactableEntities: [Interactables]
    
    var scene: SCNScene!
    
    var isUnloadable: Bool = true
    
    init() {
        scene = SCNScene(named: "art.scnassets/ParthModelSpawn.scn")
        interactableEntities = []
    }
    
    func triggerInteractables(gameViewController: GameViewController) {
        //print("scn1", interactableEntities.count)
        
        var highestPriority: TriggerPriority? = nil
        var interactableObject: Interactables? = nil
        
        for interactableEntity in interactableEntities {
            if interactableEntity.distanceToNode(to: gameViewController.playerCharacter.modelNode) < interactableEntity.triggerVolume && highestPriority.hashValue < interactableEntity.priority.hashValue {
                interactableObject = interactableEntity
            }
        }
        
        if (interactableObject == nil) {
            //print("Nothing to interact")
            gameViewController.interactButton.action = nil
            gameViewController.interactButton.title.text = ""
            gameViewController.interactButton.isHidden = true
        } else {
            //print("interactable with ", interactableObject!.displayText)
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
    }
    
    func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
        }
    }
    
    func update(gameViewController: GameViewController) {
        
        //TODO: Parth - clean up this code into a function also add the glkvector shit into a util function
//        let cube = self.scene.rootNode.childNode(withName: "cube_sceneChange", recursively: true)
//
//        let distance = cube!.distanceToNode(to: gameViewController.playerCharacter.modelNode)
//        
//        gameViewController.interactButton.isHidden = (distance > 5)
        
        triggerInteractables(gameViewController: gameViewController)
        
    }
    
    func physicsWorldDidBegin(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        switch contact.nodeA.physicsBody!.categoryBitMask {
            
        case SolariumCollisionBitMask.interactable.rawValue:
            print("Hit a cube")
//            gameViewController.currScn = SceneController.singleton.switchScene(gameViewController.gameView, currScn: gameViewController.currScn, nextScn: .SCN2)
//            //Set player pos to scene entrance
            //gameViewController.gameView.interactButton.isHidden = false
            
            break
            
        default:
            break
        }
        
    }
    
    func physicsWorldDidEnd(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        switch contact.nodeA.physicsBody!.categoryBitMask {
            
        case SolariumCollisionBitMask.interactable.rawValue:
//            print("Hit a cube")
//            gameViewController.currScn = SceneController.singleton.switchScene(gameViewController.gameView, currScn: gameViewController.currScn, nextScn: .SCN2)
//            //Set player pos to scene entrance
            //gameViewController.gameView.interactButton.isHidden = true
            
            break
            
        default:
            break
        }
    }
    
    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController:  GameViewController) {
    
        switch contact.nodeA.physicsBody!.categoryBitMask {
            
        case SolariumCollisionBitMask.interactable.rawValue:
//            print("Hit a cube")
//            gameViewController.currScn = SceneController.singleton.switchScene(gameViewController.gameView, currScn: gameViewController.currScn, nextScn: .SCN2)
//            //Set player pos to scene entrance
            //gameViewController.gameView.interactButton.isHidden = false
            
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
        let cubeNode = SceneChangeInteractable(displayText: "Go to next Scene", priority: .highPriority, triggerVolume: 5.0)
        cubeNode.geometry = SCNBox(width: 1, height: 1, length: 10, chamferRadius: 0)
        cubeNode.name = "cube_sceneChange"
        cubeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        cubeNode.position = SCNVector3(x: 5, y: 1, z: 1)
        
        cubeNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.interactable.rawValue
        cubeNode.physicsBody!.contactTestBitMask = SolariumCollisionBitMask.player.rawValue
        cubeNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.ground.rawValue
        self.interactableEntities.append(cubeNode)
        return cubeNode
    }
    
    func addConsumeableCube() -> SCNNode {
        let cubeNode = ConsumableInteractable(displayText: "Consume", priority: .mediumPriority, triggerVolume: 5.0)
        cubeNode.geometry = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
        cubeNode.name = "cube_consumable"
        cubeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        cubeNode.position = SCNVector3(x: -5, y: 1, z: 1)
        
        cubeNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.interactable.rawValue
        cubeNode.physicsBody!.contactTestBitMask = SolariumCollisionBitMask.player.rawValue
        cubeNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.ground.rawValue
        self.interactableEntities.append(cubeNode)
        return cubeNode
    }
}
