//
//  SceneController.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit
import SpriteKit

enum SceneEnum : String{
    case SCN1, SCN2
}

class SceneController {
    static let singleton = SceneController()
    
    var sceneDictionary: [SceneEnum : SceneTemplate] = [.SCN1: BaseScene(), .SCN2: OtherScene()]

    init(){
        
    }
    
    @MainActor
    func switchScene(_ gameView: GameView, currScn: SceneTemplate?, nextScn: SceneEnum) -> SceneTemplate?{
        if let sceneTemplate = sceneDictionary[nextScn]{
            sceneTemplate.load()
            gameView.present(sceneTemplate.scene, with: .fade(withDuration: 0.5), incomingPointOfView: nil, completionHandler: nil)
            if (currScn != nil) { currScn?.unload()}
            return sceneTemplate
        }
        return nil
    }
}
