
import SceneKit

class Eve {
        
    // key -> animationa name, value -> anmiation file
    var animations: Dictionary<String, SCNAnimationPlayer> = Dictionary<String, SCNAnimationPlayer>()
    
    // Animation controller for the player
    let animationController: AnimationController = AnimationController()
    
    // File with animation files and their names [hard coded fiole name rn]
    let animationFile = "DummyAnimations"
    
    // Node for the model
    var modelNode: SCNNode!
    
    init(node: SCNNode, openState: Bool?){
        //get the root node from the scene with all the child nodes
        self.modelNode = node;
        
        //load the door animations on the door node
        self.animations = animationController.loadAnimations(animationFile: animationFile)
        for (key, anim) in animations{
            anim.animation.isRemovedOnCompletion = false
            self.modelNode.addAnimationPlayer(anim, forKey: key)
        }
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
