//
//  SceneChangeInteractable.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-05.
//

import SceneKit

class SceneChangeInteractable: SCNNode, Interactable {
    
    var displayText: String = "Interact"
    
    var priority: TriggerPriority = .highPriority
    
    var triggerVolume: Float = 3.0
    
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
        print("change Scene")
    }
    
}
