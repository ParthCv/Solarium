//
//  PickUpInteractable.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-14.
//

import SceneKit


//class PickUpInteractable: Interactable {
//    var doInteractDelegate: (() -> Void)?
//    
//    var mesh: SCNGeometry = SCNGeometry()
//    
//    var sceneTemplate : SceneTemplate?
//    
//    var displayText: String?
//    
//    var pickUpText: String = "Pick Up"
//    
//    var dropText: String = "Drop Ball"
//    
//    var nodeToPickUp: SCNNode
//    
//    var isPickable: Bool
//    
//    var pickUpType: PickUpType
//    
//    var priority: TriggerPriority = .mediumPriority
//    
//    var triggerVolume: Float = 5.0
//    
//    init(mesh: SCNGeometry, nodeToPickUp: SCNNode, pickUpType: PickUpType, sceneTemplate: SceneTemplate, triggerVolume: Float?, priority:  TriggerPriority?) {
//        self.nodeToPickUp = nodeToPickUp
//        if (!nodeToPickUp.isHidden) {
//            self.isPickable = true
//            self.displayText = self.pickUpText
//        } else {
//            self.isPickable = false
//            self.displayText = self.dropText
//        }
//        if (priority != nil) {
//            self.priority = priority!
//        }
//        if (triggerVolume != nil) {
//            self.triggerVolume = triggerVolume!
//        }
//        self.sceneTemplate = sceneTemplate
//        self.mesh = mesh
//        self.pickUpType = pickUpType
//        super.init()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func doInteract(_ sender: JKButtonNode) {
//        print("Consumed")
//        sceneTemplate?.deletableNodes.append(self)
//        //sceneTemplate?.interactableEntities.
//        self.triggerVolume = 0.0
//    }
//}
