//
//  PokeAPIService.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 22/05/26.
//
import Foundation

// Creamos un servicio dedicado exclusivamente a hablar con la PokeAPI
struct PokeAPIService {
    
    // Función 1: Traer la lista general
    // Nota el "throws": esto significa que si algo falla,
    // le "aventará" el error de regreso al ViewModel para que él lo maneje.
    func getPokemons(from url: URL) async throws -> PokemonListResponse {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        // Si usas el truco del snake_case, lo pones aquí:
        // decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(PokemonListResponse.self, from: data)
    }
    
    // Función 2: Traer Pokémon por categoría
    func getPokemonsByType(from url: URL) async throws -> TypeDetailResponse {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        
        return try decoder.decode(TypeDetailResponse.self, from: data)
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
