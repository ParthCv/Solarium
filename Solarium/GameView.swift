//
//  GameView.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-02-07.
//
// Source: https://martinlasek.medium.com/tutorial-how-to-implement-a-d-pad-7e8b6047badf

import SceneKit
import SpriteKit

final class GameView: SCNView, SCNSceneRendererDelegate {

    let joystickName = "JoysticNub"
    let dpadRadius: CGFloat = 75
    let joystickRadius: CGFloat = 25
    let deadZoneRadius: CGFloat = 25
    var joystickOrigin = CGPoint.zero
    var joyStick: SKNode!
    
    var titleBackgroundImage:     UIImageView!
    
    var isPaused: Bool = false
    var pauseMenuBtn: JKButtonNode!
    var pauseMenuResumeBtn: JKButtonNode!
    
    var mainMenuImageNode: SKSpriteNode!
    var mainMenuStartBtn: JKButtonNode!
    
    //TODO: Should Move this to GameViewController 
    let interactButton = JKButtonNode(title: "Interact", state: .normal)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()
    }
    

    
    func setupTitleScreen() {
        
        let pauseBtnOffset: CGFloat = min(self.bounds.width, self.bounds.height) * 0.05 // Calculate the offset based on the screen size
        let buttonSize: CGFloat = 20
        pauseMenuBtn = JKButtonNode(title: "⏸", state: .normal)
        pauseMenuBtn.setBackgroundsForState(normal: "art.scnassets/TextButtonNormal.png",highlighted: "", disabled: "")
        pauseMenuBtn.size = CGSizeMake(buttonSize,buttonSize)
        pauseMenuBtn.canPlaySounds = false
        pauseMenuBtn.setPropertiesForTitle(fontName: "Monofur", size: 20, color: UIColor.red)
        pauseMenuBtn.position.x = self.bounds.width - buttonSize - pauseBtnOffset
        pauseMenuBtn.position.y = self.bounds.height - buttonSize - pauseBtnOffset
        pauseMenuBtn.isHidden = true
        pauseMenuBtn.action = pauseBtnCallback
        
        pauseMenuResumeBtn = JKButtonNode(title: "Resume", state: .normal)
        pauseMenuResumeBtn.setBackgroundsForState(normal: "art.scnassets/TextButtonNormal.png",highlighted: "", disabled: "")
        pauseMenuResumeBtn.size = CGSizeMake(200,50)
        pauseMenuResumeBtn.canPlaySounds = false
        pauseMenuResumeBtn.setPropertiesForTitle(fontName: "Monofur", size: 20, color: UIColor.red)
        pauseMenuResumeBtn.position.x = self.bounds.width / 2
        pauseMenuResumeBtn.position.y = (self.bounds.height / 2) - 100
        pauseMenuResumeBtn.isHidden = true
        pauseMenuResumeBtn.action = resumeBtnCallback
        
        let mmImage = UIImage(named: "art.scnassets/TitleScreenBackground.png")!
        let mmTexture = SKTexture(image: mmImage)
        mainMenuImageNode = SKSpriteNode(texture: mmTexture)
        mainMenuImageNode.size.width = self.bounds.size.width
        mainMenuImageNode.size.height = self.bounds.size.height
        mainMenuImageNode.position.x = self.bounds.width / 2
        mainMenuImageNode.position.y = self.bounds.height / 2
        mainMenuImageNode.isHidden = false
        
        mainMenuStartBtn = JKButtonNode(title: "Start Game", state: .normal)
        mainMenuStartBtn.setBackgroundsForState(normal: "art.scnassets/TextButtonNormal.png",highlighted: "", disabled: "")
        mainMenuStartBtn.size = CGSizeMake(200,50)
        mainMenuStartBtn.canPlaySounds = false
        mainMenuStartBtn.setPropertiesForTitle(fontName: "Monofur", size: 20, color: UIColor.yellow)
        mainMenuStartBtn.position.x = self.bounds.width / 2
        mainMenuStartBtn.position.y = (self.bounds.height / 2) - 100
        mainMenuStartBtn.action = startBtnCallback
        mainMenuStartBtn.isHidden = false
        
        self.overlaySKScene?.addChild(mainMenuImageNode)
        self.overlaySKScene?.addChild(mainMenuStartBtn)
        self.overlaySKScene?.addChild(pauseMenuBtn)
        self.overlaySKScene?.addChild(pauseMenuResumeBtn)
    }
    
    func startBtnCallback(_ sender: JKButtonNode) {
        sender.isHidden = true
        mainMenuImageNode.isHidden = true
        pauseMenuBtn.isHidden = false
        
        isPaused = false
        self.scene!.isPaused = false
    }
    
    func pauseBtnCallback(_ sender: JKButtonNode) {
        sender.isHidden = true
        joyStick.isHidden = true
        pauseMenuResumeBtn.isHidden = false
        
        // Pause player physics manually, dealing with situation where paused while on moving platforms
        let player = scene?.rootNode.childNode(withName: "PlayerNode_Wife", recursively: true)!
        player?.physicsBody?.velocity = SCNVector3Zero
        player?.physicsBody?.angularVelocity = SCNVector4Zero
        
        isPaused = true
        self.scene!.isPaused = true
    }
    
    func resumeBtnCallback(_ sender: JKButtonNode) {
        sender.isHidden = true
        joyStick.isHidden = false
        pauseMenuBtn.isHidden = false
        
        isPaused = false
        self.scene!.isPaused = false
    }
    
    
    
    func setup2DOverlay() {
        let viewHeight = bounds.size.height
        let viewWidth = bounds.size.width
        let sceneSize = CGSize(width: viewWidth, height: viewHeight)
        let skScene = SKScene(size: sceneSize)
        skScene.scaleMode = .resizeFill
        
        let dpadShape = SKShapeNode(circleOfRadius: dpadRadius)
        dpadShape.strokeColor = .white
        dpadShape.lineWidth = 2.0
        dpadShape.position.x = dpadShape.frame.size.width / 2 + 10
        dpadShape.position.y = dpadShape.frame.size.height / 2 + 10
        
        let joystickShape = SKShapeNode(circleOfRadius: joystickRadius)
        joystickShape.strokeColor = .white
        joystickShape.fillColor = .white
        joystickShape.lineWidth = 2.0
        joystickShape.name = joystickName
        joystickShape.position.x = dpadShape.position.x
        joystickShape.position.y = dpadShape.position.y
        joystickOrigin = joystickShape.position
        
        
        interactButton.action = interactButtonClick
        interactButton.setBackgroundsForState(normal: "art.scnassets/TextButtonNormal.png",highlighted: "", disabled: "")

        interactButton.canPlaySounds = false
        interactButton.setPropertiesForTitle(fontName: "Monofur", size: 20, color: UIColor.green)
        interactButton.position.x = 750
        interactButton.position.y = 100
        interactButton.isHidden = true
        
        joyStick = SKNode()
        joyStick.addChild(dpadShape)
        joyStick.addChild(joystickShape)
        
        skScene.addChild(joyStick)
        skScene.isUserInteractionEnabled = false
        overlaySKScene = skScene
    }
    
    func interactButtonClick(_ sender: JKButtonNode) {
        print("pressed")
    }
    
    func virtualDPad() -> CGRect {
        var vDPad = CGRect(x: 0, y: 0, width: 150, height: 150)
        vDPad.origin.y = bounds.size.height - vDPad.size.height - 10
        vDPad.origin.x = 10
        return vDPad
    }
    
    func updateJoystick(_ direction:SIMD2<Float>){
        if let joystick = overlaySKScene?.childNode(withName: ".//"+joystickName){
            var position = CGPointZero
            //Clamp to within dpadRadius
            if(pow(direction.x ,2) + pow(direction.y,2) < pow(Float(dpadRadius), 2)){
                position.x = CGFloat(direction.x)
                position.y = CGFloat(direction.y)
            }else{
                let normalized = normalize(direction)
                position.x = CGFloat(normalized.x) * dpadRadius
                position.y = CGFloat(normalized.y) * dpadRadius
            }
            joystick.position.x = joystickOrigin.x + position.x
            joystick.position.y = joystickOrigin.y - position.y
        }
    }
}
