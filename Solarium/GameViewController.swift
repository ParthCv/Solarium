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
    var mainScene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tr
        mainScene = createMainScene()
        let sceneView = self.view as! SCNView
        sceneView.scene = mainScene
        
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        
        
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
        let mainScene = SCNScene(named: "art.scnassets/parthTestScene.scn")!
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

