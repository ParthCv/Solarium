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
    
    // flag to make the scene unloaded after the switch
    var isUnloadable: Bool
    
    // the list of puzzles for this scene
    var puzzles: [Puzzle]
    var currentPuzzle: Int
    var sceneComplete: Bool = false
    
    // list of all deletable nodes
    var deletableNodes: [SCNNode]
    
    required init(gvc: GameViewController){
        self.gvc = gvc
        isUnloadable = false
        spawnPoints = [:]
        sceneChangeInteractables = []
        autoTriggerEntities = []
        deletableNodes = []
        puzzles = []
        currentPuzzle = 0
        playerCharacter = PlayerCharacter(nodeName: "PlayerNode_Wife")
        mainCamera = SCNNode()
        
    }
    
    // preload for the scene
    @MainActor func load(){
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
                        // Door interact sound is the default that will be played when transitioning between Scenes.
                        self.gvc.audioManager?.playInteractSound(interactableName: "Door")
                        // Stop current scene BGM. Playing the next scene BGM handled in GameViewController.switchScene()
                        self.gvc.audioManager?.stopCurrentStageBGM()
                        //self.gvc.audioManager?.playCurrentStageBGM(sceneName: targetScene)
                        DispatchQueue.main.async(execute: {
                            SharedData.sharedData.playerSpawnIndex = scnInteract.targetSpawnPoint
                            self.gvc.switchScene(currScn: self, nextScn: targetScene)
                        })
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
                    Door(node: node, openState: (nameParts[2] == "1"))
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
        playerCharacter.playerController.repositionCameraToFollowPlayer(mainCamera: mainCamera)
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
