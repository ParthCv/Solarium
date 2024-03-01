
import SceneKit

class PlayerCharacter {
    
    var mesh: SCNGeometry = SCNGeometry()
    
    var animations: Dictionary<String, SCNAnimationPlayer> = Dictionary<String, SCNAnimationPlayer>()
    let animationController: AnimationController = AnimationController()
    let animationFile = "DummyAnimations"
    
    var modelFilePath: String
    
    var modelNode: SCNNode = SCNNode()
    
    var collider: SCNNode = SCNNode()
    
    var nodeName: String
    
    var physicsBody: SCNPhysicsBody = SCNPhysicsBody()
    
    // MARK: Initialization
    var playerController: PlayerController!
    
    init(modelFilePath: String, nodeName: String) {
        self.modelFilePath = modelFilePath
        self.nodeName = nodeName
        self.playerController = PlayerController(playerCharacterNode: modelNode, playerCharacter: self)
    }
    
    func loadPlayerCharacter(spawnPosition: SCNVector3 = SCNVector3Zero, modelScale: SCNVector3 = SCNVector3(x: 1, y: 1, z: 1)) -> SCNNode {
        let modelNode_Player = SCNScene(named: modelFilePath)!

        //Update the properties again
        self.modelNode = modelNode_Player.rootNode.childNodes[0]
        self.modelNode.position = spawnPosition
        self.modelNode.name = nodeName
        self.mesh = modelNode.geometry ?? SCNGeometry()
        self.playerController = PlayerController(playerCharacterNode: modelNode)
        
        let collisionBox = 
                            //SCNCapsule(capRadius: 1, height: 1)
                            SCNBox(width: 1, height: 1, length: 1, chamferRadius: 1)
        self.modelNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape:
                                                    SCNPhysicsShape(geometry: collisionBox, options: nil)
        )
        
        self.modelNode.physicsBody?.friction = 0.75
        
        //set the collision params
        setCollisionBitMask()
        
        
        self.animations = animationController.loadAnimations(animationFile: animationFile)
        for (key, anim) in animations{
            self.modelNode.addAnimationPlayer(anim, forKey: key)
        }
        
        //self.animationController.loadAnimation(sceneName: "art.scnassets/wifeIdleAnim.dae", extensionName: "", targetNode: modelNode_Player)
        playIdleAnimation()
        return modelNode
    }
    
    func playIdleAnimation() {
        self.animationController.playAnimation(animations: self.animations, key: "idle")
    }
    
    func playWalkAnimation() {
        self.animationController.playAnimation(animations: self.animations, key: "walk")
    }
    
    
    private func loadModelFromFile(fileName:String, fileExtension:String) -> SCNReferenceNode {
        let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        let refNode = SCNReferenceNode(url: url!)
        refNode?.load()
        return refNode!
    }

private func setCollisionBitMask() {
        modelNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.player.rawValue
        modelNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.interactable.rawValue | SolariumCollisionBitMask.ground.rawValue | 1
    }
    
}
