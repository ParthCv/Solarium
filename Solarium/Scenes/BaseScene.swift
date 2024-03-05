//
//  BaseScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit

class BaseScene: SceneTemplate{
    var scene: SCNScene!
    
    var isUnloadable: Bool = true
    
     init() {    
        scene = SCNScene(named: "art.scnassets/ParthModelSpawn.scn")
    }
    
    func load() {
        scene.rootNode.addChildNode(addCube())
        scene.rootNode.addChildNode(addAmbientLighting())
        scene.rootNode.addChildNode(createFloor())
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
        let cube = self.scene.rootNode.childNode(withName: "cube", recursively: true)

        let distance = cube!.distanceToNode(to: gameViewController.playerCharacter.modelNode)
        
        
        
        gameViewController.interactButton.isHidden = (distance > 5)
        
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
        let cubeNode = SCNNode()
        cubeNode.geometry = SCNBox(width: 1, height: 1, length: 10, chamferRadius: 0)
        cubeNode.name = "cube"
        cubeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        cubeNode.position = SCNVector3(x: 20, y: 1, z: 1)
        
        cubeNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.interactable.rawValue
        cubeNode.physicsBody!.contactTestBitMask = SolariumCollisionBitMask.player.rawValue
        cubeNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.ground.rawValue
        
        return cubeNode
    }
}
