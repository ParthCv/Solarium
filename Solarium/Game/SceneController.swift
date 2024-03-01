//
//  SceneController.swift
//  Solarium
//
//  Created by Parth Chaturvedi on 2024-02-29.
//

import SceneKit
import SpriteKit

enum SceneEnum : String{
    case SCN1
}

class SceneController {
    static let singleton = SceneController()
    
    var sceneDictionary: [SceneEnum : SceneTemplate] = [.SCN1: BaseScene()]

    init(){
        
    }
    
    @MainActor
    func switchScene(_ gameView: GameView, currScn: SceneTemplate?, nextScn: SceneEnum){
        if let sceneTemplate = sceneDictionary[nextScn]{
            gameView.present(sceneTemplate.scene, with: .fade(withDuration: 0.1), incomingPointOfView: nil, completionHandler: nil)
        }
    }
}
