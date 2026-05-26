//
//  MiniGameIAView.swift
//  Pockedex
//
//  Created by ari on 25/05/26.
//

import SwiftUI

struct MiniGameIAView: View {
    @State private var showCamera = false
    @State private var capturedImage: UIImage? = nil
    
    @State private var aiResponse: String = "Esperando escaneo..."
    @State private var isScanning = false
    
    private let geminiService = GeminiService()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // PANTALLA VISUAL (FOTO O PLACEHOLDER)
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 300, height: 300)
                        .overlay(
                            VStack {
                                Image(systemName: "camera.viewfinder")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                Text("Apunta a un Pokémon")
                                    .foregroundColor(.gray)
                                    .padding(.top, 10)
                            }
                        )
                }
                
                // RESPUESTA DE LA IA
                if isScanning {
                    ProgressView("La IA está analizando...")
                        .padding()
                } else {
                    Text(aiResponse)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.indigo)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                Spacer()
                
                // BOTONERA
                HStack(spacing: 20) {
                    Button(action: { showCamera = true }) {
                        Label("Tomar Foto", systemImage: "camera.fill")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    
                    // Este botón solo aparece si ya hay una foto
                    if capturedImage != nil {
                        Button(action: { scanPokemon() }) {
                            Label("Escanear", systemImage: "sparkles")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .navigationTitle("Pokédex IA")
            .navigationBarTitleDisplayMode(.inline)
            // Abrimos el puente de la cámara
            .fullScreenCover(isPresented: $showCamera) {
                ImagePicker(selectedImage: $capturedImage)
                    .ignoresSafeArea()
            }
        }
    }
    
    // Función asíncrona para llamar al servicio
    private func scanPokemon() {
        guard let image = capturedImage else { return }
        
        isScanning = true
        aiResponse = "Procesando visión..."
        
        Task {
            do {
                let result = try await geminiService.identifyPokemon(from: image)
                aiResponse = "¡Es: \(result)!"
                // Efecto de sonido de éxito opcional ;)
                // AudioComponent.shared.startBGM()
            } catch {
                aiResponse = "Error de conexión."
                print(error)
            }
            isScanning = false
        }
    }
}

#Preview {
    MinigameView()
}
