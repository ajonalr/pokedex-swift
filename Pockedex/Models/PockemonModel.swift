import Foundation
import SwiftUI



// --------
// pockedex
// --------


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


struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let sprites: Sprites
    let cries: Cries?
}


struct Sprites: Codable {
    let frontDefault: String?
    // sirve para poder relacionar una llave del response del api con la propiedad del struct
//    enum CodingKeys: String, CodingKey {
//        case frontDefault = "front_default"
//    }
}

struct Cries: Codable {
    let latest: String?
}



// -----------
// tipo de pokemons
// -----------

// no se consumio la api  "https://pokeapi.co/api/v2/type" por que son datos que no han cambiado asi no desperdiciamos recursos
enum PokemonType: String, CaseIterable, Identifiable {
    case normal, fire, water, grass, electric, ice, fighting, poison, ground, flying, psychic, bug, rock, ghost, dragon, dark, steel, fairy, sincat
    
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
        case .sincat: return "Sin Categoria"
        }
    }

    
    var colorBase: Color {
        switch self {
        case .normal: return Color(red: 0.65, green: 0.65, blue: 0.47)
        case .fire: return Color(red: 0.93, green: 0.51, blue: 0.19)
        case .water: return Color(red: 0.41, green: 0.57, blue: 0.93)
        case .grass: return Color(red: 0.48, green: 0.78, blue: 0.30)
        case .electric: return Color(red: 0.97, green: 0.82, blue: 0.17)
        case .ice: return Color(red: 0.59, green: 0.85, blue: 0.85)
        case .fighting: return Color(red: 0.76, green: 0.18, blue: 0.14)
        case .poison: return Color(red: 0.64, green: 0.24, blue: 0.64)
        case .ground: return Color(red: 0.88, green: 0.75, blue: 0.40)
        case .flying: return Color(red: 0.66, green: 0.56, blue: 0.95)
        case .psychic: return Color(red: 0.98, green: 0.33, blue: 0.53)
        case .bug: return Color(red: 0.65, green: 0.73, blue: 0.10)
        case .rock: return Color(red: 0.71, green: 0.63, blue: 0.21)
        case .ghost: return Color(red: 0.44, green: 0.34, blue: 0.59)
        case .dragon: return Color(red: 0.43, green: 0.24, blue: 0.98)
        case .dark: return Color(red: 0.44, green: 0.34, blue: 0.27)
        case .steel: return Color(red: 0.72, green: 0.72, blue: 0.81)
        case .fairy: return Color(red: 0.93, green: 0.60, blue: 0.93)
        default : return Color(.black)
        }
    }
}

struct TypeDetailResponse: Codable {
    let pokemon: [TypePokemonWrapper]
}

struct TypePokemonWrapper: Codable {
    let pokemon: PokemonResult
}

 
// filtros pod categorias
enum PokemonGeneration: String, CaseIterable, Identifiable {
    case all = "Todas"
    case gen1 = "1ª Gen (Kanto)"
    case gen2 = "2ª Gen (Johto)"
    case gen3 = "3ª Gen (Hoenn)"
    case gen4 = "4ª Gen (Sinnoh)"
    case gen5 = "5ª Gen (Unova)"
    case gen6 = "6ª Gen (Kalos)"
    case gen7 = "7ª Gen (Alola)"
    case gen8 = "8ª Gen (Galar)"
    case gen9 = "9ª Gen (Paldea)"
    
    var id: String { self.rawValue }
    
    // Rangos oficiales de IDs de la Pokédex oficiales
    var idRange: ClosedRange<Int>? {
        switch self {
        case .all: return nil
        case .gen1: return 1...151
        case .gen2: return 152...251
        case .gen3: return 252...386
        case .gen4: return 387...493
        case .gen5: return 494...649
        case .gen6: return 650...721
        case .gen7: return 722...809
        case .gen8: return 810...898
        case .gen9: return 899...1025
        }
    }
}

