//
//  MiniGameViewMondel.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 22/05/26.
//

import Foundation

@MainActor
@Observable
class MiniGameViewMondel {
    
    private let pokemonApi = PokeAPIService()
    
    var options : [PokemonDetail] = []
    var correctAnswer: PokemonDetail? = nil
    var isRevealed = false
    var isLoading = false
    var score = 0
    
    
    
    func startNewRoun() async {
        isLoading = true
        isRevealed = false
        // elimina todas las opciones si existe alguna
        options.removeAll()
        
        // 1. LA REGLA DEL 5% DE CHARIZARD
        // Generamos un número del 1 al 100. Si es 5 o menor, ¡toca Charizard!
        let isCharizardLucky = Int.random(in: 1...100) <= 50
        
        var randomIDs: [Int] = []
        
        if isCharizardLucky {
            randomIDs.append(6) // El ID oficial de Charizard es el 6
        }
        
        // 2. Llenamos el resto con IDs aleatorios (del 1 al 1000)
        while randomIDs.count < 4 {
            let randomID = Int.random(in: 1...1000)
            // Evitamos que se repita el mismo Pokémon en los botones
            if !randomIDs.contains(randomID) && randomID != 6 {
                randomIDs.append(randomID)
            }
        }
        
        // Mezclamos los IDs para que la respuesta correcta no siempre sea el botón 1
        randomIDs.shuffle()
        
        // 3. Descargamos los datos de los 4 Pokémon
        do {
            for id in randomIDs {
                let detail = try await pokemonApi.getPokemonDetail(id: id)
                options.append(detail)
            }
            
            // Seleccionamos uno al azar para que sea la respuesta correcta
            // (Si salió Charizard, forzamos a que él sea la respuesta)
            if isCharizardLucky {
                correctAnswer = options.first(where: { $0.id == 6 })
            } else {
                correctAnswer = options.randomElement()
            }
            
        } catch {
            print("Error cargando el minijuego: \(error)")
        }
        
        isLoading = false
        
    }
    
    // Función para revisar si el usuario tocó el botón correcto
        func checkAnswer(selectedId: Int) {
            if selectedId == correctAnswer?.id {
                score += 1
                print("¡Correcto!")
            } else {
                score = 0 // Reiniciamos el puntaje si falla
                print("¡Fallaste!")
            }
            isRevealed = true // Revelamos la silueta
        }
    
    
    
    
}
