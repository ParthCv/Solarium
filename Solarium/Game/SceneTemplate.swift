//
//  SceneTemplate.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit


class SceneTemplate {    

    var gvc: GameViewController
    // Main camera in the scene
    var mainCamera: SCNNode = SCNNode()
    
    // player charecter object
    var playerCharacter: PlayerCharacter
    
    // the scene itself in the scnasset folder
    var scene: SCNScene! = nil
    var spawnPoints: [Int: SCNNode]
    var sceneChangeInteractables: [SceneChangeInteractable]
    var autoTriggerEntities: [Interactable]
    var cameraBoxTriggers: [CameraBoxTrigger]
    
    // flag to make the scene unloaded after the switch
    var isUnloadable: Bool
    
    // the list of puzzles for this scene
    var puzzles: [Puzzle]
    var currentPuzzle: Int
    var sceneComplete: Bool = false
    
    // list of all deletable nodes
    var deletableNodes: [SCNNode]
    
    // Flag to control scene change interactions
    var sceneChangeInteractionEnabled = true
    
    required init(gvc: GameViewController){
        self.gvc = gvc
        isUnloadable = false
        spawnPoints = [:]
        sceneChangeInteractables = []
        autoTriggerEntities = []
        cameraBoxTriggers = []
        deletableNodes = []
        puzzles = []
        currentPuzzle = 0
        playerCharacter = PlayerCharacter(nodeName: "PlayerNode_Wife")
        mainCamera = SCNNode()
        
    }
    
