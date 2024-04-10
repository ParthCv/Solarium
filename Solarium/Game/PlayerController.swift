import SceneKit

// Player states
// Right now only used for animations
enum PlayerState{
    case IDLE, WALKING
}

class PlayerController {
    
    // node that includes the player mesh
    var playerCharacterNode: SCNNode
    
    let defaultPlayerSpeed: Float = 15.0
    
    let forceDampingFactor: Float = 90
    
    //let cameraOffset: Float = 30
    
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

        playerCharacterNode.position = playerCharacterNode.presentation.worldPosition

        playerCharacterNode.position = SCNVector3(
            playerCharacterNode.position.x + (changeInX * defaultPlayerSpeed * Float(deltaTime)),
            playerCharacterNode.position.y,
            playerCharacterNode.position.z + (changeInZ * defaultPlayerSpeed * Float(deltaTime))
        );

    }
    
    // handle idle and walking animation
    func handleMovementAnimation (changeInX: Float, changeInZ: Float) {
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

    }
    
    // make the camera follow the player
    func repositionCameraToFollowPlayer(mainCamera: SCNNode) {
        // damping facto for the lerp of the camera
        let cameraDamping: Float = 0.9
        let playerPosition = playerCharacterNode.position
        
        let cameraOffset = SharedData.sharedData.cameraOffset
        // Calculate the position of the target position of the camera
        let targetPosition = SCNVector3(x: playerPosition.x, y: playerPosition.y + cameraOffset.offsetY, z: playerPosition.z + cameraOffset.offsetZ)
        
        var cameraPosition: SCNVector3 = mainCamera.position
        
        // lerp the posiotion of the camera
        let cameraXPos = cameraPosition.x * (1.0 - cameraDamping) + targetPosition.x * cameraDamping
        let cameraYPos = cameraPosition.y * (1.0 - cameraDamping) + targetPosition.y * cameraDamping
        let cameraZPos = cameraPosition.z * (1.0 - cameraDamping) + targetPosition.z * cameraDamping
        
        // set the position of the camera
        cameraPosition = SCNVector3(cameraXPos, cameraYPos, cameraZPos)
        mainCamera.eulerAngles.x = cameraOffset.camRotationX
        
        mainCamera.position = cameraPosition
        mainCamera.look(at: playerCharacterNode.position) //Camera has rotation

    }
    
    // Setter and getter for the player state
    
    func getPlayerState() -> PlayerState{
        return playerState
    }
    
    func setPlayerState(_ state:PlayerState){
        playerState = state
    }
}
