import SceneKit

enum PlayerState{
    case IDLE, WALKING
}

class PlayerController {
    
    var playerCharacterNode: SCNNode
    
    var movementUpdateSpeed: TimeInterval = 1.5
    
    var playerCharacter: PlayerCharacter!
    var playerState:PlayerState = PlayerState.IDLE
    
    init(playerCharacterNode: SCNNode, playerCharacter: PlayerCharacter) {
        self.playerCharacterNode = playerCharacterNode
        self.playerCharacter = playerCharacter
    }
    
    func movePlayerInXAndYDirection(changeInX: Float, changeInZ: Float) {
        if(changeInX == 0 && changeInZ == 0){
            if (playerState != PlayerState.IDLE) {
                setPlayerState(PlayerState.IDLE)
                playerCharacterNode.removeAllActions()
                playerCharacter.playIdleAnimation()             
            }
            return
        }
        
        if(playerState != PlayerState.WALKING) {
            setPlayerState(PlayerState.WALKING)
            playerCharacter.playWalkAnimation()
        }
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
    
    func getPlayerState() -> PlayerState{
        return playerState
    }
    
    func setPlayerState(_ state:PlayerState){
        playerState = state
    }
}
