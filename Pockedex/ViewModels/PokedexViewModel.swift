//
//  PokedexViewModel.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 20/05/26.
//

import Foundation
import Observation

@MainActor // Protege la intefaz obligando a actualizar variables en el de forma "reactiva"
@Observable
class PokedexViewModel {
    
    
    private let pokemonApi = PokeAPIService()
    
    var pokemons: [PokemonResult] = []
    //aqui siempre van a estar los +1000 pokemon para no cargar todo de nuevo
    private var allPokemons: [PokemonResult] = []

    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    
    var nextUrl: String? = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
    // Categoría actual seleccionada (nil significa "Todos")
    var selectedType: PokemonType? = nil
    

    func getAllPokemons() async {
        guard allPokemons.isEmpty && !isLoading else { return }
        isLoading = true
        errorMessage = nil
    
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1025&offset=0") else {
            isLoading = false
            return
        }
        
        do {
            
            let response  = try await pokemonApi.getPokemons(from: url)
            self.pokemons = response.results
            self.allPokemons = response.results
            return
            
        }catch {
            self.errorMessage = "Error"
            print(error)
        }
        isLoading = false
        
    }
    
    func fetchPokemons() async {
        //evitamos hacer una peticion si se esta ejecutando o cargando una
        
        // guard es como un if invertido. Su propósito es proteger el resto del código.
        
       // La regla del guard es: "Si esta condición NO se cumple, tienes que salirte de la función inmediatamente (usando return)".
        guard !isLoading else { return }
        
        // Optional Binding en cadena
//        guard let urlString = nextUrl, let url = URL(string: urlString) else { return }
//
        guard !isLoading, let urlString = nextUrl, let url = URL(string: urlString) else { return }
        
        isLoading = true
        errorMessage = nil
        
        print("Petition to: \(urlString)")
        
        
        do {
//            let (data, response) = try await URLSession.shared.data(from: url)
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                print("Petition  invalid")
//                errorMessage = "Error de conexión"
//                isLoading = false
//                return
//            }
//                        
//            print("Código de respuesta del servidor: \(httpResponse.statusCode)")
//            
//            if httpResponse.statusCode == 200 {
//                let decodedResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
//                
//                // Agregamos los pokémon obtenidos
//                self.pokemons.append(contentsOf: decodedResponse.results)
//                self.nextUrl = decodedResponse.next
//                print("Descargados exitosamente \(decodedResponse.results.count) Pokémon. Total actual: \(self.pokemons.count)")
//            } else {
//                errorMessage = "Error en el servidor: \(httpResponse.statusCode)"
//            }
            
            let respponse = try await pokemonApi.getPokemons(from: url)
            self.pokemons.append(contentsOf: respponse.results)
            self.nextUrl = respponse.next
            
        }catch {
            print("Error al decodificar o descargar: \(error.localizedDescription)")
            self.errorMessage = "Error: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func fetchByType (_ type: PokemonType ) async {
        
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        print(type)

        let urlString = "https://pokeapi.co/api/v2/type/\(type.rawValue)"
        guard let url = URL(string: urlString) else { return }
//        
//        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let decodedResponse = try JSONDecoder().decode(TypeDetailResponse.self, from: data)
//            // asignamos los pokemon del wrapper y sobre escribimos la lista
//            self.pokemons = decodedResponse.pokemon.map{ $0.pokemon }
//            
//            // La API te da todos los de ese tipo de un solo golpe,
//            // así que apagamos el paginado poniendo nextUrl en nil.
//            self.nextUrl = nil
//
        do {

        
            let response = try await pokemonApi.getPokemonsByType(from: url)
            self.pokemons = response.pokemon.map{ $0.pokemon }
            self.nextUrl = nil
        
            
        }catch {
            self.errorMessage = "Error cargando la Categoria"
        }
        
        isLoading = false
    }
    
    
    func changeType( to newType: PokemonType? ) async {
        self.selectedType = newType
        self.pokemons.removeAll()
        guard let type = newType else {
            self.pokemons = allPokemons
            isLoading = false
            return
        }
        
//        print("pokemons \(pokemons)")
//        print("AllPokemon \(allPokemons)")
        print( "\(type.nombreEnEspanol)" )
        
    
        isLoading = true
        self.pokemons.removeAll()
        guard let url = URL(string: "https://pokeapi.co/api/v2/type/\(type.rawValue)") else {
            isLoading = false
            return
        }
        
        do {
            let response = try await pokemonApi.getPokemonsByType(from: url)
            self.pokemons = response.pokemon.map{ $0.pokemon }
            
        }catch {
            self.errorMessage = "Error al buscar Pokémon de tipo \(type.nombreEnEspanol)."
                        print("Error: \(error)")
        }
        
        isLoading = false
        
    }
    
}