    // Function to handle scene change interactions
    func handleSceneChangeInteraction(targetScene: SceneEnum, targetSpawnPoint: Int) {
        // Check if scene change interaction is enabled
        guard sceneChangeInteractionEnabled else { return }
        
        // Disable further scene change interactions
        sceneChangeInteractionEnabled = false
        
        // Door interact sound is the default that will be played when transitioning between Scenes.
        self.gvc.audioManager?.playInteractSound(interactableName: "Door")
        // Stop current scene BGM. Playing the next scene BGM handled in GameViewController.switchScene()
        self.gvc.audioManager?.stopCurrentStageBGM()
        
        DispatchQueue.main.async {
            SharedData.sharedData.playerSpawnIndex = targetSpawnPoint
            self.gvc.switchScene(currScn: self, nextScn: targetScene)
            
            // Re-enable scene change interactions after a delay to prevent multiple taps
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.sceneChangeInteractionEnabled = true
            }
        }
    }
    
    // preload for the scene
    @MainActor func load() {
        //get spawn points
        scene.rootNode.childNodes(passingTest: { (node, stop) -> Bool in
            if let name = node.name, name.range(of: "SP_", options: .regularExpression) != nil {
                let nameParts = name.components(separatedBy: "_")
                if nameParts.count >= 1 {
                    let interactableIndex = nameParts[1]
                    let intCast = Int(String(interactableIndex))!
                    spawnPoints[intCast] = node
                }
                return true
            }
            return false
            
        })
        
        scene.rootNode.childNodes(passingTest: { (node, stop) -> Bool in
            if let name = node.name, name.range(of: "ST_", options: .regularExpression) != nil {
                let nameParts = name.components(separatedBy: "_")
                if nameParts.count >= 2 {
                    let targetScene = SceneEnum(rawValue: nameParts[1])!
                    print(targetScene)
                    let scnInteract = SceneChangeInteractable(node: node, priority: TriggerPriority.lowPriority, displayText: "GoTo \(targetScene)", targetScene: targetScene, targetSpawnPoint: Int(nameParts[2])!)
                    scnInteract.doInteractDelegate = {
                        // Handle scene change interaction: Accounting for multiple inputs, but perform load once only.
                        self.handleSceneChangeInteraction(targetScene: targetScene, targetSpawnPoint: Int(nameParts[2])!)
                    }
                    sceneChangeInteractables.append(scnInteract)
                }
                return true
            }
            return false
            
        })
        
        scene.rootNode.childNodes(passingTest: { (node, stop) -> Bool in
            if let name = node.name, name.range(of: "D_", options: .regularExpression) != nil {
                let nameParts = name.components(separatedBy: "_")
                if nameParts.count >= 2 {
                    _ = Door(node: node, openState: (nameParts[2] == "1"))
                }
                return true
            }
            return false
            
        })
        
        scene.rootNode.childNodes(passingTest: { (node,stop) -> Bool in
            if let name = node.name, name.range(of: "AT_", options: .regularExpression) != nil{
                let nameParts = name.components(separatedBy: "_")
                if nameParts.count >= 2 {
                    switch nameParts[1]{
                    case "Teleport":
                        if nameParts.count >= 4 {
                            let target = nameParts[3]
                            let tpInteract = Interactable(node: node, priority: TriggerPriority.noPriority, displayText: nil)
                            tpInteract.doInteractDelegate = { [weak self] in
                                let player = self!.playerCharacter.modelNode
                                
                                let moveAction = SCNAction.move(to: self!.scene.rootNode.childNode(withName: "AT_Teleport_\(target)", recursively: true)!.worldPosition, duration: 0)
                                player?.runAction(moveAction)
                                // TODO: ADD TELEPORT INTERACT SOUND HERE FOR FINAL
                            }
                            autoTriggerEntities.append(tpInteract)
                        }
                        break
                    default: break
                    }
                    
                }
                return true
            }
            return false
        })
        
        scene.rootNode.childNodes(passingTest: { (node,stop) -> Bool in
            if let name = node.name, name.range(of: "CBT_", options: .regularExpression) != nil{
                let nameParts = name.components(separatedBy: "_")
                if nameParts.count >= 4 {
//                    let boxIndex = Int(String(nameParts[1]))!
                    let camRotX = Float(nameParts[1]) ?? CameraBoxTrigger.defaultTrigger.camRotationX
                    let offsetY = Float(nameParts[2]) ?? CameraBoxTrigger.defaultTrigger.offsetY
                    let offsetZ = Float(nameParts[3]) ?? CameraBoxTrigger.defaultTrigger.offsetZ
                    let cbt = CameraBoxTrigger(node: node, camRotationX: camRotX, offsetY: offsetY, offsetZ: offsetZ)
                    print("CBT: ", cbt)
                    cameraBoxTriggers.append(cbt)
                }
                return true
            }
            return false
        })
        
        // Add the player to the scene
        let playerNode = playerCharacter.loadPlayerCharacter(spawnPosition: spawnPoints[SharedData.sharedData.playerSpawnIndex]!.worldPosition)
        scene.rootNode.addChildNode(playerNode)
        deletableNodes.append(playerNode)
        // Add a camera to the scene
        mainCamera = scene.rootNode.childNode(withName: "mainCamera", recursively: true) ?? SCNNode()
        gameInit()
    }
    
    // delete the nodes from memeory
    func unload(){
        for node in deletableNodes {
            node.removeFromParentNode()
        }
        spawnPoints.removeAll()
        sceneChangeInteractables.removeAll()
        autoTriggerEntities.removeAll()
        cameraBoxTriggers.removeAll()
        puzzles.removeAll()
        print(spawnPoints.count)
        print(sceneChangeInteractables.count)
    }
    
    /// The function called on the scene to perform Solarium game setup logic
    @MainActor func gameInit(){
        
    }
    
    /// Searches the node tree for nodes prefixed by the PuzzleID inside puzzleObj
    @MainActor func getPuzzleTrackedEntities(puzzleObj: Puzzle){
        var foundKeyValuePairs : [Int: Interactable] = [Int: Interactable]()
        scene.rootNode.childNodes(passingTest:  { (node, stop) -> Bool in
            if let name = node.name, name.range(of: "P\(puzzleObj.puzzleID)_", options: .regularExpression) != nil {
                let nameParts = name.components(separatedBy: "_")
                
                if nameParts.count >= 2 {
                    let interactableIndex = nameParts[1]
                    let intCast = Int(String(interactableIndex))!
                    foundKeyValuePairs[intCast] = Interactable(node: node, priority: TriggerPriority.allCases[Int(nameParts[2]) ?? 0], displayText: nameParts[3])
                    print("Interactable created - ", nameParts[3], "with priority - ", nameParts[2])
                }
                return true
            }
            return false
        })
        
        puzzleObj.trackedEntities = foundKeyValuePairs
        puzzleObj.linkEntitiesToPuzzleLogic()
    }
    
    ///Go to next Puzzle
    ///
    ///Increment currentPuzzle
    func nextPuzzle() {
        currentPuzzle += 1
        sceneComplete = currentPuzzle == puzzles.count
        //if(sceneComplete) //TODO: tell gvc room complete
        if (sceneComplete) {
            // Update global flags for the complete scenes
            self.gvc.scenesPuzzleComplete[findKey(mvalue: self, dict: self.gvc.sceneDictionary)] = sceneComplete
        }
        print("current puzzle: ", currentPuzzle)
        print("scene complete: ", sceneComplete)
    }
    
    ///Called when all puzzles are done
    func allPuzzlesDone(){
        print("All puzzles done")
    }
    
    /// the rendering update for the scene
    @MainActor func update(gameViewController: GameViewController, updateAtTime time: TimeInterval){
        triggerInteractables(gameViewController: gameViewController)
        // Move and rotate the player from the inputs of the d-pad
        playerCharacter.playerController.movePlayerInXAndYDirection(
            changeInX: gameViewController.normalizedInputDirection.x,
            changeInZ: gameViewController.normalizedInputDirection.y,
            rotAngle: gameViewController.degree,
            deltaTime: time - gameViewController.lastTickTime
        )
        
        // Make the camera follow the player
        playerCharacter.playerController.repositionCameraToFollowPlayer(mainCamera: mainCamera, deltaTime: time - gameViewController.lastTickTime)
    }
    
    /// physics updates for the scene
    @MainActor func physicsWorldDidBegin(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact, gameViewController: GameViewController){}

    /// physics updates for the scene
    @MainActor func physicsWorldDidEnd(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact,  gameViewController: GameViewController){}

    /// physics updates for the scene
    @MainActor func physicsWorldDidUpdate(_ world: SCNPhysicsWorld,  contact: SCNPhysicsContact, gameViewController: GameViewController){}
    
    /// Trigger any interactable in the scene based on conditions and priority
    @MainActor func triggerInteractables(gameViewController: GameViewController){
        var highestPriority: TriggerPriority? = nil
        var interactableObject: Interactable? = nil
        
        for puzzle in puzzles {
            for interactableEntity in puzzle.trackedEntities{
                if interactableEntity.value.node.distanceToNode(to: playerCharacter.modelNode) < interactableEntity.value.triggerVolume! && highestPriority ?? TriggerPriority.noPriority < interactableEntity.value.priority {
                    highestPriority = interactableEntity.value.priority
                    interactableObject = interactableEntity.value
                }
            }
        }
        
        for interactableEntity in sceneChangeInteractables {
            if interactableEntity.node.distanceToNode(to: playerCharacter.modelNode) < interactableEntity.triggerVolume! && highestPriority ?? TriggerPriority.noPriority < interactableEntity.priority {
                highestPriority = interactableEntity.priority
                interactableObject = interactableEntity
            }
        }
        
        for interactableEntity in autoTriggerEntities {
            if interactableEntity.node.distanceToNode(to: playerCharacter.modelNode) < interactableEntity.triggerVolume! {
                interactableEntity.doInteractDelegate!()
            }
        }
        
        if (interactableObject == nil) {
            gameViewController.interactButton.action = nil
            gameViewController.interactButton.title.text = ""
            gameViewController.interactButton.isHidden = true
        } else {
            gameViewController.interactButton.action = interactableObject!.doInteract
            gameViewController.interactButton.title.text = interactableObject!.displayText
            gameViewController.interactButton.isHidden = false
        }
        
        SharedData.sharedData.cameraOffset = CameraBoxTrigger.defaultTrigger
        for cbt in cameraBoxTriggers {
            if(cbt.comparePos(other: playerCharacter.modelNode.position)){
                SharedData.sharedData.cameraOffset = cbt.cameraOffset
            }
        }
    }
    
}

