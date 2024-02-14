import SceneKit

class PlayerCharacter {
        
    var mesh: SCNGeometry = SCNGeometry()
    
    var animations: [CAAnimation] = []
    
    var modelFilePath: String
    
    var modelNode: SCNNode = SCNNode()
    
    var nodeName: String
    
    var playerController: PlayerController
    
    var physicsBody: SCNPhysicsBody = SCNPhysicsBody()
    
    init(modelFilePath: String, nodeName: String) {
        self.modelFilePath = modelFilePath
        self.nodeName = nodeName
        self.playerController = PlayerController(playerCharacterNode: modelNode)
    }
    
    func loadPlayerCharacter(spawnPosition: SCNVector3 = SCNVector3Zero, modelScale: SCNVector3 = SCNVector3(x: 1, y: 1, z: 1)) -> SCNNode {
        let modelNode_Player = loadModelFromFile(fileName: self.modelFilePath, fileExtension: "")
        modelNode_Player.position = spawnPosition
        modelNode_Player.scale = modelScale
        modelNode_Player.name = nodeName
        //Update the properties again
        self.modelNode = modelNode_Player
        self.mesh = modelNode.geometry ?? SCNGeometry()
        self.playerController.playerCharacterNode = modelNode
        let collisionBox = SCNBox(width: 1, height: 1.5, length: 1, chamferRadius: 0)
        self.modelNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape:
                                                    //SCNPhysicsShape(geometry: SCNCapsule(capRadius: 1.0, height: 0.25))
                                                    //SCNPhysicsShape(geometry: mesh)
                                                    //nil
                                                    SCNPhysicsShape(geometry: collisionBox, options: nil)
        )
            
        
        //set the collision params
        setCollisionBitMask()
        
        return modelNode_Player
    }
    
    private func loadModelFromFile(fileName:String, fileExtension:String) -> SCNReferenceNode {
        let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        let refNode = SCNReferenceNode(url: url!)
        refNode?.load()
        return refNode!        
    }
    
    private func setCollisionBitMask() {
        modelNode.physicsBody!.categoryBitMask = PhysicsCategory.player.rawValue
        modelNode.physicsBody!.contactTestBitMask = PhysicsCategory.interactable.rawValue
        modelNode.physicsBody!.collisionBitMask = PhysicsCategory.interactable.rawValue
    }
    
}
