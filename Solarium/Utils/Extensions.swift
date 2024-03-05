//
//  Extensions.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-04.
//

import SceneKit

extension SCNNode {
    func distanceToNode(to: SCNNode) -> Float {
        let toNodeRenderPosition = self.presentation.worldPosition
        let fromNodeRenderPosition = to.presentation.worldPosition
        
        //Convert to GLKVector3
        let glkToVector = SCNVector3ToGLKVector3(toNodeRenderPosition)
        let glkFromVector = SCNVector3ToGLKVector3(fromNodeRenderPosition)
        
        let distanceBetweenNode = GLKVector3Distance(glkToVector, glkFromVector)
        
        return distanceBetweenNode
    }

}
