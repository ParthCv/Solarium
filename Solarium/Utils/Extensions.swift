//
//  Extensions.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-03-04.
//

import SceneKit
import SpriteKit

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

extension UIImage {

    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

func +(left:SCNVector3, right:SCNVector3) -> SCNVector3 {
    
    return SCNVector3(left.x + right.x, left.y + right.y, left.z + right.z)
}

func -(left:SCNVector3, right:SCNVector3) -> SCNVector3 {
    return SCNVector3(left.x - right.x, left.y - right.y, left.z - right.z)
}

func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect) {

   // Determine the font scaling factor that should let the label text fit in the given rectangle.
   let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)

   // Change the fontSize.
   //labelNode.fontSize *= scalingFactor

   // Optionally move the SKLabelNode to the center of the rectangle.
   labelNode.position = CGPoint(x: rect.midX, y: rect.midY - labelNode.frame.height / 2.0)
}
