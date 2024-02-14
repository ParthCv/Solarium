//
//  AnimationController.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-02-13.
//

import SceneKit
import QuartzCore

class AnimationController {
    
    func loadAnimations(animationFile:String) -> Dictionary<String, CAAnimation> {
        var animations = Dictionary<String,CAAnimation>()
        if let path = Bundle.main.path(forResource: animationFile, ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let jsonData = try Data(contentsOf: url)
                
                if let animationList = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    // try to read out a string array
                    for (key, value) in animationList{
                        print(key, value)
                        animations[key] = loadAnimation(sceneName: value as! String, extensionName: "")
                    }
                    //print(animations)
                    // loadAnimation for each animation pair
                    //store into array/list of CAAnimation
                }
            }
            catch {
                print("Error: \(error)")
            }
        }
        return animations
    }
    
    func loadAnimation(sceneName: String, extensionName: String) -> CAAnimation? {
        // source of .dae with animation
        guard let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: extensionName) else{
            return nil
        }
        
        let sceneSource = SCNSceneSource(url: sceneURL, options: nil)
        for key in sceneSource?.identifiersOfEntries(withClass: CAAnimation.self) ?? [] {
            guard let animationObj = sceneSource?.entryWithIdentifier(key,
                                                                      withClass: CAAnimation.self) else {
                continue
            }
            if animationObj.isKind(of: CAAnimationGroup.self) {
                
                animationObj.repeatCount = .infinity
                animationObj.fadeInDuration = CGFloat(0)
                animationObj.fadeOutDuration = CGFloat(0.0)
                
                // play animation in target .dae node
                //playAnimation(animation: animationObj, node: targetNode)
                
                return animationObj
                
            }
        }
        
        return nil
    }
    
    func playAnimation(animation: CAAnimation, node: SCNNode) {
        
        let player = SCNAnimationPlayer.init(animation: SCNAnimation.init(caAnimation: animation))
        
        node.addAnimationPlayer(player, forKey: "myAnimation")
        
        player.play()
        
    }
}
