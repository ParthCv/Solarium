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
    
    
    init() {
        
        print("initAANALIZING AUDIO")
        
        self.instanceID = UUID()
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("Failed to configure AVAudioSession: \(error.localizedDescription)")
        }
        
        preloadBGM()
        
    }

    private func preloadBGM() {
        
        let bgmFiles = ["Loop#1", "Loop#2", "Loop#3", "Loop#4", "Loop#5"]
        
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
        
        
        //TODO: Need a way to get current scene lvl
        playCurrentStageBGM(sceneType: SceneEnum.SCN0) // hardcoded SCN0 for now
    }
    
    func playCurrentStageBGM(sceneType: SceneEnum) {
        guard !backgroundMusicPlayer.isEmpty else {
            print("No background music loaded")
            return
        }
        
        var bgmFileName: String
        
        switch sceneType {
            case .SCN0:
                bgmFileName = "Loop#1"
            case .SCN1:
                bgmFileName = "Loop#2"
            case .SCN2:
                bgmFileName = "Loop#3"
            case .SCN3:
                bgmFileName = "Loop#4"
            case .SCN4:
                bgmFileName = "Loop#5"
        }
        
        if let bgmPlayer = backgroundMusicPlayer.first(where: { $0.url?.lastPathComponent == "\(bgmFileName).wav" }) {
            bgmPlayer.play()
        } else {
            print("Background music for scene \(sceneType.rawValue) not found")
        }
    }
    
    func stopCurrentStageBGM(sceneType: SceneEnum) {
        guard !backgroundMusicPlayer.isEmpty else {
            print("No background music loaded")
            return
        }
        
        var bgmFileName: String
        
        switch sceneType {
            case .SCN0:
                bgmFileName = "Loop#1"
            case .SCN1:
                bgmFileName = "Loop#2"
            case .SCN2:
                bgmFileName = "Loop#3"
            case .SCN3:
                bgmFileName = "Loop#4"
            case .SCN4:
                bgmFileName = "Loop#5"
        }
        
        if let bgmPlayer = backgroundMusicPlayer.first(where: { $0.url?.lastPathComponent == "\(bgmFileName).wav" }) {
            bgmPlayer.stop()
        } else {
            print("Background music for scene \(sceneType.rawValue) not found")
        }
    }
    
    
    



    
    


    
}
