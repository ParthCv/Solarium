import SceneKit

class PlayerCharacter {
    
    var mesh: SCNGeometry = SCNGeometry()
    
    var animations: Dictionary<String, SCNAnimationPlayer> = Dictionary<String, SCNAnimationPlayer>()
    let animationController: AnimationController = AnimationController()
    let animationFile = "DummyAnimations"
    
    var modelFilePath: String
    
    var modelNode: SCNNode = SCNNode()
    
    var nodeName: String
    
    var playerController: PlayerController!
    
    init(modelFilePath: String, nodeName: String) {
        self.modelFilePath = modelFilePath
        self.nodeName = nodeName
        self.playerController = PlayerController(playerCharacterNode: modelNode, playerCharacter: self)
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
        
        
        self.animations = animationController.loadAnimations(animationFile: animationFile)
        for (key, anim) in animations{
            self.modelNode.addAnimationPlayer(anim, forKey: key)
        }
        
        //self.animationController.loadAnimation(sceneName: "art.scnassets/wifeIdleAnim.dae", extensionName: "", targetNode: modelNode_Player)
        playIdleAnimation()
        return modelNode_Player
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
    
    
}
