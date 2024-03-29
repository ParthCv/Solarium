//
//  PlatformScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-27.
//

import SceneKit

class PlatformScene: SceneTemplate {

    
    override init() {
        super.init()
        scene = SCNScene(named: "scenes.scnassets/parthPlatformScene.scn")
        deletableNodes = []
        puzzles = []
        currentPuzzle = 0
        playerCharacter = PlayerCharacter(modelFilePath: "art.scnassets/SM_ModelTester_collider_on_head.scn", nodeName: "PlayerNode_Wife")
        mainCamera = SCNNode()
    }
    
    override func load() {
        scene.rootNode.addChildNode(createFloor())
        // Add the player to the scene
        scene.rootNode.addChildNode(playerCharacter.loadPlayerCharacter(spawnPosition: SCNVector3(0, 10, 0)))
        
        // Add a camera to the scene
        mainCamera = scene.rootNode.childNode(withName: "mainCamera", recursively: true)!
        setUpPlatform()
    }
    
    override func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
        }
    }
    
    override func gameInit() {
        let pedPuzzle :Puzzle = PuzzleMovingPlatformTest(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(pedPuzzle)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
        
        currentPuzzle = 0
    }
}


extension PlatformScene {
    
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grid.png"
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        floorNode.physicsBody?.categoryBitMask = SolariumCollisionBitMask.ground.rawValue
        floorNode.physicsBody?.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.interactable.rawValue | 1
        
        return floorNode
    }
    
    func setUpPlatform() {
        // Make the button child of the platform so it moves with it
        let buttonNode = self.scene.rootNode.childNode(withName: "P0_1_2_PlatformButton", recursively: true)
        
        let platformNode = self.scene.rootNode.childNode(withName: "P0_0_0_Platform", recursively: true)
        
        let btnRoot = platformNode!.childNodes[0]
        
        let buttonNodePos = btnRoot.worldPosition
        let buttonNodeScale = btnRoot.scale

        platformNode!.addChildNode(buttonNode!)
        
        btnRoot.scale = buttonNodeScale
        buttonNode?.worldPosition = buttonNodePos
        btnRoot.physicsBody!.resetTransform()
        print(btnRoot.presentation.worldPosition)
        
        //Move the platform to the start point
        let startPlatformEdge = self.scene.rootNode.childNode(withName: "P0_3_0_PlatformStart", recursively: true)
        
        let startPos = startPlatformEdge!.childNodes[1].worldPosition
        
        platformNode!.position = startPos
    }
    
}
