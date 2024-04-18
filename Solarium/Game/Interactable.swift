//
//  Interactables.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-04.
//
import SceneKit

// Enum for proorities for interactables
enum TriggerPriority: Int, Comparable, CaseIterable {
    case noPriority, lowPriority, mediumPriority, highPriority
    
    static func < (lhs: TriggerPriority, rhs: TriggerPriority) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// Class to represent entities that have action associated with them on interact
class Interactable {
    var node: SCNNode
    
    // Priority of the Interactable
    var priority: TriggerPriority
    
    // Area in which the event gets triggerd
    var triggerVolume: Float?
    
    // Text on the button that get displayed on the button
    var displayText: String?
    
    // Function pointer for the on press callback interact button
    @Published var doInteractDelegate: (() -> Void)?
    
    init(node: SCNNode, priority: TriggerPriority, displayText: String?) {
        self.node = node
        self.priority = priority
        triggerVolume = 5
        self.displayText = displayText
        doInteractDelegate = Interactable.defaultInteract
    }
    
    func setInteractDelegate(function: (()->Void)?) {
        self.doInteractDelegate = function
    }
        
    // Innteract function that is happens on the click, override this.
    func doInteract(_ sender: JKButtonNode) {
        doInteractDelegate!()
    }
    
    // Default Interact function
    static func defaultInteract(){
        //print("No interact callback setup!")
    }
}


