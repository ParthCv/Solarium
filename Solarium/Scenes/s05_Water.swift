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
        
        let bigDrain = scene.rootNode.childNode(withName: "P0_0_0_BigDrain", recursively: true)!
        let midDrain = scene.rootNode.childNode(withName: "P0_1_0_MidDrain", recursively: true)!
        let smlDrain = scene.rootNode.childNode(withName: "P0_2_0_SmlDrain", recursively: true)!
        
        setUpDrainPosition(drain: bigDrain, pos: 1200)
        setUpDrainPosition(drain: midDrain, pos: 0)
        setUpDrainPosition(drain: smlDrain, pos: 0)
    }
    
    override func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                    node.removeFromParentNode()
                }
        }
    }
    
    override func gameInit() {
        let pedPuzzle :Puzzle = Puzzle3(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(pedPuzzle)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
        
        currentPuzzle = 0
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

    
    func setUpDrainPosition(drain: SCNNode, pos: Int) {
        let nodeToMove = drain.childNode(withName: "cylinder", recursively: true)!
        let posStr = String(pos)
        let newPosNod = drain.childNode(withName: posStr, recursively: true)!
        nodeToMove.worldPosition = newPosNod.worldPosition
    }
    
}
