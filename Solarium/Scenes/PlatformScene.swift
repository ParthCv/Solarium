//
//  PlatformScene.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-27.
//

//import SceneKit
//
///**
// 
// JUST A TEST CLASS NOT USED ANYMORE
// 
// */
//
//class PlatformScene: SceneTemplate {
//
//    
//    required init(gvc: GameViewController) {
//        super.init(gvc: gvc)
//        scene = SCNScene(named: "scenes.scnassets/parthPlatformScene.scn")
//        deletableNodes = []
//        puzzles = []
//        currentPuzzle = 0
//        playerCharacter = PlayerCharacter(nodeName: "PlayerNode_Wife")
//        mainCamera = SCNNode()
//    }
//    
//    override func load() {
//        scene.rootNode.addChildNode(createFloor())
//        super.load()
//        setUpPlatform()
//    }
//    
//    override func gameInit() {
//        let pedPuzzle :Puzzle = PuzzleMovingPlatformTest(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
//        puzzles.append(pedPuzzle)
//        
//        for puzzle in puzzles {
//            getPuzzleTrackedEntities(puzzleObj: puzzle)
//        }
//        
//        currentPuzzle = 0
//    }
//}
//
//
//extension PlatformScene {
//    
//    func setUpPlatform() {
//        // Make the button child of the platform so it moves with it
//        let upButtonNode = self.scene.rootNode.childNode(withName: "P0_1_2_PlatformButton", recursively: true)!
//        
//        let platformNode = self.scene.rootNode.childNode(withName: "P0_0_0_Platform", recursively: true)!
//        
//        let btnRoot = platformNode.childNodes[0]
//        let curBtnWolrdPos = upButtonNode.worldPosition
//        platformNode.addChildNode(upButtonNode)
//        upButtonNode.worldPosition = curBtnWolrdPos
//        btnRoot.physicsBody?.resetTransform()
//        
//    }
//    
//}
