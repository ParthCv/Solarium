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

protocol Interactable: SCNNode {
    var mesh : SCNGeometry { get }
    
    // Priority of the Interactable
    var priority: TriggerPriority { get }
    
    // Area in which the event gets triggerd
    var triggerVolume: Float { get }
    
    // Text on the button that get displayed on the button
    var displayText: String { get }
    
    // Innteract function that is happens on the click
    func doInteract(_ sender: JKButtonNode)
    
}
