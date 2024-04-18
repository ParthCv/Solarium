//
//  AudioManager.swift
//  Solarium
//
//  Created by Norman Lim on 2024-03-31.
//

import AVFoundation

class AudioManager {
    
    var backgroundMusicPlayer: [AVAudioPlayer] = []    // Array to hold instances of AVAudioPlayer for BGM
    var interactSFXPlayer: [String: AVPlayer] = [:]    // Dictionary to map Puzzle Interactables to different sounds
    var instanceID: UUID
    var sceneDictionary: [SceneEnum : SceneTemplate] = [:]
    var currentSceneBGMEnum: SceneEnum
    
    init() {
        
        self.instanceID = UUID()
        currentSceneBGMEnum = SceneEnum.SCN0
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Failed to configure AVAudioSession: \(error.localizedDescription)")
        }
        
        preloadBGM()
        preloadSFX()
        
    }
    
    private func preloadSFX() {
        
        let sfxFiles = [ "Interact_Button",
                         "Interact_Door",
                         "Interact_Energy",
                         "Interact_Orb",
                         "Interact_Water",
                         "Progress_CentralDoorPowered",
                         "Progress_ElectricityPowerOn" ]
        
        for sfxFile in sfxFiles {
            // Check if SFX Loaded
            guard let sfxURL = Bundle.main.url(forResource: sfxFile, withExtension: "wav", subdirectory: "art.scnassets/SFX") else {
                print("Interact SFX music file \(sfxFile) not found")
                continue
            }
            
            let sfxPlayer = AVPlayer(url: sfxURL)
            sfxPlayer.volume = 0.1
            let puzzleInteractableName = getInteractSFXNameFromFile(from: sfxFile)
            
            print(puzzleInteractableName)
            
            interactSFXPlayer[puzzleInteractableName] = sfxPlayer
        }
    }
    
    func getInteractSFXNameFromFile(from fileName: String) -> String {
        let components = fileName.components(separatedBy: "_")
        if components.count >= 2 {
            return components[1]
        } else {
            print("Invalid file name format: \(fileName)")
            return ""
        }
    }
    
    func playInteractSound(interactableName: String) {
        guard let soundPlayer = interactSFXPlayer[interactableName] else {
            print("Sound for \(interactableName) not found")
            return
        }
        
        soundPlayer.seek(to: .zero)
        soundPlayer.play()
    }


    private func preloadBGM() {
        
        let bgmFiles = ["Loop#1", "TutorialOST", "AgricultureOST", "LightsOST", "TreeOST"]
        
        for bgmFile in bgmFiles {
            
            // Check if BGM Loaded
            guard let musicURL = Bundle.main.url(forResource: bgmFile, withExtension: "wav", subdirectory: "art.scnassets/BGM") else {
                print("Background music file \(bgmFile) not found")
                continue
            }
            
            do {
                let bgmPlayer = try AVAudioPlayer(contentsOf: musicURL)
                bgmPlayer.numberOfLoops = -1 // Loop indefinitely
                bgmPlayer.volume = 0.1 // prevent earblast
                backgroundMusicPlayer.append(bgmPlayer)
            } catch {
                print("Error loading background music \(bgmFile): \(error.localizedDescription)")
            }
        }
        
    }
    
    func playCurrentStageBGM(sceneName: SceneEnum) {
        guard !backgroundMusicPlayer.isEmpty else {
            print("No background music loaded")
            return
        }
        
        var bgmFileName: String
        
        switch sceneName {
            case .SCN0:
                bgmFileName = "Loop#1"
            case .SCN1:
                bgmFileName = "TutorialOST"
            case .SCN2:
                bgmFileName = "AgricultureOST"
            case .SCN3:
                bgmFileName = "LightsOST"
            case .SCN4:
                bgmFileName = "TreeOST"
            case .SCN5:
                bgmFileName = "Loop#5"
            case .SCN6:
                bgmFileName = "TreeOST"
        }
        
        if let bgmPlayer = backgroundMusicPlayer.first(where: { $0.url?.lastPathComponent == "\(bgmFileName).wav" }) {
            bgmPlayer.play()
            currentSceneBGMEnum = sceneName
        } else {
            print("Background music for scene \(sceneName.rawValue) not found")
        }
    }
    
    func stopCurrentStageBGM() {
        guard !backgroundMusicPlayer.isEmpty else {
            print("No background music loaded")
            return
        }
        
        //var sceneType = currentSceneBGMEnum
        var bgmFileName: String
        
        switch currentSceneBGMEnum {
            case .SCN0:
                bgmFileName = "Loop#1"
            case .SCN1:
                bgmFileName = "TutorialOST"
            case .SCN2:
                bgmFileName = "AgricultureOST"
            case .SCN3:
                bgmFileName = "LightsOST"
            case .SCN4:
                bgmFileName = "TreeOST"
            case .SCN5:
                bgmFileName = "Loop#5"
            case .SCN6:
                bgmFileName = "TreeOST"
        }
        
        if let bgmPlayer = backgroundMusicPlayer.first(where: { $0.url?.lastPathComponent == "\(bgmFileName).wav" }) {
            bgmPlayer.stop()
        } else {
            print("Background music for scene \(currentSceneBGMEnum.rawValue) not found")
        }
    }
    
    
    



    
    


    
}
