//
//  s03_Lights.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-29.
//

import SceneKit

class s03_Lights: SceneTemplate{
    
    required init(gvc: GameViewController) {
        super.init(gvc: gvc)
        scene = SCNScene(named: "scenes.scnassets/s03_Lights.scn")
    }
    
    override func load() {
        scene.rootNode.addChildNode(addAmbientLighting())
        // Setup collision of scene objects
        scene.rootNode.addChildNode(createFloor())
        
        super.load()
        
        //Puzzle 0 setup
        
        setUpButtonsOnPlatform()
        
        //All the ball
        let puzzle1_ball1 = scene.rootNode.childNode(withName: "P0_13_0_ball1", recursively: true)!
        let puzzle1_ball2 = scene.rootNode.childNode(withName: "P0_14_0_ball2", recursively: true)!
        let puzzle1_ball3 = scene.rootNode.childNode(withName: "P0_15_0_ball3", recursively: true)!
        let puzzle1_ball4 = scene.rootNode.childNode(withName: "P0_16_0_ball4", recursively: true)!
        let puzzle1_ball5 = scene.rootNode.childNode(withName: "P0_17_0_ball5", recursively: true)!
        
        //All the Pedstals
        let puzzle1_ped0 = scene.rootNode.childNode(withName: "P0_7_2_pedestalBtm", recursively: true)!
//        let puzzle1_ped2 = scene.rootNode.childNode(withName: "P0_8_2_pedestalF1", recursively: true)!
        let puzzle1_ped3 = scene.rootNode.childNode(withName: "P0_9_2_pedestalF2", recursively: true)!
        let puzzle1_ped4 = scene.rootNode.childNode(withName: "P0_10_2_pedestalF3", recursively: true)!
        let puzzle1_ped5 = scene.rootNode.childNode(withName: "P0_11_2_pedestalF4", recursively: true)!
        let puzzle1_ped6 = scene.rootNode.childNode(withName: "P0_12_2_pedestalF5", recursively: true)!
        
        //        pF - b2
        //        p1 - nil
        //        p2 - b5
        //        p3 - b4
        //        p4 - b1
        //        p5 - b3
        setUpBallOnPedestal(pedestal: puzzle1_ped0, ball: puzzle1_ball2)
        setUpBallOnPedestal(pedestal: puzzle1_ped3, ball: puzzle1_ball5)
        setUpBallOnPedestal(pedestal: puzzle1_ped4, ball: puzzle1_ball4)
        setUpBallOnPedestal(pedestal: puzzle1_ped5, ball: puzzle1_ball1)
        setUpBallOnPedestal(pedestal: puzzle1_ped6, ball: puzzle1_ball3)
        
        //Puzzle 1 setup
        
        //All the ball
        let puzzle2_ball1 = scene.rootNode.childNode(withName: "P1_5_0_Ball1", recursively: true)!
        let puzzle2_ball2 = scene.rootNode.childNode(withName: "P1_6_0_Ball2", recursively: true)!
        let puzzle2_ball3 = scene.rootNode.childNode(withName: "P1_7_0_Ball3", recursively: true)!
        let puzzle2_ball4 = scene.rootNode.childNode(withName: "P1_8_0_Ball4", recursively: true)!
        let puzzle2_ball5 = scene.rootNode.childNode(withName: "P1_9_0_Ball5", recursively: true)!
        
        //All the Pedstals
        let puzzle2_ped0 = scene.rootNode.childNode(withName: "P1_0_2_Ped", recursively: true)!
        let puzzle2_ped1 = scene.rootNode.childNode(withName: "P1_1_2_Ped", recursively: true)!
        let puzzle2_ped2 = scene.rootNode.childNode(withName: "P1_2_2_Ped", recursively: true)!
        let puzzle2_ped3 = scene.rootNode.childNode(withName: "P1_3_2_Ped", recursively: true)!
        let puzzle2_ped4 = scene.rootNode.childNode(withName: "P1_4_2_Ped", recursively: true)!

        setUpBallOnPedestal(pedestal: puzzle2_ped0, ball: puzzle2_ball1)
        setUpBallOnPedestal(pedestal: puzzle2_ped1, ball: puzzle2_ball2)
        setUpBallOnPedestal(pedestal: puzzle2_ped2, ball: puzzle2_ball3)
        setUpBallOnPedestal(pedestal: puzzle2_ped3, ball: puzzle2_ball4)
        setUpBallOnPedestal(pedestal: puzzle2_ped4, ball: puzzle2_ball5)
    }
    
    override func gameInit() {
        let pedPuzzle :Puzzle = Puzzle4(puzzleID: 0, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(pedPuzzle)
        
        let riddlePuzzle :Puzzle = Puzzle6(puzzleID: 1, trackedEntities: [Int: Interactable](), sceneTemplate: self)
        puzzles.append(riddlePuzzle)
        
        for puzzle in puzzles {
            getPuzzleTrackedEntities(puzzleObj: puzzle)
        }
        
        currentPuzzle = 0
    }
    
}

extension s03_Lights {
    
    func setUpButtonsOnPlatform() {
        let platformNode: SCNNode = scene.rootNode.childNode(withName: "P0_5_0_Platform", recursively: true)!
        let upButtonNode: SCNNode = scene.rootNode.childNode(withName: "P0_6_2_up", recursively: true)!
        let downButtonNode: SCNNode = scene.rootNode.childNode(withName: "P0_19_2_Down", recursively: true)!
        let btnRoot = platformNode.childNodes[0]
        var curBtnWolrdPos = upButtonNode.worldPosition
        platformNode.addChildNode(upButtonNode)
        upButtonNode.worldPosition = curBtnWolrdPos
        
        curBtnWolrdPos = downButtonNode.worldPosition
        platformNode.addChildNode(downButtonNode)
        downButtonNode.worldPosition = curBtnWolrdPos
        btnRoot.physicsBody?.resetTransform()
    }
    
    func setUpBallOnPedestal(pedestal: SCNNode, ball: SCNNode) {
        let batteryPos = pedestal.childNode(withName: "BatteryRoot", recursively: true)!
        batteryPos.addChildNode(ball)
        ball.worldPosition = batteryPos.worldPosition
    }
    
}
