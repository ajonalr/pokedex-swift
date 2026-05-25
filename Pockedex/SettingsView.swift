//
//  SettingsView.swift
//  Pockedex
//
//  Created by ari on 25/05/26.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isMusicMuted") private var isMusicMuted: Bool = false
    @AppStorage("musicVolume") private var musicVolume: Double = 0.5
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    
    
    var body: some View {
        Form {
            Section(header: Text("Audio y Sonido")) {
                Toggle(isOn: $isMusicMuted) {
                    Label("Silencias Musica", systemImage: isMusicMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                }
                .onChange( of: isMusicMuted ) { _, newValue in
                    print("Musica Silenciada")
                    AudioComponent.shared.updateMuteState(isMuted: newValue)
                }
                
                
                if !isMusicMuted {
                    VStack(alignment: .leading) {
                        Text("Volumen")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Image(systemName: "speaker.fill")
                                .foregroundColor(.gray)
                            
                            Slider(value:$musicVolume, in: 1 ... 100)
                                .tint(.indigo)
                            
                                .onChange(of: musicVolume) { _ , newvalor in
                                    AudioComponent.shared.updateVolume(to: newvalor)
                                    
                                }
                            
                            Image(systemName: "speaker.wave.3.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .transition(.opacity)
                }
            }
            
            Section(header: Text("TEMA?")) {
                Toggle(isOn: $isDarkMode) {
                    Label("Modo Obscuro", systemImage: isDarkMode ? "sun.max.fill" : "sun.haze.fill")
                        .foregroundColor(isDarkMode ? .indigo : .orange)
                }
            }
            
            
            // SECCIÓN 3: CRÉDITOS
            Section(header: Text("Acerca de la App")) {
                HStack {
                    Text("Versión de la Pokédex")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.gray)
                }
                HStack {
                    Text("Desarrollador")
                    Spacer()
                    Text("Ariel Ramirez para XrossOver Sports")
                        .fontWeight(.semibold)
                        .foregroundColor(.indigo)
                }
            }
        }
        .navigationTitle("Configuración")
        .navigationBarTitleDisplayMode(.large)
        // Aplicamos el modo oscuro globalmente SOLO a esta vista y las que dependan de ella
        .preferredColorScheme(isDarkMode ? .dark : .light)
            
            
        
    }
}

#Preview {
    SettingsView()
}
