//
//  GateDoor.swift
//  Solarium
//
//  Created by Vinod Bandla on 2024-04-16.
//

import SceneKit

class GateDoor:Door {
    
    override init(node: SCNNode, openState: Bool?){
        
        super.init(node: node, openState: openState)
        //get the root node from the scene with all the child nodes
        self.modelNode = node;
        //load the door animations on the door node
        self.animations = animationController.loadAnimations(animationFile: "GateDoorAnimations")
        for (key, anim) in animations{
            anim.animation.isRemovedOnCompletion = false
            self.modelNode.addAnimationPlayer(anim, forKey: key)
        }
        isOpen = openState ?? false
        if isOpen { openDoor() }
    }
    
}

class SecurityDoor:Door {
    
    override init(node: SCNNode, openState: Bool?){
        
        super.init(node: node, openState: openState)
        //get the root node from the scene with all the child nodes
        self.modelNode = node;
        //load the door animations on the door node
        self.animations = animationController.loadAnimations(animationFile: "SecurityDoorAnimations")
        for (key, anim) in animations{
            anim.animation.isRemovedOnCompletion = false
            self.modelNode.addAnimationPlayer(anim, forKey: key)
        }
        isOpen = openState ?? false
        if isOpen { openDoor() }
    }
    
}

class PipeDoor:Door {
    
    override init(node: SCNNode, openState: Bool?){
        
        super.init(node: node, openState: openState)
        //get the root node from the scene with all the child nodes
        self.modelNode = node;
        //load the door animations on the door node
        self.animations = animationController.loadAnimations(animationFile: "PipeDoorAnimations")
        for (key, anim) in animations{
            anim.animation.isRemovedOnCompletion = false
            self.modelNode.addAnimationPlayer(anim, forKey: key)
        }
        isOpen = openState ?? false
        if isOpen { openDoor() }
    }
    
}
