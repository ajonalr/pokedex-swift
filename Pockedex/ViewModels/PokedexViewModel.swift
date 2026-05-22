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
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    
    var nextUrl: String? = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
    // Categoría actual seleccionada (nil significa "Todos")
    var selectedType: PokemonType? = nil
    
    
    
    
    
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
        
        
        if let type = newType {
            await fetchByType(type)
        } else {
            // Si es nil ("Todos"), reiniciamos el paginado y pedimos los primeros 20
            self.nextUrl = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
            await fetchPokemons()
        }
        
    }
    
}
