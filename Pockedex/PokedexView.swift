//
//  PokedexView.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 20/05/26.
//

import SwiftUI

struct PokedexView: View {
    @State private var viewModel = PokedexViewModel()
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 0) {
                // Aquí colocaremos el menú de categorías más adelante
                
                CategoryListView(viewModel: viewModel)
                
                if viewModel.pokemons.isEmpty && viewModel.isLoading {
                    VStack(spacing: 10) {
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
//                    List {
//                        ForEach(viewModel.pokemons) { pokemon in
//                            NavigationLink(
//                                destination: PokemonShowView( pokemonUrl: pokemon.url )
//                            ) {
//                                HStack {
//                                    Text(pokemon.name.capitalized)
//                                        .font(.body)
//                                        .fontWeight(.medium)
//                                }
//                            }
//                            .padding(.vertical, 2)
//                            .onAppear {
//                                // Paginado automático
//                                if pokemon.id == viewModel.pokemons.last?.id {
//                                    print("Cargando más...")
//                                    Task {
//                                        await viewModel.fetchPokemons()
//                                    }
//                                }
//                            }
//                        }
//                        
//                        if viewModel.isLoading {
//                            HStack {
//                                Spacer()
//                                ProgressView()
//                                Spacer()
//                            }
//                            .listRowBackground(Color.clear)
//                        }
//                    }
//                    .listStyle(.plain)
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.pokemons) { pokemon in
                                NavigationLink(destination: PokemonShowView(pokemonUrl: pokemon.url)
                                ) {
                                    PokemonGridCardComponent(name: pokemon.name)
                                }
                                .onAppear{
                                    if pokemon.id  ==   viewModel.pokemons.last?.id {
                                        print("Cargando más...")
                                        Task {
                                            await viewModel.fetchPokemons()
                                        }
                                    }
                                }
                                
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 24 )
                        
                        // Cargando
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.vertical, 20)
                        }
                    }
                    
                    
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
