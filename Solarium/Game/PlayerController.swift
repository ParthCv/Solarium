import SceneKit

class PlayerController {
    
    var playerCharacterNode: SCNNode
    
    var movementUpdateSpeed: TimeInterval = 1.5
    
    init(playerCharacterNode: SCNNode) {
        self.playerCharacterNode = playerCharacterNode
    }
    
    func movePlayerInXAndYDirection(changeInX: Float, changeInZ: Float) {
        let currentX = playerCharacterNode.position.x
        let currentZ = playerCharacterNode.position.z
        let newPos = SCNVector3(x: currentX + changeInX/2, y: 0, z: currentZ + changeInZ/2)
        let action = SCNAction.move(to: newPos, duration: movementUpdateSpeed)
        
        playerCharacterNode.runAction(action)
    }
    
    func repositionCameraToFollowPlayer(mainCamera: SCNNode) {
        let cameraDamping: Float = 0.3
        let playerPosition = playerCharacterNode.position
        
        let targetPosition = SCNVector3(x: playerPosition.x, y: 15.0, z: playerPosition.z + 15.0)
        
        var cameraPosition: SCNVector3 = mainCamera.position
        
        let cameraXPos = cameraPosition.x * (1.0 - cameraDamping) + targetPosition.x * cameraDamping
        let cameraYPos = cameraPosition.y * (1.0 - cameraDamping) + targetPosition.y * cameraDamping
        let cameraZPos = cameraPosition.z * (1.0 - cameraDamping) + targetPosition.z * cameraDamping
        
        cameraPosition = SCNVector3(cameraXPos, cameraYPos, cameraZPos)
        mainCamera.position = cameraPosition
        
    }
}
