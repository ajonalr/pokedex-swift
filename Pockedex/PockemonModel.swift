import Foundation
import SwiftUI


// no se consumio la api  "https://pokeapi.co/api/v2/type" por que son datos que no han cambiado asi no desperdiciamos recursos


enum PokemonType: String, CaseIterable, Identifiable {
    case normal, fire, water, grass, electric, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy
    
    // Identifiable requiere un id para iterar en SwiftUI
    var id: String { self.rawValue }
    
    // Traducción para la Interfaz de Usuario
    var nombreEnEspanol: String {
        switch self {
        case .normal: return "Normal"
        case .fire: return "Fuego"
        case .water: return "Agua"
        case .grass: return "Planta"
        case .electric: return "Eléctrico"
        case .ice: return "Hielo"
        case .fighting: return "Lucha"
        case .poison: return "Veneno"
        case .ground: return "Tierra"
        case .flying: return "Volador"
        case .psychic: return "Psíquico"
        case .bug: return "Bicho"
        case .rock: return "Roca"
        case .ghost: return "Fantasma"
        case .dragon: return "Dragón"
        case .dark: return "Siniestro"
        case .steel: return "Acero"
        case .fairy: return "Hada"
        }
    }
    
    // ¡Un extra! Asignar un color base de SwiftUI a cada tipo
    var colorBase: Color {
        switch self {
        case .fire: return .red
        case .water: return .blue
        case .grass: return .green
        case .electric: return .yellow
        case .poison: return .purple
        case .dark: return .black
        // ... puedes completar los demás según tu gusto de diseño
        default: return .gray
        }
    }
}



// La respuesta general de la API
struct PokemonListResponse: Codable {
    let count: Int
    let next: String? // Lo usaremos más adelante para el paginado
    let previous: String?
    let results: [PokemonResult]
}

// Cada Pokémon en la lista
struct PokemonResult: Codable, Identifiable {
    // Usamos el nombre como ID único para SwiftUI
    var id: String { name }
    let name: String
    let url: String
}
