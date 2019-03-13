//
//  AudioManager.swift
//  QuizChallenge
//
//  Created by Anton Makarov on 27/01/2019.
//  Copyright © 2019 Anton Makarov. All rights reserved.
//

import AVFoundation

class AudioManager {
    
    static let shared = AudioManager()
    private init() { }
    
    private var audioPlayer: AVAudioPlayer?

    func playMusic() {
        if isPlaying()  {
            Logger.error(msg: "Player Already Playing")
            return
        }
        
        let fileUrl = Bundle.main.url(forResource: "BackgroundMusic", withExtension: "mp3")
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: fileUrl!)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
        } catch {
            Logger.error(msg: "Error playing: " + error.localizedDescription)
        }
    }
    
    func stopMusic() {
        isPlaying() ? audioPlayer!.stop() : ()
    }
    
    private func isPlaying() -> Bool {
        if let player = audioPlayer, player.isPlaying {
            return true
        }
        
        return false
    }
}
