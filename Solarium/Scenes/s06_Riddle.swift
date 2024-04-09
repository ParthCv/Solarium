//
//  s06_Riddle.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-04-01.
//
//
//import SceneKit
//
//class s06_Riddle: SceneTemplate {
//    
//    required init(gvc: GameViewController) {
//        super.init(gvc: gvc)
//        scene = SCNScene(named: "scenes.scnassets/s06_Riddle.scn")
//    }
//    
//    override func load() {
//        scene.rootNode.addChildNode(createFloor())
//        super.load()
//        
//        //All the ball
//        let b1 = scene.rootNode.childNode(withName: "P1_5_0_Ball1", recursively: true)!
//        let b2 = scene.rootNode.childNode(withName: "P1_6_0_Ball2", recursively: true)!
//        let b3 = scene.rootNode.childNode(withName: "P1_7_0_Ball3", recursively: true)!
//        let b4 = scene.rootNode.childNode(withName: "P1_8_0_Ball4", recursively: true)!
//        let b5 = scene.rootNode.childNode(withName: "P1_9_0_Ball5", recursively: true)!
//        
//        //All the Pedstals
//        let p1 = scene.rootNode.childNode(withName: "P1_0_2_Ped", recursively: true)!
//        let p2 = scene.rootNode.childNode(withName: "P1_1_2_Ped", recursively: true)!
//        let p3 = scene.rootNode.childNode(withName: "P1_2_2_Ped", recursively: true)!
//        let p4 = scene.rootNode.childNode(withName: "P1_3_2_Ped", recursively: true)!
//        let p5 = scene.rootNode.childNode(withName: "P1_4_2_Ped", recursively: true)!
//        
//        //        pF - b2
//        //        p1 - nil
//        //        p2 - b5
//        //        p3 - b4
//        //        p4 - b1
//        //        p5 - b3
//        
//        setUpBallOnPedestal(pedestal: p1, ball: b1)
//        setUpBallOnPedestal(pedestal: p2, ball: b2)
//        setUpBallOnPedestal(pedestal: p3, ball: b3)
//        setUpBallOnPedestal(pedestal: p4, ball: b4)
//        setUpBallOnPedestal(pedestal: p5, ball: b5)
//        
//    }
//    
//    override func unload() {
//        if isUnloadable {
//            scene.rootNode.enumerateChildNodes { (node, stop) in
//                    node.removeFromParentNode()
//                }
//        }
//    }
//    
//    override func gameInit() {
//        let pedPuzzle :Puzzle = Puzzle6(puzzleID: 1, trackedEntities: [Int: Interactable](), sceneTemplate: self)
//        puzzles.append(pedPuzzle)
//        
//        for puzzle in puzzles {
//            getPuzzleTrackedEntities(puzzleObj: puzzle)
//        }
//        
//        currentPuzzle = 1
//    }
//}
//
//
//extension s06_Riddle {
//    
//    func setUpBallOnPedestal(pedestal: SCNNode, ball: SCNNode) {
//        let batteryPos = pedestal.childNode(withName: "BatteryRoot", recursively: true)!
//        batteryPos.addChildNode(ball)
//        ball.worldPosition = batteryPos.worldPosition
//    }
//    
//}
