//
//  TeleportScene.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-26.
//

import SceneKit

class TeleportScene: SceneTemplate{
 
    override init() {
        super.init()
        scene = SCNScene(named: "scenes.scnassets/TeleportScene.scn")
        deletableNodes = []
        puzzles = []
        playerCharacter = PlayerCharacter(modelFilePath: "art.scnassets/SM_ModelTester.scn", nodeName: "PlayerNode_Wife")
        mainCamera = SCNNode()
    }
    
    
    override func load() {
        scene.rootNode.addChildNode(createFloor())
        // Add the player to the scene
        scene.rootNode.addChildNode(playerCharacter.loadPlayerCharacter(spawnPosition: SCNVector3(0, 10, 0)))
        
        // Add a camera to the scene
        mainCamera = scene.rootNode.childNode(withName: "mainCamera", recursively: true)!
        //              setUpPedestal()
    }
    
    override func unload() {
        if isUnloadable {
            scene.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
        }
    }
    
    override func gameInit() {
        let pedPuzzle :Puzzle = TeleportPuzzleTest(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(pedPuzzle)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
        
        currentPuzzle = 0
    }
      
    
}

extension TeleportScene {
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grid.png"
        
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        //        floorNode.physicsBody?.categoryBitMask = SolariumCollisionBitMask.ground.rawValue
        //        floorNode.physicsBody?.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.interactable.rawValue
        
        return floorNode
    }
}

class TeleportPuzzleTest: Puzzle{
    var statePuzzle = Array(repeating:false, count:3)
    
    // Function called when entities assigned
    override func linkEntitiesToPuzzleLogic(){
        trackedEntities[0]!.doInteractDelegate = teleportDelegateMaker(target: trackedEntities[1])
        trackedEntities[1]!.doInteractDelegate = teleportDelegateMaker(target: trackedEntities[0])
        trackedEntities[2]!.doInteractDelegate = teleportDelegateMaker(target: trackedEntities[3])
        trackedEntities[3]!.doInteractDelegate = teleportDelegateMaker(target: trackedEntities[2])
        
        trackedEntities[4]!.doInteractDelegate = stateButtonDelegateMaker(sets: [
            0: trackedEntities[7],
            1: trackedEntities[8]
        ])
        trackedEntities[5]!.doInteractDelegate = stateButtonDelegateMaker(sets: [
            0: trackedEntities[7],
            1: trackedEntities[8],
            2: trackedEntities[9]
        ])
        trackedEntities[6]!.doInteractDelegate = stateButtonDelegateMaker(sets: [
            1: trackedEntities[8],
            2: trackedEntities[9]
        ])
        trackedEntities[11]!.doInteractDelegate = Door(node: trackedEntities[12]!.node, openState: nil).toggleDoor
    }
    
    // Per Puzzle Check for Win condition
    override func checkPuzzleWinCon(){
        if (statePuzzle[0] && statePuzzle[1] && statePuzzle[2]) {
            print("Puzzle Complete")
            trackedEntities[10]!.node.eulerAngles.x = -90
            trackedEntities[4]!.doInteractDelegate = Interactable.defaultInteract
            trackedEntities[5]!.doInteractDelegate = Interactable.defaultInteract
            trackedEntities[6]!.doInteractDelegate = Interactable.defaultInteract
            self.solved = true
        }
    }
    
    func teleportDelegateMaker(target: Interactable?) -> () -> () {
        return {//Do teleport
            let player = self.sceneTemplate.playerCharacter.modelNode
            let moveAction = SCNAction.move(to: target!.node.position + SCNVector3(0,1,0), duration: 0)
            player?.runAction(moveAction)
        }
        
    }
    
    func stateButtonDelegateMaker(sets:[Int: Interactable?]) -> () -> (){
        return {
            for set in sets {
                self.statePuzzle[set.key] = !self.statePuzzle[set.key]
                set.value?.node.eulerAngles.x = self.statePuzzle[set.key] ? -90 : 0
            }
            self.checkPuzzleWinCon()
        }
    }
}
