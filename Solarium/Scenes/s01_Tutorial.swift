//
//  01_TutorialScene.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-04.
//

import SceneKit

class s01_TutorialScene: SceneTemplate{
    var interactableEntities: [Interactable]
    
    var deletableNodes: [SCNNode]
    
    var scene: SCNScene!
    
    var isUnloadable: Bool = true
    
     init() {
        scene = SCNScene(named: "scenes.scnassets/s01_Tutorial.scn")
         interactableEntities = []
         deletableNodes = []
    }
    
    func load() {
        scene.rootNode.addChildNode(addAmbientLighting())
        scene.rootNode.addChildNode(addSceneChangeCube())
        // Setup collision of scene objects
        //scene.rootNode.addChildNode(createFloor())
        setUpWallCollision()
        setUpButtonCollision(buttonName: "i0_SM_Button")
        setUpDoorCollision(doorName: "i0_SK_Door")
        setUpButtonInteract(buttonName: "i0_SM_Button", doorName: "i0_SK_Door")
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
    
    func update(gameViewController: GameViewController) {
        deleteNodes()
        triggerInteractables(gameViewController: gameViewController)
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
    
    func physicsWorldDidEnd(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    func triggerInteractables(gameViewController: GameViewController) {
        var highestPriority: TriggerPriority? = nil
        var interactableObject: Interactable? = nil
        
        for interactableEntity in interactableEntities {
            if interactableEntity.distanceToNode(to: gameViewController.playerCharacter.modelNode) < interactableEntity.triggerVolume && highestPriority ?? TriggerPriority.noPriority < interactableEntity.priority {
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
        floorNode.physicsBody?.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.interactable.rawValue | 1
        
        return floorNode
    }
    
    func setUpWallCollision(){
        
        let modelNode = scene.rootNode.childNode(withName: "RoomBase", recursively: true)!
        
        let body = SCNPhysicsBodyType.static
        let shape = SCNPhysicsShape(node: modelNode, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
        modelNode.physicsBody = SCNPhysicsBody(type: body, shape: shape)

        // Player own bitmask
        modelNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.ground.rawValue
        
        // Bitmask of things the player will collide with
        modelNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue |
        SolariumCollisionBitMask.interactable.rawValue | 1
    
    }
    
    func setUpButtonCollision(buttonName: String){
        let modelNode = scene.rootNode.childNode(withName: buttonName, recursively: true)!
        
        //let collisionBox  = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        
        modelNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil
//                                                SCNPhysicsShape(geometry: collisionBox, options: nil)
        )
        
        //modelNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        modelNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.interactable.rawValue
        modelNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue |
        SolariumCollisionBitMask.ground.rawValue | 1
        
    }
    
    func setUpDoorCollision(doorName: String){
        let modelNode = scene.rootNode.childNode(withName: doorName, recursively: true)!
       
        //let collisionBox  = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        
        modelNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil
//                                                SCNPhysicsShape(geometry: collisionBox, options: nil)
        )
        
        //modelNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        modelNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.interactable.rawValue
        modelNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue |
        SolariumCollisionBitMask.ground.rawValue | 1
    }
    
    func setUpButtonInteract(buttonName: String, doorName: String){
        let buttonNode = scene.rootNode.childNode(withName: buttonName, recursively: true)!
        let doorNode = scene.rootNode.childNode(withName: doorName, recursively: true)!
        
        let door = Door(doorNode: doorNode)
        
        let buttonTrigger = ButtonReferenceInteractable(displayText: "Press Button", priority: .mediumPriority, triggerVolume: 5, target: door, node: buttonNode)
        
        buttonTrigger.position = buttonNode.position
        
        self.interactableEntities.append(buttonTrigger)
    }
    
    func addSceneChangeCube() -> SCNNode {
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

class Door{
    
    var node:SCNNode
    
    init(doorNode: SCNNode){
        node = doorNode
    }
    func openDoor(){
        //open door
        print("Open Door")
    }
    
}
