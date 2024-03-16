
import SceneKit

class PlayerCharacter {
    
    // The model nesh
    var mesh: SCNGeometry = SCNGeometry()
    
    // key -> animationa name, value -> anmiation file
    var animations: Dictionary<String, SCNAnimationPlayer> = Dictionary<String, SCNAnimationPlayer>()
    
    // Animation controller for the player
    let animationController: AnimationController = AnimationController()
    
    // File with animation files and their names [hard coded fiole name rn]
    let animationFile = "DummyAnimations"
    
    // File path for the model
    var modelFilePath: String
    
    // Node for the model
    var modelNode: SCNNode!
    
    // Name of the player node
    var nodeName: String
    
    // physics body on the scene
    var physicsBody: SCNPhysicsBody = SCNPhysicsBody()
    
    // controller for the player
    var playerController: PlayerController!
    
    var isHoldingSmthg: Bool = false
    
    init(modelFilePath: String, nodeName: String) {
        self.modelFilePath = modelFilePath
        self.nodeName = nodeName
        //self.playerController = PlayerController(playerCharacterNode: modelNode, playerCharacter: self)
    }
    
    // load the player from file and setup the properties
    func loadPlayerCharacter(spawnPosition: SCNVector3 = SCNVector3Zero, modelScale: SCNVector3 = SCNVector3(x: 1, y: 1, z: 1)) -> SCNNode {
        // Load the scene with the model
        let modelNode_Player = SCNScene(named: modelFilePath)!

        //Update the properties again
        
        
        //get the root node from the scene with all the child nodes
        self.modelNode = modelNode_Player.rootNode.childNodes[0]
        self.modelNode.position = spawnPosition
        self.modelNode.presentation.position = spawnPosition
        self.modelNode.name = nodeName
        self.mesh = modelNode.geometry ?? SCNGeometry()
        self.playerController = PlayerController(playerCharacterNode: modelNode, playerCharacter: self)
        
        // Add a physics body to the player
//        self.modelNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil
//        )
//        
//        self.modelNode.physicsBody?.friction 
//        = 0.99
        
        //set the collision params
        setCollisionBitMask()
        
        // Read the anmations file and add it to the player
        self.animations = animationController.loadAnimations(animationFile: animationFile)
        for (key, anim) in animations{
            self.modelNode.addAnimationPlayer(anim, forKey: key)
        }
        
        playIdleAnimation()
        return modelNode
    }
    
    // Animation funtions
    
    func playIdleAnimation() {
        self.animationController.playAnimation(animations: self.animations, key: "idle")
    }
    
    func playWalkAnimation() {
        self.animationController.playAnimation(animations: self.animations, key: "walk")
    }

    // Set the bit mask for player
    private func setCollisionBitMask() {
        // Player own bitmask
        //modelNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.player.rawValue
        
        // Bitmask of things the player will collide with
//        modelNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.ground.rawValue | SolariumCollisionBitMask.interactable.rawValue
    }
    
}
