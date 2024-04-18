import SceneKit

// Player states
// Right now only used for animations
enum PlayerState{
    case IDLE, WALKING
}

class PlayerController {
    
    // node that includes the player mesh
    var playerCharacterNode: SCNNode
    
    // default player speed
    let defaultPlayerSpeed: Float = 15.0
    
    var playerCharacter: PlayerCharacter!
    
    var playerState:PlayerState = PlayerState.IDLE
    
    init(playerCharacterNode: SCNNode, playerCharacter: PlayerCharacter) {
        self.playerCharacterNode = playerCharacterNode
        self.playerCharacter = playerCharacter
    }
    
    func movePlayerInXAndYDirection(changeInX: Float, changeInZ: Float, rotAngle: Float, deltaTime: TimeInterval) {
        
        // animate player based on the change in the movemtn in x and z
        handleMovementAnimation(changeInX: changeInX, changeInZ: changeInZ)

        // rotate the player based on the rotation degree
        let rotationAction = SCNAction.rotateTo(x: 0, y: CGFloat(rotAngle), z: 0, duration: 0.0)
        playerCharacterNode.runAction(rotationAction)

        // Reset the player presentation node to the player node
        playerCharacterNode.position = playerCharacterNode.presentation.worldPosition

        // Move the player based on the change in x and z
        playerCharacterNode.position = SCNVector3(
            playerCharacterNode.position.x + (changeInX * defaultPlayerSpeed * Float(deltaTime)),
            playerCharacterNode.position.y,
            playerCharacterNode.position.z + (changeInZ * defaultPlayerSpeed * Float(deltaTime))
        );

    }
    
    // handle idle and walking animation
    func handleMovementAnimation (changeInX: Float, changeInZ: Float) {
        if(changeInX == 0 && changeInZ == 0){
            // if the player is not moving, play idle animation
            if (playerState != PlayerState.IDLE) {
                setPlayerState(PlayerState.IDLE)
                playerCharacterNode.removeAllActions()
                playerCharacter.playWalkToIdleAnimation()
                playerCharacter.playIdleAnimation()
            }
            return
        }
        // otherwise play walking animation        
        if(playerState != PlayerState.WALKING) {
            setPlayerState(PlayerState.WALKING)
            playerCharacter.playIdleToWalkAnimation()
            playerCharacter.playWalkAnimation()
        }

    }
    
    // make the camera follow the player
    func repositionCameraToFollowPlayer(mainCamera: SCNNode, deltaTime: TimeInterval) {
        // damping facto for the lerp of the camera
        let cameraDamping: Float = 0.01
        let playerPosition = playerCharacterNode.worldPosition
        
        let cameraOffset = SharedData.sharedData.cameraOffset
        // Calculate the position of the target position of the camera
        var targetPosition = SCNVector3(x: playerPosition.x, y: playerPosition.y + cameraOffset.offsetY, z: playerPosition.z + cameraOffset.offsetZ )
        var changeInPos = mainCamera.worldPosition - targetPosition
        
        // deltaTime time might me a big number, so we need to clamp it (Cuz of the rendering time at the start of the game))
        let scalar = (Float(deltaTime) > 1 ? cameraDamping : Float(deltaTime))

        // Lerp the position of the camera
        let lerpPos = mainCamera.worldPosition * (1.0 - scalar) + (targetPosition) * scalar        
        mainCamera.position = lerpPos

        // Lerp the rotation of the camera
        mainCamera.eulerAngles.x = mainCamera.eulerAngles.x * (1.0 - scalar) + (cameraOffset.camRotationX * Float.pi / 180) * scalar
    }
    
    // Setter and getter for the player state
    
    func getPlayerState() -> PlayerState{
        return playerState
    }
    
    func setPlayerState(_ state:PlayerState){
        playerState = state
    }
}
