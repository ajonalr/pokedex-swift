//
//  AudioComponent.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 22/05/26.
//

import Foundation
import AVFoundation

class AudioComponent {
    
    
    // el static let shared em sirve para el patron singeltone ya que no queremos estar iniciado el componete de audio, este solo se inicia al inicar la app
    static let shared = AudioComponent()
    var bgmPlayer: AVAudioPlayer?
    
    
     func startBGM() {
        guard let url  = Bundle.main.url(
            // asi se llama el asset
            forResource: "audiopokemon", withExtension: "mp3"
        ) else {
            print("No se encontro el archivo de audio")
            return
        }
        
        
        
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: url)
            bgmPlayer?.numberOfLoops = -1
            bgmPlayer?.volume = 1 // esto es en % 1 = 100%
            bgmPlayer?.play()
            
        }catch {
            print( "Error de repoduccion" )
            
        }
        
    }
    
    
}
