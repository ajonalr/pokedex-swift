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
                                    PokemonGridCardComponent(name: pokemon.name, imagenURL: getImageUrl(from: pokemon.url))
                                }
                                .onAppear{
                                    print("pokemon url \(pokemon.url)")
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.red, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task {
                // Solo dispara la petición si la lista está completamente vacía
                if viewModel.pokemons.isEmpty {
                    await viewModel.fetchPokemons()
                }
            }
        }
    }
}


// FUNCIÓN AUXILIAR
func getImageUrl(from urlString: String) -> String {
    // urlString viene así: "https://pokeapi.co/api/v2/pokemon/25/"
    // Al separarlo por "/", el último o penúltimo elemento es el "25" (Pikachu)
    let components = urlString.split(separator: "/")
    guard let id = components.last else { return "" }
    
    // Retornamos la URL oficial de las imágenes de la PokeAPI
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
}

#Preview {
    PokedexView()
}
