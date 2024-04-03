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
        
        setUpButtonsOnPlatform()
        
        //All the ball
        let b1 = scene.rootNode.childNode(withName: "P0_13_0_ball1", recursively: true)!
        let b2 = scene.rootNode.childNode(withName: "P0_14_0_ball2", recursively: true)!
        let b3 = scene.rootNode.childNode(withName: "P0_15_0_ball3", recursively: true)!
        let b4 = scene.rootNode.childNode(withName: "P0_16_0_ball4", recursively: true)!
        let b5 = scene.rootNode.childNode(withName: "P0_17_0_ball5", recursively: true)!
        
        //All the Pedstals
        let p0 = scene.rootNode.childNode(withName: "P0_7_2_pedestalBtm", recursively: true)!
        let p1 = scene.rootNode.childNode(withName: "P0_8_2_pedestalF1", recursively: true)!
        let p2 = scene.rootNode.childNode(withName: "P0_9_2_pedestalF2", recursively: true)!
        let p3 = scene.rootNode.childNode(withName: "P0_10_2_pedestalF3", recursively: true)!
        let p4 = scene.rootNode.childNode(withName: "P0_11_2_pedestalF4", recursively: true)!
        let p5 = scene.rootNode.childNode(withName: "P0_12_2_pedestalF5", recursively: true)!
        
        //        pF - b2
        //        p1 - nil
        //        p2 - b5
        //        p3 - b4
        //        p4 - b1
        //        p5 - b3
        setUpBallOnPedestal(pedestal: p0, ball: b2)
        setUpBallOnPedestal(pedestal: p2, ball: b5)
        setUpBallOnPedestal(pedestal: p3, ball: b4)
        setUpBallOnPedestal(pedestal: p4, ball: b1)
        setUpBallOnPedestal(pedestal: p5, ball: b3)
        
    }
    
    override func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
        }
    }
    
    override func gameInit() {
        let pedPuzzle :Puzzle = Puzzle4(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(pedPuzzle)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
        
        currentPuzzle = 0
    }
}


extension s04_Tree{
    
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
