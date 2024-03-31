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
    
    var titleLabel:               UILabel!
    var titleStartButton:         UIButton!
    var titleBackgroundImage:     UIImageView!
    var pauseButton:              UIButton!

    var sceneDictionary: [SceneEnum : SceneTemplate] = [:]
    
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.sceneDictionary = [
            .SCN0: s04_Tree(gvc: self),
            .SCN1: s01_TutorialScene(gvc: self),
            .SCN2: s02_Agriculture(gvc: self),
            .SCN3: s03_Lights(gvc: self),
            .SCN4: s04_Tree(gvc: self)
        ]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sceneDictionary = [
            .SCN0: s04_Tree(gvc: self),
            .SCN1: s01_TutorialScene(gvc: self),
            .SCN2: s02_Agriculture(gvc: self),
            .SCN3: s03_Lights(gvc: self),
            .SCN4: s04_Tree(gvc: self)
        ]
    }
    
    @objc func startButtonTapped() {
        print("startBtnPressed")
        
        //Clean up main menu elements
        titleLabel.isHidden = true
        titleStartButton.isHidden = true
        titleBackgroundImage.isHidden = true
        pauseButton.isHidden = false
        
    }
    
    @objc func pauseButtonTapped() {
        print("pauseBtnPressed")
        
        titleLabel.isHidden = false
        titleStartButton.isHidden = false
        titleBackgroundImage.isHidden = false
        pauseButton.isHidden = true
        
    }
    
    func setupTitleScreen() {
        
        print("x")
        
        // Create a new background image view
        titleBackgroundImage = UIImageView(image: UIImage(named: "art.scnassets/TitleScreenBackground.png"))
        titleBackgroundImage.frame = gameView.bounds
        titleBackgroundImage.contentMode = .scaleAspectFill // Adjust content mode as needed
        gameView.addSubview(titleBackgroundImage)
        gameView.sendSubviewToBack(titleBackgroundImage) // Send it to the back so it's behind other UI elements

        // Set up main menu UI
        titleLabel = UILabel()
        titleLabel.text = "Main Menu"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.frame = CGRect(x: 0, y: 100, width: view.frame.width, height: 50)
        gameView.addSubview(titleLabel)
        
        titleStartButton = UIButton(type: .system)
        titleStartButton.setTitle("Start Game", for: .normal)
        titleStartButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20) // Custom font size
        titleStartButton.setTitleColor(.white, for: .normal) // Set font color to white
        titleStartButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        titleStartButton.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        gameView.addSubview(titleStartButton)
        
        let buttonSize: CGFloat = 25
        pauseButton = UIButton(type: .system)
        pauseButton.setTitle("⏸", for: .normal)
        pauseButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        pauseButton.frame = CGRect(x: view.frame.width - buttonSize - 20, y: 20, width: buttonSize, height: buttonSize)
        pauseButton.backgroundColor = UIColor.gray
        pauseButton.layer.cornerRadius = buttonSize / 2
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
        view.addSubview(pauseButton)
        pauseButton.isHidden = true
        
    }
        
    // Awake function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitleScreen()
        
        // DO NOT MOVE THIS FUNCTION, SHIT WILL BREAK
        switchScene(currScn: nil, nextScn: SceneEnum.SCN4)
        
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
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
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
        switchScene(currScn: currentScene, nextScn: .SCN2)
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

extension GameViewController{
//    func switchScene(currScn: SceneTemplate?, nextScn: SceneEnum){
//        SceneController.singleton.switchScene(self.gameView, currScn: currScn, nextScn: nextScn)
//    }
    
    // Function to switch scenes
    @MainActor
    func switchScene(currScn: SceneTemplate?, nextScn: SceneEnum) {
        // Find the scene to load
        if let sceneTemplate = sceneDictionary[nextScn]{
            // Load the next scene fisrt
            sceneTemplate.load()
            
            // Switch and transition the scene
            gameView.present(sceneTemplate.scene, with: .fade(withDuration: 0.5), incomingPointOfView: nil, completionHandler: nil)
            
            // Unload the old scene
            if (currScn != nil) { currScn?.unload()}
            currentScene =  sceneTemplate
        }
    }
}

class SharedData {
    static let sharedData = SharedData()
    var playerSpawnIndex = 0
}
