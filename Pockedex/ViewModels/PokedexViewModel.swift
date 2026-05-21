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
    
    var pokemons: [PokemonResult] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    
    var nextUrl: String? = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"

    
    func fetchPokemons() async {
        //evitamos hacer una peticion si se esta ejecutando o cargando una
        
        // guard es como un if invertido. Su propósito es proteger el resto del código.
        
       // La regla del guard es: "Si esta condición NO se cumple, tienes que salirte de la función inmediatamente (usando return)".
        guard !isLoading else { return }
        
        // Optional Binding en cadena
        guard let urlString = nextUrl, let url = URL(string: urlString) else { return }
                
        isLoading = true
        errorMessage = nil
        
        print("Petitio to: \(urlString)")
        
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Petition  invalid")
                errorMessage = "Error de conexión"
                isLoading = false
                return
            }
                        
            print("Código de respuesta del servidor: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200 {
                let decodedResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                
                // Agregamos los pokémon obtenidos
                self.pokemons.append(contentsOf: decodedResponse.results)
                self.nextUrl = decodedResponse.next
                print("✅ Descargados exitosamente \(decodedResponse.results.count) Pokémon. Total actual: \(self.pokemons.count)")
            } else {
                errorMessage = "Error en el servidor: \(httpResponse.statusCode)"
            }
            
            
        }catch {
            print("Error al decodificar o descargar: \(error.localizedDescription)")
            self.errorMessage = "Error: \(error.localizedDescription)"        }
        isLoading = false
    }
    
}
