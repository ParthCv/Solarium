//
//  SceneTemplate.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit


class SceneTemplate {
    // Instance of the GameViewController
    var gvc: GameViewController
    
    // Main camera in the scene
    var mainCamera: SCNNode = SCNNode()
    
    // player charecter object
    var playerCharacter: PlayerCharacter
    
    // the scene itself in the scnasset folder
    var scene: SCNScene! = nil

    // spawn points for the player
    var spawnPoints: [Int: SCNNode]

    // Changeable interactables in the scene
    var sceneChangeInteractables: [SceneChangeInteractable]

    // Auto trigger entities in the scene
    var autoTriggerEntities: [Interactable]

    // Camera box triggers in the scene
    var cameraBoxTriggers: [CameraBoxTrigger]
    
    // flag to make the scene unloaded after the switch
    var isUnloadable: Bool
    
    // the list of puzzles for this scene
    var puzzles: [Puzzle]

    // current puzzle id
    var currentPuzzle: Int

    // flag to check if the scene is complete
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
        
        // Switch to the target scene
        // Use a DispatchQueue to switch scenes on the main thread so that the scene change is not called in the render loop of the current scene.
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
        // Regular Expression to create entities in the scene based on their name
        // SP - spawnPoints ST - scene trasitions D - doors AT - Auto Triggers CBT - Camera Box Triggers
        scene.rootNode.childNodes(passingTest: {(node, stop) -> Bool in
            if let name = node.name {
                let nameParts = name.components(separatedBy: "_")
                if nameParts.count <= 1 { return false }
                switch nameParts[0]{
                case "SP":
                    // Check if the name has the correct format
                    // 1 - Index of the spawn point
                    if nameParts.count >= 1 {
                        let interactableIndex = nameParts[1]
                        let intCast = Int(String(interactableIndex))!
                        spawnPoints[intCast] = node
                    }
                case "ST":
                    // Check if the name has the correct format
                    // 1 - Target Scene, 2 - Target Spawn Point (index)
                    if nameParts.count >= 2 {
                        let targetScene = SceneEnum(rawValue: nameParts[1])!
                        let scnInteract = SceneChangeInteractable(node: node, priority: TriggerPriority.lowPriority, displayText: nil, targetScene: targetScene, targetSpawnPoint: Int(nameParts[2])!)
                        scnInteract.doInteractDelegate = {
                            // Handle scene change interaction: Accounting for multiple inputs, but perform load once only.
                            self.handleSceneChangeInteraction(targetScene: targetScene, targetSpawnPoint: Int(nameParts[2])!)
                        }
                        sceneChangeInteractables.append(scnInteract)
                    }
                case "D":
                    // Check if the name has the correct format
                    // 1 - Door ID (only used to differntiate doors), 2 - Open State (0 - Closed, 1 - Open)
                    if nameParts.count >= 2 {
                        _ = Door(node: node, openState: (nameParts[2] == "1"))
                    }
                case "AT":
                    // Check if the name has the correct format
                    // 1 - Trigger Type (Teleport) with target, tirgger priority and volume
                    if nameParts.count >= 2 {
                        setUpActiveTrigger(node: node, nameParts: nameParts)
                    }
                case "CBT":
                    // Check if the name has the correct format
                    // 1 - camRotationX, 2- offsetY and 3 - offsetZ
                    let nameParts = name.components(separatedBy: "_")
                    if nameParts.count >= 4 {
                        let camRotX = Float(nameParts[1]) ?? CameraBoxTrigger.defaultTrigger.camRotationX
                        let offsetY = Float(nameParts[2]) ?? CameraBoxTrigger.defaultTrigger.offsetY
                        let offsetZ = Float(nameParts[3]) ?? CameraBoxTrigger.defaultTrigger.offsetZ
                        let cbt = CameraBoxTrigger(node: node, camRotationX: camRotX, offsetY: offsetY, offsetZ: offsetZ)
                        print("CBT: ", cbt.min, cbt.max)
                        cameraBoxTriggers.append(cbt)
                    }
                default:
                    return false
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
        // Remove all the nodes from the scene
        for node in deletableNodes {
            node.removeFromParentNode()
        }
        // Clear the arrays for the next scene
        spawnPoints.removeAll()
        sceneChangeInteractables.removeAll()
        autoTriggerEntities.removeAll()
        cameraBoxTriggers.removeAll()
        puzzles.removeAll()
    }
    
    /// The function called on the scene to perform Solarium game setup logic
    @MainActor func gameInit(){
        
    }
    
    /// Searches the node tree for nodes prefixed by the PuzzleID inside puzzleObj
    @MainActor func getPuzzleTrackedEntities(puzzleObj: Puzzle){
        // Find all interactable nodes in the scene
        var foundKeyValuePairs : [Int: Interactable] = [Int: Interactable]()
        // Regex with puzzleID and then create Interactable objects
        scene.rootNode.childNodes(passingTest:  { (node, stop) -> Bool in
            if let name = node.name, name.range(of: "P\(puzzleObj.puzzleID)_", options: .regularExpression) != nil {
                let nameParts = name.components(separatedBy: "_")
                
                if nameParts.count >= 2 {
                    let interactableIndex = nameParts[1]
                    let intCast = Int(String(interactableIndex))!
                    foundKeyValuePairs[intCast] = Interactable(node: node, priority: TriggerPriority.allCases[Int(nameParts[2]) ?? 0], displayText:"")
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
        // Scene Complete - All puzzles in scene solved
        if (sceneComplete) {
            // Update global flags for the complete scenes
            self.gvc.scenesPuzzleComplete[findKey(mvalue: self, dict: self.gvc.sceneDictionary)] = sceneComplete
            self.gvc.audioManager?.playInteractSound(interactableName: "ElectricityPowerOn")
            allPuzzlesDone()
        }
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
        
        // Check if the player is in range of any interactable objects
        for puzzle in puzzles {
            for interactableEntity in puzzle.trackedEntities{
                if interactableEntity.value.node.distanceToNode(to: playerCharacter.modelNode) < interactableEntity.value.triggerVolume! && highestPriority ?? TriggerPriority.noPriority < interactableEntity.value.priority {
                    highestPriority = interactableEntity.value.priority
                    interactableObject = interactableEntity.value
                }
            }
        }
        
        // Check if the player is in range of any scene change interactable objects
        for interactableEntity in sceneChangeInteractables {
            if interactableEntity.node.distanceToNode(to: playerCharacter.modelNode) < interactableEntity.triggerVolume! && highestPriority ?? TriggerPriority.noPriority < interactableEntity.priority {
                highestPriority = interactableEntity.priority
                interactableObject = interactableEntity
            }
        }
        
        // Check if the player is in range of any auto trigger interactable objects
        for interactableEntity in autoTriggerEntities {
            if interactableEntity.node.distanceToNode(to: playerCharacter.modelNode) < interactableEntity.triggerVolume! {
                interactableEntity.doInteractDelegate!()
            }
        }
        
        // Set the interact button action and text based on the interactable object
        if (interactableObject == nil) {
            gameViewController.interactButton.action = nil
            gameViewController.interactButton.title.text = ""
            gameViewController.interactButton.isHidden = true
        } else {
            gameViewController.interactButton.action = interactableObject!.doInteract
            gameViewController.interactButton.title.text = interactableObject!.displayText
            gameViewController.interactButton.isHidden = false
        }
        
        // heck for camer box trigger and set the new camera properties
        SharedData.sharedData.cameraOffset = CameraBoxTrigger.defaultTrigger
        for cbt in cameraBoxTriggers {
            if(cbt.comparePos(other: playerCharacter.modelNode.position)){
                SharedData.sharedData.cameraOffset = cbt.cameraOffset
            }
        }
    }
    
}

extension SceneTemplate {
    // Set up the active triggers in the scene
    func setUpActiveTrigger(node: SCNNode, nameParts: [String]){
        switch nameParts[1]{
        // Teleport trigger
        case "Teleport":
            if nameParts.count >= 4 {
                let target = nameParts[3]
                let tpInteract = Interactable(node: node, priority: TriggerPriority.noPriority, displayText: nil)
                tpInteract.doInteractDelegate = { [weak self] in
                    let player = self!.playerCharacter.modelNode
                    
                    let moveAction = SCNAction.move(to: self!.scene.rootNode.childNode(withName: "AT_Teleport_\(target)", recursively: true)!.worldPosition, duration: 0)
                    player?.runAction(moveAction)
                }
                autoTriggerEntities.append(tpInteract)
            }
        default: break
        }
    }
    
    // Add a light to the scene for testing
    func addAmbientLighting() -> SCNNode {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        deletableNodes.append(ambientLight)
        return ambientLight
    }
    
    // Add a floor to the scene for testing
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

// MARK: - Comparable
// Only to compare a scene template class name to change global values in gvc
extension SceneTemplate: Comparable {
    static func == (lhs: SceneTemplate, rhs: SceneTemplate) -> Bool {
        return type(of: lhs) == type(of: rhs)
    }
    
    static func < (lhs: SceneTemplate, rhs: SceneTemplate) -> Bool {
        return false
    }
}

// class to represent the camera box trigger
class CameraBoxTrigger {
    static let defaultTrigger = CameraProperties(camRotationX: -40, offsetY: 30, offsetZ: 30)
    
    // Struct to represent the camera properties
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
    
    // Compare the position of the player with the camera box trigger
    func comparePos(other: SCNVector3) -> Bool {
        return other.x > min.x && other.x < max.x && other.y > min.y && other.y < max.y && other.z > min.z && other.z < max.z
    }
    
}
