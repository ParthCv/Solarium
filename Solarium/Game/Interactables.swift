//
//  Interactables.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-04.
//
import SceneKit

enum TriggerPriority {
    case lowPriority, mediumPriority, highPriority
}

protocol Interactables: SCNNode {
    
    // Priority of the Interactable
    var priority: TriggerPriority { get }
    
    // Area in which the event gets triggerd
    var triggerVolume: Float { get }
    
    // Text on the button that get displayed on the 
    var displayText: String { get }
    
    // Innteract function that is happens on the click
    func doInteract(_ sender: JKButtonNode)
    
}
