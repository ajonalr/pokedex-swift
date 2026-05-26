//
//  PokeAPIService.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 22/05/26.
//
import Foundation

// Creamos un servicio dedicado exclusivamente a hablar con la PokeAPI
struct PokeAPIService {
    
   
    func getPokemons(from url: URL) async throws -> PokemonListResponse {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(PokemonListResponse.self, from: data)
    }
    
    // Función 2: Traer Pokémon por categoría
    func getPokemonsByType(from url: URL) async throws -> TypeDetailResponse {
        let (data, reponse) = try await URLSession.shared.data(from: url)

        guard let httpResponse = reponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decodedData = JSONDecoder()
        decodedData.keyDecodingStrategy = .convertFromSnakeCase
    
         return try decodedData.decode(TypeDetailResponse.self, from: data)
        
    }
    
    func getPokemonDetail( id: Int ) async throws -> PokemonDetail {
        let urlString = "https://pokeapi.co/api/v2/pokemon/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse  = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(PokemonDetail.self, from: data)
        
    }
}
