//
//  01_TutorialScene.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-04.
//

import SceneKit

class s01_TutorialScene: SceneTemplate{
    var puzzles: [Puzzle]
    var currentPuzzle: Puzzle?
    
    var deletableNodes: [SCNNode]
    
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
        triggerInteractables(gameViewController: gameViewController)
    }
    
    func physicsWorldDidEnd(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    func physicsWorldDidUpdate(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        
    }
    
    var scene: SCNScene!
    
    var isUnloadable: Bool = true
    
     init() {
        scene = SCNScene(named: "scenes.scnassets/SolariumAlphaRooms.scn")
         deletableNodes = []
         puzzles = []
         currentPuzzle = nil
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
    
    // TODO: Consider making this part of the Puzzle Class and making it static, remove it from SceneTemplate Class
    func getPuzzleTrackedEntities(puzzleObj: Puzzle) {
        var foundKeyValuePairs : [Int: Interactable] = [Int: Interactable]()

        scene.rootNode.childNodes(passingTest:  { (node, stop) -> Bool in
            if let name = node.name, name.range(of: "P\(puzzleObj.puzzleID)_", options: .regularExpression) != nil {
                let nameParts = name.components(separatedBy: "_")
                
                if nameParts.count >= 2, let interactableIndex = (nameParts[1].first), let intCast = Int(String(interactableIndex)) {
                    foundKeyValuePairs[intCast] = Interactable(node: node, priority: TriggerPriority.mediumPriority)
                }
                
                return true
            }
            
            return false;
        })
        
        puzzleObj.trackedEntities = foundKeyValuePairs
        puzzleObj.linkEntitiesToPuzzleLogic()
    }
    
    func gameInit() {
        var puzzle0 : Puzzle = Puzzle0(puzzleID: 0, trackedEntities: [Int: Interactable]())
        puzzles.append(puzzle0)
        
        var puzzle1 : Puzzle = Puzzle1(puzzleID: 1, trackedEntities: [Int: Interactable]())
        puzzles.append(puzzle1)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
        
        currentPuzzle = puzzles[0]
    }
    
    @MainActor func physicsWorldDidBegin(_ world: SCNPhysicsWorld, contact: SCNPhysicsContact, gameViewController: GameViewController) {
        switch contact.nodeA.physicsBody!.categoryBitMask {
            
        case SolariumCollisionBitMask.interactable.rawValue:
            print("Hit a cube")
            gameViewController.currentScene = SceneController.singleton.switchScene(gameViewController.gameView, currScn: gameViewController.currentScene, nextScn: .SCN2)
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
        
//        floorNode.physicsBody?.categoryBitMask = Int(SCNPhysicsCollisionCategory.static.rawValue)
//        floorNode.physicsBody?.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.interactable.rawValue
        
        return floorNode
    }
    
    func setUpWallCollision(){
        
        let modelNode = scene.rootNode.childNode(withName: "RoomBase", recursively: true)!
        
        let body = SCNPhysicsBodyType.static
        let shape = SCNPhysicsShape(node: modelNode, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
        modelNode.physicsBody = SCNPhysicsBody(type: body, shape: shape)
//
//        // Player own bitmask
//        modelNode.physicsBody!.categoryBitMask = Int(SCNPhysicsCollisionCategory.static.rawValue)
        
        // Bitmask of things the player will collide with
//        modelNode.physicsBody!.collisionBitMask
    
    }
    
    func setUpButtonCollisionTest(){
//        let modelNode = scene.rootNode.childNode(withName: "P0_0_Button", recursively: true)!
//        
//        //let collisionBox  = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
//        
//        modelNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil
////                                                SCNPhysicsShape(geometry: collisionBox, options: nil)
//        )
//        
//        //modelNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//        modelNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.interactable.rawValue
//        modelNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue |
//        SolariumCollisionBitMask.ground.rawValue | 1
    }
    
}
