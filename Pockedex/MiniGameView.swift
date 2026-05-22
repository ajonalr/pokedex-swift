//
//  MiniGameView.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 22/05/26.
//
import SwiftUI

struct MinigameView: View {
    @State private var viewModel = MiniGameViewMondel()
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // Puntaje actual
                Text("Racha: \(viewModel.score)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.cyan)
                
                Text("¿Quién es ese Pokémon?")
                    .font(.title)
                    .fontWeight(.black)
                
                if viewModel.isLoading {
                    ProgressView("Buscando Pokémon salvaje...")
                        .frame(height: 250)
                } else if let correctPokemon = viewModel.correctAnswer {
                    
                    // LA IMAGEN (Silueta o Revelada)
                    AsyncImage(url: URL(string: correctPokemon.sprites.frontDefault ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            // ¡EL TRUCO DE LA SILUETA!
                            // Si no se ha revelado, pintamos la imagen de negro
                            .colorMultiply(viewModel.isRevealed ? .white : .black)
                            // Le damos un poco de brillo al negro para que parezca sombra
                            .brightness(viewModel.isRevealed ? 0 : 0.2)
                            .animation(.easeInOut(duration: 0.5), value: viewModel.isRevealed)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 250)
                    .shadow(radius: 10)
                    
                    // LOS 4 BOTONES DE OPCIONES
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        ForEach(viewModel.options, id: \.id) { option in
                            Button(action: {
                                // Solo permitimos jugar si no se ha revelado la respuesta
                                if !viewModel.isRevealed {
                                    viewModel.checkAnswer(selectedId: option.id)
                                }
                            }) {
                                Text(option.name.capitalized)
                                    .font(.title)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    // Cambiamos el color del botón dependiendo si es correcto o incorrecto al revelar
                                    .background(buttonColor(for: option))
                                    .foregroundColor(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            .disabled(viewModel.isRevealed) // Desactivamos botones al revelar
                        }
                    }
                    .padding(.horizontal)
                    
                    // BOTÓN DE SIGUIENTE RONDA (Solo aparece cuando adivinas)
                    if viewModel.isRevealed {
                        Button("Siguiente Pokémon") {
                            Task { await viewModel.startNewRoun() }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 20)
                    }
                }
            }
            .navigationTitle("Minijuego")
            .task {
                // Arrancamos el juego al abrir la pantalla
                if viewModel.options.isEmpty {
                    await viewModel.startNewRoun()
                }
            }
        }
    }
    
    // Función auxiliar para colorear los botones verde/rojo al revelar
    func buttonColor(for option: PokemonDetail) -> Color {
        if !viewModel.isRevealed {
            return Color.cyan // Color normal del botón
        }
        
        if option.id == viewModel.correctAnswer?.id {
            return Color.green // La respuesta correcta se pinta de verde
        } else {
            return Color.red.opacity(0.6) // Las incorrectas de rojo
        }
    }
}

#Preview {
    MinigameView()
}
