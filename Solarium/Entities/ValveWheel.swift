//
//  ValveWheel.swift
//  Solarium
//
//  Created by Vinod Bandla on 2024-04-16.
//

import SceneKit

class ValveWheel {
    // Node for the model
    var modelNode: SCNNode!
    
    var animationController = AnimationController()
    
    var animations: Dictionary<String, SCNAnimationPlayer> = Dictionary<String, SCNAnimationPlayer>()
    
    init(node: SCNNode, openState: Bool?){
        //get the root node from the scene with all the child nodes
        self.modelNode = node;
        //load the door animations on the door node
        self.animations = animationController.loadAnimations(animationFile: "ValveWheelAnimations")
        for (key, anim) in animations{
            anim.animation.isRemovedOnCompletion = false
            self.modelNode.addAnimationPlayer(anim, forKey: key)
        }
    }
    
    func spinWheel(){
        animationController.playAnimation(animations: self.animations, key: "spin")
    }

}
