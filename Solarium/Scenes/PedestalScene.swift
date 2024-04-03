//
//  PedestalScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-14.
//

/**
 
 JUST A TEST CLASS NOT USED ANYMORE
 
 */

import SceneKit

class PedestalScene: SceneTemplate {
    required init(gvc: GameViewController) {
        super.init(gvc: gvc)
        scene = SCNScene(named: "scenes.scnassets/parthPedestalScene.scn")
        deletableNodes = []
        puzzles = []
        currentPuzzle = 0
        playerCharacter = PlayerCharacter(modelFilePath: "art.scnassets/SM_ModelTester_collider_on_head.scn", nodeName: "PlayerNode_Wife")
        mainCamera = SCNNode()
    }
    
    override func load() {
        scene.rootNode.addChildNode(createFloor())
        super.load()
        setUpPedestal()
    }
    
    override func gameInit() {
        let pedPuzzle :Puzzle = PuzzlePedestalTest(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(pedPuzzle)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
        
        currentPuzzle = 0
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
        deletableNodes.append(floorNode)
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
