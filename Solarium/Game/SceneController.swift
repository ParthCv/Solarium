//
//  SceneController.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit
import SpriteKit

// Enum to hold all th escens in the game
enum SceneEnum : String{
    case SCN1, SCN2
}

class SceneController {
    // Only need a single instance of the scene controller on the game
    static let singleton = SceneController()
    
    // Dictionary to hold all scene that will be loaded (not sequentially)
    // Create a scene file in the "Scenes" folder and extend it from SceneTemplate
    // Add .scn file of the same name to the scnassest.art/ forlder
    var sceneDictionary: [SceneEnum : SceneTemplate] = [
        .SCN1: s01_TutorialScene(),
        .SCN2: BaseScene(),
        
    ]

    init(){
        
    }
    
    // Function to switch scenes
    @MainActor
    func switchScene(_ gameViewController: GameViewController, currScn: SceneTemplate?, nextScn: SceneEnum) -> SceneTemplate?{
        // Find the scene to load
        if let sceneTemplate = sceneDictionary[nextScn]{
            // Load the next scene fisrt
            sceneTemplate.load(gameViewController: gameViewController)
            
            // Switch and transition the scene
            gameViewController.gameView.present(sceneTemplate.scene, with: .fade(withDuration: 0.5), incomingPointOfView: nil, completionHandler: nil)
            
            // Unload the old scene
            if (currScn != nil) { currScn?.unload()}
            return sceneTemplate
        }
        return nil
    }
}
