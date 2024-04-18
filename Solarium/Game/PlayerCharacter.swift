
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
    var modelFilePath: String = "art.scnassets/SkeletalMesh/Player/SK_Eve.scn"
    
    // Node for the model
    var modelNode: SCNNode!
    
    // Name of the player node
    var nodeName: String
        
    // controller for the player
    var playerController: PlayerController!
    
    var isHoldingSmthg: Bool = false
    
    init(nodeName: String) {
        //self.modelFilePath = modelFilePath
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
        
        // Read the anmations file and add it to the player
        self.animations = animationController.loadAnimations(animationFile: animationFile)
        for (key, anim) in animations{
            self.modelNode.addAnimationPlayer(anim, forKey: key)
        }
        
        playIdleAnimation()
        return modelNode
    }
    
    func getObjectHoldNode() -> SCNNode{
        return modelNode.childNode(withName: "holdingObjectPosition", recursively: true)!
    }
    
    // Animation funtions
    
    func playIdleAnimation() {
        self.animationController.playAnimation(animations: self.animations, key: "idle")
    }
    
    func playWalkAnimation() {
        self.animationController.playAnimation(animations: self.animations, key: "walk")
    }
    
    func playIdleToWalkAnimation() {
        self.animationController.playAnimation(animations: self.animations, key: "idletowalk")
    }
    
    func playWalkToIdleAnimation() {
        self.animationController.playAnimation(animations: self.animations, key: "walktoidle")
    }
    
    func playBootUpAnimation() {
        self.animationController.playAnimation(animations: self.animations, key: "boot")
    }

}
