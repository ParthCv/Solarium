//
//  Interactables.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-04.
//
import SceneKit

enum TriggerPriority: Int, Comparable {
    case noPriority, lowPriority, mediumPriority, highPriority
    
    static func < (lhs: TriggerPriority, rhs: TriggerPriority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

class Interactable {
    var node: SCNNode
    
    // Priority of the Interactable
    var priority: TriggerPriority
    
    // Area in which the event gets triggerd
    var triggerVolume: Float?
    
    // Text on the button that get displayed on the button
    var displayText: String?
    
    var doInteractDelegate: (() -> Void)?
    
    init(node: SCNNode, priority: TriggerPriority) {
        self.node = node
        self.priority = priority
        triggerVolume = 5
        displayText = nil
        doInteractDelegate = nil
    }
        
    // Innteract function that is happens on the click, override this.
    func doInteract(_ sender: JKButtonNode) {
        doInteractDelegate!()
    }
}
