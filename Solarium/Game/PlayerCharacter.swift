
import SceneKit

class PlayerCharacter {
        
    var mesh: SCNGeometry = SCNGeometry()
    
    var animations: [CAAnimation] = []
    
    var modelFilePath: String
    
    var modelNode: SCNNode = SCNNode()
    
    var collider: SCNNode = SCNNode()
    
    var nodeName: String
    
    var playerController: PlayerController = PlayerController(playerCharacterNode: SCNNode())
    
    var physicsBody: SCNPhysicsBody = SCNPhysicsBody()
    
    // MARK: Initialization
    
    init(modelFilePath: String, nodeName: String) {
        self.modelFilePath = modelFilePath
        self.nodeName = nodeName
    }
    
    func loadPlayerCharacter(spawnPosition: SCNVector3 = SCNVector3Zero, modelScale: SCNVector3 = SCNVector3(x: 1, y: 1, z: 1)) -> SCNNode {
        let modelNode_Player = loadModelFromFile(fileName: self.modelFilePath, fileExtension: "")
        modelNode_Player.position = spawnPosition
        modelNode_Player.scale = modelScale
        modelNode_Player.name = nodeName
        
        //Update the properties again
        self.modelNode = modelNode_Player
        self.mesh = modelNode.geometry ?? SCNGeometry()
        self.playerController = PlayerController(playerCharacterNode: modelNode)
        
        let collisionBox = SCNCapsule(capRadius: 1, height: 1)
        self.modelNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape:
                                                    SCNPhysicsShape(geometry: collisionBox, options: nil)
        )
        
//        let orientation = modelNode.orientation
        let lockRotation =
        SCNTransformConstraint.orientationConstraint(inWorldSpace: true, with: {(node, orientation) -> SCNQuaternion in
            let euler = node.eulerAngles
            return SCNQuaternion(0, euler.y, 0, 0)
            
        })
        modelNode.constraints = [lockRotation]
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
        modelNode.physicsBody!.categoryBitMask = SolariumCollisionBitMask.player.rawValue
        modelNode.physicsBody!.collisionBitMask = SolariumCollisionBitMask.interactable.rawValue | SolariumCollisionBitMask.ground.rawValue | 1
    }
    
}
