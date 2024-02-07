//
//  GameViewController.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-06.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    var gameView: GameView{
        return view as! GameView
    }
    
    var mainScene: SCNScene!
    var touch: UITouch?
    var direction = simd_float2(0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tr
        mainScene = createMainScene()
        let sceneView = gameView
        sceneView.scene = mainScene
        
        sceneView.showsStatistics = true
        //sceneView.allowsCameraControl = true
        
        
        mainScene!.rootNode.addChildNode(addAmbientLighting())
        
        mainScene!.rootNode.addChildNode(createFloor())
        
        mainScene.background.contents = UIImage(named: "art.scnassets/skybox.jpeg")
        
        let cameraNode = mainScene.rootNode.childNode(withName: "mainCamera", recursively: true)
        //cameraNode?.position = SCNVector3(50, 0, -20)
        
        let wifeNode = mainScene.rootNode.childNode(withName: "wife", recursively: true)
        
        if wifeNode == nil {
            print("fuk")
        }
        
    }
    
    
    
    func createMainScene() -> SCNScene {
        let mainScene = SCNScene(named: "art.scnassets/kyleTestScene.scn")!
        return mainScene
    }
    
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/dessert.jpeg"
        
        return floorNode
    }
    
    func addAmbientLighting() -> SCNNode {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        
        return ambientLight
    }
    
}

extension GameViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {    if let touch = touch {
        
        let touchLocation = touch.location(in: self.view)
        if gameView.virtualDPad().contains(touchLocation) {
            let middleOfCircleX = gameView.virtualDPad().origin.x + 75
            let middleOfCircleY = gameView.virtualDPad().origin.y + 75
            let lengthOfX = Float(touchLocation.x - middleOfCircleX)
            let lengthOfY = Float(touchLocation.y - middleOfCircleY)
            direction = simd_float2(x: lengthOfX, y: lengthOfY)
            direction = normalize(direction)
            let degree = atan2(direction.x, direction.y)
            print(degree)
        }
    }
    }
}

