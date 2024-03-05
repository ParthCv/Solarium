//
//  ConsumableInteractables.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-05.
//

import SceneKit

class ConsumableInteractable: SCNNode, Interactables {
    var displayText: String = "Consume"
    
    var priority: TriggerPriority = .mediumPriority
    
    var triggerVolume: Float = 5.0
    
    init(displayText: String, priority: TriggerPriority, triggerVolume: Float) {
        super.init()
        self.displayText = displayText
        self.priority = priority
        self.triggerVolume = triggerVolume
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doInteract(_ sender: JKButtonNode) {
        print("Consumed")
    }
}
