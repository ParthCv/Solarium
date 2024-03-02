//
//  GameViewController.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-06.
//

import UIKit
import QuartzCore
import SceneKit
import GameplayKit

class GameViewController: UIViewController, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    
    // Get the overlay view for the game
    var gameView: GameView {
        return view as! GameView
    }

    //Save the touch from the on screen taps
    var touch: UITouch?
    
    // Direction 2-D vector to save the input from the d-pad
    var direction = SIMD2<Float>(0, 0)
    
    // Rotation for player from the d-pad
    var degree: Float = 0
    
    // Player character object with all its properties
    let playerCharacter: PlayerCharacter = PlayerCharacter(modelFilePath: "art.scnassets/RASStatic.scn", nodeName: "PlayerNode_Wife")
    
    // Main camera in the scene
    var mainCamera: SCNNode = SCNNode()

    // The current scence o
    var currScn: SceneTemplate?
    
    // Awake function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the view
        let sceneView = gameView
        sceneView.delegate = self
        sceneView.isPlaying = true
        
        // Initialize and load the current scene
        currScn = SceneController.singleton.switchScene(sceneView, currScn: nil, nextScn: SceneEnum.SCN1)
        
        //sceneView.showsStatistics = true
        //sceneView.allowsCameraControl = true
        
        //Degub Options
        sceneView.debugOptions = [
            SCNDebugOptions.showPhysicsShapes
            //,SCNDebugOptions.renderAsWireframe
        ]
        
        // Setup the collision physics
        gameView.scene!.physicsWorld.contactDelegate = self
        
        // Add the player to the scene
        gameView.scene!.rootNode.addChildNode(playerCharacter.loadPlayerCharacter(spawnPosition: SCNVector3(0, 0, 0)))
        
        //gameView.scene!.background.contents = UIImage(named: "art.scnassets/skybox.jpeg")
        
        // Add a camera to the scene
        mainCamera = gameView.scene!.rootNode.childNode(withName: "mainCamera", recursively: true) ?? SCNNode()
    }
    
    // Physics Loops
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        currScn?.physicsWorldDidBegin(world, contact: contact, gameViewController: self)
        
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        
    }
    
    // Rendering Loop
    
    @objc
    func renderer(_ renderer: SCNRenderer, updateAtTime time: TimeInterval) {
        // Move and rotate the player from the inputs of the d-pad
        playerCharacter.playerController.movePlayerInXAndYDirection(changeInX: direction.x, changeInZ: direction.y, rotAngle: degree)
        
        // Make the camera follow the player
        playerCharacter.playerController.repositionCameraToFollowPlayer(mainCamera: mainCamera)
    }
    

}

// Touch gesture recognitions
extension GameViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Read touch input
        touch = touches.first
        if let touch = touch {
            readDpadInput(touch)
        }
        gameView.updateJoystick(direction)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Read touch input
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
    
    // Read d-pad input
    func readDpadInput(_ touch: UITouch){
        let touchLocation = touch.location(in: self.view)
        
        // Check if the touch is in the d-pad
        if gameView.virtualDPad().contains(touchLocation) {
            // Calculate the x and y directions
            let middleOfCircleX = gameView.virtualDPad().origin.x + gameView.dpadRadius
            let middleOfCircleY = gameView.virtualDPad().origin.y + gameView.dpadRadius
            let lengthOfX = Float(touchLocation.x - middleOfCircleX)
            let lengthOfY = Float(touchLocation.y - middleOfCircleY)
            
            direction = SIMD2<Float>(x: lengthOfX, y: lengthOfY)
            degree = calculateTilt()
        }
    }
    
    // roation for the d-pad
    private func calculateTilt() -> Float{
        if(pow(direction.x ,2) + pow(direction.y,2) < pow(Float(gameView.deadZoneRadius), 2)){
            return 0
        }
        let normalized = normalize(direction)
        let degree = atan2(normalized.x, normalized.y)
        return degree
    }
}


