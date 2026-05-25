//
//  PokedexView.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 20/05/26.
//

import SwiftUI

struct PokedexView: View {
    @State private var viewModel = PokedexViewModel()
    @State private var searchText : String = ""
    @State private var selectedGeneration : PokemonGeneration = .all
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    
    var body: some View {
        
        
        NavigationStack {
            
          
            
            VStack(spacing: 0) {
                // Aquí colocaremos el menú de categorías más adelante
                
                CategoryListView(viewModel: viewModel)
                    .padding(.top, 14)
                    .padding(.bottom, 7)
                
    
                ScrollView( .horizontal, showsIndicators: false ) {
                    HStack (spacing: 10) {
                        ForEach (PokemonGeneration.allCases ) { generacion in
                            Button(action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedGeneration = generacion
                                    }
                                }
                            ) {
                                Text(generacion.rawValue)
                                    .font(.caption)
                                    .fontWeight(selectedGeneration == generacion ? .bold : .medium)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedGeneration == generacion ? Color.indigo : Color.gray.opacity(0.15))
                                    .foregroundColor(selectedGeneration == generacion ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                            
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 10)
               
               
            
                
                
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
                            
                            // ---- esta forma solo procesa  la busqueda por tipo y por categoria
//                            let filterPokemons = searchText.isEmpty ? viewModel.pokemons : viewModel.pokemons.filter{ poke in                                              poke.name.localizedCaseInsensitiveContains(searchText)
//                            }
                            
                            
                            let filterPokemons = viewModel.pokemons.filter{ poke in
                                // filtro para texto de busqueda
                                let matchesSearch = searchText.isEmpty || poke.name.localizedCaseInsensitiveContains(searchText)
                                
                                // filtro para las generaciones
                                let pokeId = getPokemonId(from: poke.url)
                                let matchesGeneration = selectedGeneration.idRange?.contains(pokeId) ?? true
                                
                                return matchesSearch && matchesGeneration
                            }
                            ForEach(filterPokemons) { pokemon in
                                NavigationLink(destination: PokemonShowView(pokemonUrl: pokemon.url)
                                ) {
                                    PokemonGridCardComponent(name: pokemon.name, imagenURL: getImageUrl(from: pokemon.url))
                                }
                                
                                // comentamos todo el onappear porque hacemos la peticion de un solo al iniciar 
//                                .onAppear{
//                                    print("pokemon url \(pokemon.url)")
//                                    
//                                    // primera fonra de continuar con el scroll infinitro pero no optimo para las busquedas
////                                    if pokemon.id  ==   viewModel.pokemons.last?.id {
////                                        print("Cargando más...")
////                                        Task {
////                                            await viewModel.fetchPokemons()
////                                        }
////                                    }
//                                    
//                                    
//                                    // Mantenemos el scroll infinito (Solo cargamos más si NO estamos buscando nada)
//                                    if searchText.isEmpty && pokemon.name == viewModel.pokemons.last?.name {
//                                        Task { await viewModel.fetchPokemons() }
//                                    }
//                                    
//                                }
                                
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
            
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Buscar Pokemon")
            
            .toolbarBackground(Color.red, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
         
            .task {
                // Solo dispara la petición si la lista está completamente vacía y se completa cuando estamos en el fin de la pantalla y cuando se solicitan los siguientes 20
                //                if viewModel.pokemons.isEmpty {
                //                    await viewModel.fetchPokemons()
                //                }
                // ------ LO HEMOS COMENTADO PORQUE AHORA LA PETICION DE HACEN LOS 1000 y tantos pokemones al iniciar el app
                
                await viewModel.getAllPokemons()
                
            }
            

            
        }
    }
}


// FUNCIÓN AUXILIAR para obtener la imagen de cada pokemon
func getImageUrl(from urlString: String) -> String {
    // urlString viene así: "https://pokeapi.co/api/v2/pokemon/25/"
    // Al separarlo por "/", el último o penúltimo elemento es el "25" (Pikachu)
    let components = urlString.split(separator: "/")
    guard let id = components.last else { return "" }
    
    // Retornamos la URL oficial de las imágenes de la PokeAPI
    return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
}

// obtiene unicamente el id de los pokemons
func getPokemonId( from urlString: String ) -> Int{
    // sirve para serparar la url por "/" como el "extrac de php"
    let extract =  urlString.split(separator: "/")
    if let id = extract.last, let id = Int(id) {
        return id
    }
    
    return 0
}

#Preview {
    PokedexView()
}
