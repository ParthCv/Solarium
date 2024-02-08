//
//  GameView.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-02-07.
//
// Source: https://martinlasek.medium.com/tutorial-how-to-implement-a-d-pad-7e8b6047badf

import SceneKit
import SpriteKit/// Is used in Main.storyboard
/// under Identity Inspector
final class GameView: SCNView {
    let joystickName = "JoysticNub"
    let dpadRadius: CGFloat = 75
    let joystickRadius: CGFloat = 25
    var joystickOrigin = CGPoint.zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()
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
        
        let joyStick = SKNode()
        joyStick.addChild(dpadShape)
        joyStick.addChild(joystickShape)
        
        //        skScene.addChild(dpadShape)
        //        skScene.addChild(joystickShape)
        skScene.addChild(joyStick)
        skScene.isUserInteractionEnabled = false
        overlaySKScene = skScene
    }
    
    func virtualDPad() -> CGRect {
        var vDPad = CGRect(x: 0, y: 0, width: 150, height: 150)
        vDPad.origin.y = bounds.size.height - vDPad.size.height - 10
        vDPad.origin.x = 10
        return vDPad
    }
    
    func updateJoystick(_ direction:SIMD2<Float>){
        if let joystick = overlaySKScene?.childNode(withName: ".//"+joystickName){
            print(direction)
            joystick.position.x = joystickOrigin.x + CGFloat(direction.x) * dpadRadius
            joystick.position.y = joystickOrigin.y + CGFloat(direction.y) * dpadRadius
        }
      
    }
}
