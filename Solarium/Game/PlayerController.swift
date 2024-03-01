import SceneKit

class PlayerController {
    
    var playerCharacterNode: SCNNode
    
    let movementUpdateSpeed: TimeInterval = 1.5
    
    let forceDampingFactor: Float = 90
    
    let cameraOffset: Float = 15
    
    init(playerCharacterNode: SCNNode) {
        self.playerCharacterNode = playerCharacterNode
    }
    
    func movePlayerInXAndYDirection(changeInX: Float, changeInZ: Float, rotAngle: Float) {
        // Calculate movement direction and movement speed
        let currentX = playerCharacterNode.position.x
        let currentZ = playerCharacterNode.position.z
        let newPos = SCNVector3(x: currentX + changeInX/2, y: 0, z: currentZ + changeInZ/2)
        let action = SCNAction.move(to: newPos, duration: movementUpdateSpeed)

                
        // Adjust the rotation angle to account for camera's orientation (-45 Euler in X axis)
        let adjustedAngle = rotAngle + Float.pi / 4   // Assuming camera has -45 degrees. (pi=180; 180/4 = 45)
        
        let rotationAngle = CGFloat(adjustedAngle) - CGFloat.pi / 2 // subtract CGFloat.Pi / 2 to convert Radians into a CGFloat
        let rotationAction = SCNAction.rotateTo(x: 0, y: rotationAngle, z: 0, duration: 0.1)
        
        playerCharacterNode.runAction(rotationAction)


        playerCharacterNode.physicsBody?.applyForce(SCNVector3(changeInX/forceDampingFactor, 0, changeInZ/forceDampingFactor), asImpulse: false)
        
        //reset the node position to the physcis body
        playerCharacterNode.position = playerCharacterNode.presentation.worldPosition
        
        //rest the transformations
        playerCharacterNode.physicsBody?.resetTransform()

    }
    
    func repositionCameraToFollowPlayer(mainCamera: SCNNode) {
        let cameraDamping: Float = 0.3
        let playerPosition = playerCharacterNode.position
        
        let targetPosition = SCNVector3(x: playerPosition.x, y: cameraOffset, z: playerPosition.z + cameraOffset)
        
        var cameraPosition: SCNVector3 = mainCamera.position
        
        let cameraXPos = cameraPosition.x * (1.0 - cameraDamping) + targetPosition.x * cameraDamping
        let cameraYPos = cameraPosition.y * (1.0 - cameraDamping) + targetPosition.y * cameraDamping
        let cameraZPos = cameraPosition.z * (1.0 - cameraDamping) + targetPosition.z * cameraDamping
        
        cameraPosition = SCNVector3(cameraXPos, cameraYPos, cameraZPos)
        mainCamera.position = cameraPosition
        
    }
}
