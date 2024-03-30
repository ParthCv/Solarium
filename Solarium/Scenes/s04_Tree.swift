//
//  s04_PlatformPuzzle.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-28.
//

import SceneKit

class s04_Tree: SceneTemplate {
    
    required init(gvc: GameViewController) {
        super.init(gvc: gvc)
        scene = SCNScene(named: "scenes.scnassets/Puzzle4.scn")
    }
    
    override func load() {
        scene.rootNode.addChildNode(createFloor())
        super.load()
    }
    
    override func gameInit() {
        let pedPuzzle :Puzzle = PuzzlePedestalTest(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        //puzzles.append(pedPuzzle)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
        
        //currentPuzzle = puzzles[0]
    }
}


extension s04_Tree{
    
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
