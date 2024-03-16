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
    var dPadDirectionInPixels = SIMD2<Float>(0, 0)
    var normalizedInputDirection = SIMD2<Float>(0, 0);
    
    // Rotation for player from the d-pad
    var degree: Float = 0

    // The current scene as SceneTemplate
    var currentScene: SceneTemplate?
    
    let interactButton = JKButtonNode(title: "Interact", state: .normal)
    
    var lastTickTime: TimeInterval = 0.0
    
    // Awake function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize and load the current scene
        currentScene = SceneController.singleton.switchScene(gameView, currScn: nil, nextScn: SceneEnum.SCN0)
        
        gameView.isPlaying = true
        // Need to directly cast as GameView for Render Delegate
        gameView.delegate = self
        
        //Degub Options
        gameView.debugOptions = [
            SCNDebugOptions.showPhysicsShapes
        ]
        
        setUpInteractButton()
        
        gameView.overlaySKScene?.addChild(interactButton)
        
        // Physics Delegate
        currentScene?.scene!.physicsWorld.contactDelegate = self
        
        // Perform Solarium Game Init Logic
        currentScene?.gameInit()
    }
    
    // Physics Loops
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        currentScene?.physicsWorldDidBegin(world, contact: contact, gameViewController: self)
        
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        
    }

    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        currentScene?.physicsWorldDidEnd(world, contact: contact, gameViewController: self)
    }
    
    // Rendering Loop
    @objc
    func renderer(_ renderer: SCNRenderer, updateAtTime time: TimeInterval) {
        currentScene?.update(gameViewController: self, updateAtTime: time)
        lastTickTime = time;
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
        gameView.updateJoystick(dPadDirectionInPixels)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Read touch input
        if let touch = touch { 
            readDpadInput(touch)
        }
        gameView.updateJoystick(dPadDirectionInPixels)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Reset the movement axis
        dPadDirectionInPixels = SIMD2<Float>.zero
        normalizedInputDirection = SIMD2<Float>.zero
        gameView.updateJoystick(dPadDirectionInPixels)
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
            
            dPadDirectionInPixels = SIMD2<Float>(x: lengthOfX, y: lengthOfY)
            normalizedInputDirection = normalize(dPadDirectionInPixels)
            degree = calculateTilt()
        }
    }
    
    // roation for the d-pad
    private func calculateTilt() -> Float{
//        if(pow(dPadDirectionInPixels.x ,2) + pow(dPadDirectionInPixels.y,2) < pow(Float(gameView.deadZoneRadius), 2)){
//            return 0
//        }
        let normalized = normalize(dPadDirectionInPixels)
        let degree = atan2(normalized.x, normalized.y)
        return degree
    }
}

extension GameViewController {
    func interactButtonClick(_ sender: JKButtonNode) {
        currentScene = SceneController.singleton.switchScene(gameView, currScn: currentScene, nextScn: .SCN2)
    }
    
    func setUpInteractButton() {
        interactButton.setBackgroundsForState(normal: "art.scnassets/TextButtonNormal.png",highlighted: "", disabled: "")
        interactButton.canPlaySounds = false
        interactButton.setPropertiesForTitle(fontName: "Monofur", size: 20, color: UIColor.green)
        interactButton.position.x = 750
        interactButton.position.y = 100
        interactButton.isHidden = true
        interactButton.action = interactButtonClick(_:)
    }
}


