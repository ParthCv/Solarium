//
//  SceneChangeInteractable.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-05.
//

import SceneKit

class SceneChangeInteractable: Interactable{
    var targetScene: SceneEnum
    var targetSpawnPoint: Int
    
    init(node: SCNNode, priority: TriggerPriority, displayText: String?, targetScene: SceneEnum, targetSpawnPoint: Int) {
        self.targetScene = targetScene
        self.targetSpawnPoint = targetSpawnPoint
        super.init(node: node, priority: priority, displayText: displayText)
    }
}
