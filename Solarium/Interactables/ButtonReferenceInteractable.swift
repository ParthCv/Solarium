//
//  ButtonReferenceInteractable.swift
//  Solarium
//
//  Created by Kyle Ng on 2024-03-05.
//

import SceneKit

class ButtonReferenceInteractable: SCNNode, Interactable {

    var node: SCNNode!
    
    var target: Door!
    
    var displayText: String = "Pick up"
    
    var priority: TriggerPriority = .mediumPriority
    
    var triggerVolume: Float = 5.0
    
    init(displayText: String, priority: TriggerPriority, triggerVolume: Float, target : Door, node: SCNNode) {
        super.init()
        self.displayText = displayText
        self.priority = priority
        self.triggerVolume = triggerVolume
        self.target = target
        self.node = node
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doInteract(_ sender: JKButtonNode) {
        print("Consumed")
        //sceneTemplate?.interactableEntities.
        target.openDoor()
        self.triggerVolume = 0.0
    }
}

