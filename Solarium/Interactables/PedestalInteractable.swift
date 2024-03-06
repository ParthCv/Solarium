//
//  ConsumableInteractables.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-05.
//

import SceneKit

class PedestalInteractable: SCNNode, Interactable {

    var node: SCNNode = SCNNode()
    
    var sceneTemplate : SceneTemplate?
    
    var displayText: String = "Pick up"
    
    var priority: TriggerPriority = .mediumPriority
    
    var triggerVolume: Float = 5.0
    
    init(displayText: String, priority: TriggerPriority, triggerVolume: Float, sceneTemp : SceneTemplate, node: SCNNode) {
        super.init()
        self.displayText = displayText
        self.priority = priority
        self.triggerVolume = triggerVolume
        self.sceneTemplate = sceneTemp
        self.node = node
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doInteract(_ sender: JKButtonNode) {
        print("Consumed")
        sceneTemplate?.deletableNodes.append(self)
        //sceneTemplate?.interactableEntities.
        self.triggerVolume = 0.0
    }
}
