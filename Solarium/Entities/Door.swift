//
//  Door.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-28.
//

import SceneKit

class Door {
    // Node for the model
    var modelNode: SCNNode!
    
    var animationController = AnimationController()
    
    var animations: Dictionary<String, SCNAnimationPlayer> = Dictionary<String, SCNAnimationPlayer>()
    
    // Flag to check if door is open
    var isOpen = false
    
    init(node: SCNNode, openState: Bool?){
        //get the root node from the scene with all the child nodes
        self.modelNode = node;
        //load the door animations on the door node
        self.animations = animationController.loadAnimations(animationFile: "DoorAnimations")
        for (key, anim) in animations{
            anim.animation.isRemovedOnCompletion = false
            self.modelNode.addAnimationPlayer(anim, forKey: key)
        }
        isOpen = openState ?? false
        if isOpen { openDoor() }
    }
    
    func toggleDoor(){
        isOpen = !isOpen
        isOpen ? openDoor() : closeDoor()
    }
    
    func openDoor(){
        animationController.playAnimation(animations: self.animations, key: "open")
    }
    func closeDoor(){
        animationController.playAnimation(animations: self.animations, key: "close")
    }
}