extension SceneTemplate {
    func addAmbientLighting() -> SCNNode {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        deletableNodes.append(ambientLight)
        return ambientLight
    }
    
    func createFloor() -> SCNNode {
        let floorNode = SCNNode()
        let floor = SCNFloor()
        floor.reflectivity = 0.001
        floorNode.geometry = floor
        floorNode.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/textures/grid.png"
        
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        floorNode.physicsBody!.rollingFriction = 1
        floorNode.physicsBody!.friction = 1
        deletableNodes.append(floorNode)
        return floorNode
    }
}

extension SceneTemplate: Comparable {
    static func == (lhs: SceneTemplate, rhs: SceneTemplate) -> Bool {
        return type(of: lhs) == type(of: rhs)
    }
    
    static func < (lhs: SceneTemplate, rhs: SceneTemplate) -> Bool {
        return false
    }
}

class CameraBoxTrigger {
    static let defaultTrigger = CameraProperties(camRotationX: -40, offsetY: 30, offsetZ: 30)
    
    struct CameraProperties{
        let camRotationX: Float
        let offsetY: Float
        let offsetZ: Float
    }
    
    let cameraOffset: CameraProperties
    let origin: SCNVector3
    let min: SCNVector3
    let max: SCNVector3
    
    
    init(node: SCNNode?, camRotationX: Float, offsetY: Float, offsetZ: Float) {
        self.origin = node?.worldPosition ?? SCNVector3Zero
        self.cameraOffset = CameraProperties(camRotationX: camRotationX, offsetY: offsetY, offsetZ: offsetZ)
        
        self.min = (node?.boundingBox.min ?? SCNVector3Zero) + origin
        self.max = (node?.boundingBox.max ?? SCNVector3Zero) + origin
    }
    
    func comparePos(other: SCNVector3) -> Bool {
        return other.x > min.x && other.x < max.x && other.y > min.y && other.y < max.y && other.z > min.z && other.z < max.z
    }
    
}
