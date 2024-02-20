//
//  AnimationController.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-02-13.
//

import SceneKit
import QuartzCore

class AnimationController {
    
    func loadAnimations(animationFile:String) -> Dictionary<String, SCNAnimationPlayer> {
        var animations = Dictionary<String,SCNAnimationPlayer>()
        if let path = Bundle.main.path(forResource: animationFile, ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let jsonData = try Data(contentsOf: url)
                
                if let animationList = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    // try to read out a string array
                    for (key, value) in animationList{
                        print(key, value)
                        animations[key] = loadAnimationPlayer(sceneName: value as! String, extensionName: "")
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
    
    func loadAnimationPlayer(sceneName: String, extensionName: String) -> SCNAnimationPlayer? {
        // source of .dae with animation
//        guard let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: extensionName) else{
//            return nil
//        }
//        
//        let sceneSource = SCNSceneSource(url: sceneURL, options: nil)
//        for key in sceneSource?.identifiersOfEntries(withClass: SCNAnimation.self) ?? [] {
//            guard let animationObj = sceneSource?.entryWithIdentifier(key,
//                                                                      withClass: CAAnimation.self) else {
//                continue
//            }
//            if animationObj.isKind(of: CAAnimationGroup.self) {
//                
//                animationObj.repeatCount = .infinity
//                animationObj.fadeInDuration = CGFloat(0)
//                animationObj.fadeOutDuration = CGFloat(0.0)
//                
//                // play animation in target .dae node
//                //playAnimation(animation: animationObj, node: targetNode)
//                
//                return animationObj
//                
//            }
//        }
        
        let scene = SCNScene(named: sceneName)
        var animationObj: SCNAnimationPlayer! = nil
        scene?.rootNode.enumerateChildNodes{(child, stop) in
            if !child.animationKeys.isEmpty{
                let animation = child.animationPlayer(forKey: child.animationKeys[0])!.animation
                stop.pointee = true
                animationObj = SCNAnimationPlayer(animation: animation)
            }
        }
        return animationObj
    }
    
    func playAnimation(animations: Dictionary<String, SCNAnimationPlayer>, key: String) {
        
        for (_, anim) in animations{
            anim.stop()
        }
        animations[key]?.play()
    }
}
 
