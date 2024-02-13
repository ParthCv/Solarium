//
//  AnimationController.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-02-13.
//

import SceneKit
import QuartzCore

class AnimationController {
    
    
    func loadAnimation(sceneName: String, extensionName: String, targetNode: SCNNode) {
        
        // source of .dae with animation
        
        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: extensionName)
        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
        
        for key in sceneSource?.identifiersOfEntries(withClass: CAAnimation.self) ?? [] {
            
            if let animationObj = sceneSource?.entryWithIdentifier(key,
                                                                   withClass: CAAnimation.self) {
                
                if animationObj.isKind(of: CAAnimationGroup.self) {
                    
                    animationObj.repeatCount = .infinity
                    animationObj.fadeInDuration = CGFloat(0)
                    animationObj.fadeOutDuration = CGFloat(0.0)
                    
                    // play animation in target .dae node
                    playAnimation(animation: animationObj, node: targetNode)
                    
                    return
                    
                }
                
            }
            
        }
        
    }
    
    func playAnimation(animation: CAAnimation, node: SCNNode) {
        
        let player = SCNAnimationPlayer.init(animation: SCNAnimation.init(caAnimation: animation))
        
        node.addAnimationPlayer(player, forKey: "myAnimation")
        
        player.play()
        
    }
}
