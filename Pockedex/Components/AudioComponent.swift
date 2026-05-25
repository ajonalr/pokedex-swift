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
            
            // los forKey son lo que declaramos con @AppStorage("key")
            let isMuted = UserDefaults.standard.bool(forKey: "isMusicMuted")
            let savedVolume = UserDefaults.standard.float(forKey: "musicVolume")
            
            // Si el volumen guardado es 0 (primera vez abriendo la app), usamos tu 0.4 por defecto
            let initialVolume = savedVolume == 0 ? 0.4 : Float(savedVolume)
            bgmPlayer?.volume = initialVolume
            
            if !isMuted {
                bgmPlayer?.play()
            }
        
            
        }catch {
            print( "Error de repoduccion" )
            
        }
        
    }
    
    
    // funciones para los archivos que quiera configurar el volumen
    func updateMuteState(isMuted: Bool) {
        if isMuted {
            bgmPlayer?.pause()
        } else {
            bgmPlayer?.play()
        }
    }
    
    func updateVolume(to volume: Double) {
        bgmPlayer?.volume = Float(volume)
    }

    
}
