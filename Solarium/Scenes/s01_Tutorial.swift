//
//  01_TutorialScene.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-04.
//

import SceneKit

class s01_TutorialScene: SceneTemplate{
    var scene: SCNScene!
    
    var isUnloadable: Bool = true
    
     init() {
        scene = SCNScene(named: "art.scnassets/SolariumAlphaRooms.scn")
    }
    
    func load() {
        scene.rootNode.addChildNode(addAmbientLighting())
        // Setup collision of scene objects
        scene.rootNode.addChildNode(createFloor())
        setUpWallCollision()
        setUpButtonCollisionTest()
        // Init puzzles belonging to Scene
        // Get all child nodes per puzzle
        // Assign associated classes to nodes
    }
    
    func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
        }
    }
    
    func update() {
        
    }
    
    @MainActor func physicsWorldDidBegin(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        switch contact.nodeA.physicsBody!.categoryBitMask {
            
        case SolariumCollisionBitMask.interactable.rawValue:
            print("Hit a cube")
            gameViewController.currScn = SceneController.singleton.switchScene(gameViewController.gameView, currScn: gameViewController.currScn, nextScn: .SCN2)
            //Set player pos to scene entrance
            break
            
        default:
            break
        }
        
    }
    
    func physicsWorldDidEnd(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact) {
        
    }
    
    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact) {
        
    }

}

extension s01_TutorialScene {
    
    func addAmbientLighting() -> SCNNode {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        
        return ambientLight
    }
    
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grid.png"

        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        floorNode.physicsBody?.categoryBitMask = SolariumCollisionBitMask.ground.rawValue
        floorNode.physicsBody?.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.interactable.rawValue | SolariumCollisionBitMask.cube.rawValue | 1
        
        return floorNode
    }
    
    func setUpWallCollision(){
        let modelNode = scene.rootNode.childNode(withName: "RoomBase", recursively: true)!
        
        let collisionBox  = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        
        modelNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil
//                                                SCNPhysicsShape(geometry: collisionBox, options: nil)
        )
        // Player own bitmask
        modelNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.ground.rawValue
        
        // Bitmask of things the player will collide with
        modelNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue |
        SolariumCollisionBitMask.interactable.rawValue | 1
    
    }
    
    func setUpButtonCollisionTest(){
        let modelNode = scene.rootNode.childNode(withName: "SM_Button", recursively: true)!
        
        //let collisionBox  = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        
        modelNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil
//                                                SCNPhysicsShape(geometry: collisionBox, options: nil)
        )
        
        //modelNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        modelNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.interactable.rawValue
        modelNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue |
        SolariumCollisionBitMask.ground.rawValue | 1
    }
    
}
