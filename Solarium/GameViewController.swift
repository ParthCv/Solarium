//
//  GameViewController.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-06.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    var gameView: GameView{
        return view as! GameView
    }

    var mainScene: SCNScene!
    var touch: UITouch?
    var direction = SIMD2<Float>(0, 0)
    let playerCharacter: PlayerCharacter = PlayerCharacter(modelFilePath: "art.scnassets/wife.scn", nodeName: "PlayerNode_Wife")
    var mainCamera: SCNNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tr
        mainScene = createMainScene()
        let sceneView = gameView
        sceneView.scene = mainScene
        sceneView.delegate = self
        sceneView.isPlaying = true
        
        //sceneView.showsStatistics = true
        //sceneView.allowsCameraControl = true
        
        sceneView.debugOptions = [
            SCNDebugOptions.showPhysicsShapes
            //,SCNDebugOptions.renderAsWireframe
        ]
        mainScene.physicsWorld.contactDelegate = self
                
        mainScene.rootNode.addChildNode(addAmbientLighting())
        
        mainScene.rootNode.addChildNode(createFloor())
        
        mainScene.rootNode.addChildNode(addCube())
        
        mainScene.rootNode.addChildNode(playerCharacter.loadPlayerCharacter(spawnPosition: SCNVector3(0, 0, 0)))
        
        mainScene.background.contents = UIImage(named: "art.scnassets/skybox.jpeg")
        
        mainCamera = mainScene.rootNode.childNode(withName: "mainCamera", recursively: true) ?? SCNNode()
        
        //print(sceneView.scene?.physicsWorld.contactDelegate)
        
    }
    
    func createMainScene() -> SCNScene {
        let mainScene = SCNScene(named: "art.scnassets/ParthModelSpawn.scn")!
        
        return mainScene
    }
    
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/grid.png"

        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        floorNode.physicsBody?.categoryBitMask = SolariumCollisionBitMask.ground.rawValue
        floorNode.physicsBody?.collisionBitMask = 1 | SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.interactable.rawValue
        
        return floorNode
    }
    
    func addAmbientLighting() -> SCNNode {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        
        return ambientLight
    }
    
    func addCube() -> SCNNode {
        let cubeNode = SCNNode()
        cubeNode.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)))
        cubeNode.position = SCNVector3(x: 2, y: 3, z: 3)
        
        cubeNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.interactable.rawValue
        //cubeNode.physicsBody!.contactTestBitMask = PhysicsCategory.player.rawValue
        cubeNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.player.rawValue | SolariumCollisionBitMask.ground.rawValue | 1
        
        return cubeNode
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        switch contact.nodeB.physicsBody!.categoryBitMask {
            
            case SolariumCollisionBitMask.player.rawValue:
                print("Hit a cube")
                            
            default:
                break;
        }
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        
    }
    
    @objc
    func renderer(_ renderer: SCNRenderer, updateAtTime time: TimeInterval) {
        playerCharacter.playerController.movePlayerInXAndYDirection(changeInX: direction.x, changeInZ: direction.y)
        playerCharacter.playerController.repositionCameraToFollowPlayer(mainCamera: mainCamera)
    }
    

}

extension GameViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touch = touches.first
        if let touch = touch {
            readDpadInput(touch)
        }
        gameView.updateJoystick(direction)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touch {
            readDpadInput(touch)
        }
        gameView.updateJoystick(direction)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Reset the movement axis
        direction = SIMD2<Float>.zero
        gameView.updateJoystick(direction)
    }
    
    func readDpadInput(_ touch: UITouch){
        let touchLocation = touch.location(in: self.view)
        
        if gameView.virtualDPad().contains(touchLocation) {
            
            let middleOfCircleX = gameView.virtualDPad().origin.x + gameView.dpadRadius
            let middleOfCircleY = gameView.virtualDPad().origin.y + gameView.dpadRadius
            let lengthOfX = Float(touchLocation.x - middleOfCircleX)
            let lengthOfY = Float(touchLocation.y - middleOfCircleY)
            //print("Length", lengthOfX, lengthOfY)
            direction = SIMD2<Float>(x: lengthOfX, y: lengthOfY)
            
            let degree = calculateTilt()
            //print("Degree",degree)
        }
    }
    
    private func calculateTilt() -> Float{
        if(pow(direction.x ,2) + pow(direction.y,2) < pow(Float(gameView.deadZoneRadius), 2)){
            return 0
        }
        let normalized = normalize(direction)
        let degree = atan2(normalized.x, normalized.y)
        return degree
    }
}


