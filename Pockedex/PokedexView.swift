//
//  PokedexView.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 20/05/26.
//

import SwiftUI

struct PokedexView: View {
    @State private var viewModel = PokedexViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                // Aquí colocaremos el menú de categorías más adelante
                
                if viewModel.pokemons.isEmpty && viewModel.isLoading {
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Abriendo Pokebolas...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.indigo)
                        Text(error)
                            .multilineTextAlignment(.center)
                        Button("Reintentar") {
                            Task { await viewModel.fetchPokemons() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxHeight: .infinity)
                } else {
//                    Text("Si existen Datos")
                    List {
                        ForEach(viewModel.pokemons) { pokemon in
                            NavigationLink(
                                destination: PokemonShowView( pokemonUrl: pokemon.url )
                            ) {
                                HStack {
                                    Text(pokemon.name.capitalized)
                                        .font(.body)
                                        .fontWeight(.medium)
                                }
                            }
                            .padding(.vertical, 4)
                            .onAppear {
                                // Paginado automático
                                if pokemon.id == viewModel.pokemons.last?.id {
                                    print("Cargando más...")
                                    Task {
                                        await viewModel.fetchPokemons()
                                    }
                                }
                            }
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Pokédex")
            .task {
                // Solo dispara la petición si la lista está completamente vacía
                if viewModel.pokemons.isEmpty {
                    await viewModel.fetchPokemons()
                }
            }
        }
    }
}

#Preview {
    PokedexView()
}
