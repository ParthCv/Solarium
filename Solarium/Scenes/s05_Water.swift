//
//  s05_Water.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-30.
//

import SceneKit

class s05_Water: SceneTemplate {
    
    required init(gvc: GameViewController) {
        super.init(gvc: gvc)
        scene = SCNScene(named: "scenes.scnassets/TowerOfHanoi.scn")
    }
    
    override func load() {
        scene.rootNode.addChildNode(createFloor())
        super.load()
    }
    
    override func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
        }
    }
    
    override func gameInit() {
//        let pedPuzzle :Puzzle = Puzzle4(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
//        puzzles.append(pedPuzzle)
//        
//        for puzzle in puzzles {
//            getPuzzleTrackedEntities(puzzleObj: puzzle)
//        }
//        
//        currentPuzzle = 0
    }
}


extension s05_Water {
    
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        let floor = SCNFloor()
        floor.reflectivity = 0.001
        floorNode.geometry = floor
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grid.png"
        
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        floorNode.physicsBody?.categoryBitMask = SolariumCollisionBitMask.ground.rawValue

        floorNode.physicsBody?.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.interactable.rawValue | 1
        deletableNodes.append(floorNode)
        return floorNode
    }
    
    func setUpButtonsOnPlatform() {
        let platformNode: SCNNode = scene.rootNode.childNode(withName: "P0_5_0_platform", recursively: true)!
        let upButtonNode: SCNNode = scene.rootNode.childNode(withName: "P0_6_2_up", recursively: true)!
        let btnRoot = platformNode.childNodes[0]
        let curBtnWolrdPos = upButtonNode.worldPosition
        platformNode.addChildNode(upButtonNode)
        upButtonNode.worldPosition = curBtnWolrdPos
        btnRoot.physicsBody?.resetTransform()
    }
    
    func setUpBallOnPedestal(pedestal: SCNNode, ball: SCNNode) {
        let batteryPos = pedestal.childNode(withName: "BatteryRoot", recursively: true)!
        batteryPos.addChildNode(ball)
        ball.worldPosition = batteryPos.worldPosition
    }
    
}
