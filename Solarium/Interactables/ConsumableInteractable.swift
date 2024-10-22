//
//  ConsumableInteractables.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-05.
//

/**
 
 CLASS NOT USED ANYMORE
 
 */

import SceneKit

class ConsumableInteractable: SCNNode {
    var doInteractDelegate: (() -> Void)?
    

    var mesh: SCNGeometry = SCNGeometry()    
    
    var sceneTemplate : SceneTemplate?
    
    var displayText: String = "Consume"
    
    var priority: TriggerPriority = .mediumPriority
    
    var triggerVolume: Float = 5.0
    
    init(displayText: String, priority: TriggerPriority, triggerVolume: Float, sceneTemp : SceneTemplate, mesh: SCNGeometry) {
        super.init()
        self.displayText = displayText
        self.priority = priority
        self.triggerVolume = triggerVolume
        self.sceneTemplate = sceneTemp
        self.mesh = mesh
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
