//
//  SoundManager.swift
//  Quizizo
//
//  Created by MURAD on 25.11.2025.
//

import AVFoundation
import UIKit

class SoundManager {
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?

    private init() {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ Audio session error: \(error)")
        }
    }

    func playSound(_ soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else {
            print("❌ Sound file not found: \(soundName).mp3")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            print("🔊 Playing sound: \(soundName)")
        } catch {
            print("❌ Error playing sound: \(error)")
        }
    }

    func stopSound() {
        audioPlayer?.stop()
    }
}
