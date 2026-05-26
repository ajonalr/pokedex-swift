//
//  GeminiServices.swift
//  Pockedex
//
//  Created by ari on 25/05/26.
//
import Foundation
import UIKit

class GeminiService {
    // ⚠️ Pega aquí tu API Key de Google AI Studio
    private let apiKey = ""
    
    func identifyPokemon(from image: UIImage) async throws -> String {
        // 1. Preparamos la imagen (La pasamos a Base64)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw URLError(.cannotDecodeContentData)
        }
        let base64Image = imageData.base64EncodedString()
        
        // 2. Preparamos el Prompt para la IA
        let prompt = "Eres una Pokédex experta. Analiza esta imagen y dime QUÉ Pokémon es el principal. Responde ÚNICAMENTE con el nombre del Pokémon, sin puntos, sin saludos ni explicaciones. Si no hay ningún Pokémon en la imagen, responde 'Desconocido'."
        
        // 3. Estructuramos el JSON exacto que pide la API de Gemini 1.5 Flash
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt],
                        ["inline_data": [
                            "mime_type": "image/jpeg",
                            "data": base64Image
                        ]]
                    ]
                ]
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        
        // 4. Armamos la URL con tu llave
        // Cambiamos "gemini-1.5-flash" por "gemini-flash-latest" que es la que te funcionó en la terminal
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // 5. Disparamos la petición a los servidores de Google
        let (data, _) = try await URLSession.shared.data(for: request)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🤖 RESPUESTA CRUDA DE GOOGLE: \n\(jsonString)")
        }
                
        
        // 6. Navegamos por el JSON de respuesta para extraer solo el texto
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let candidates = json["candidates"] as? [[String: Any]],
           let firstCandidate = candidates.first,
           let content = firstCandidate["content"] as? [String: Any],
           let parts = content["parts"] as? [[String: Any]],
           let firstPart = parts.first,
           let text = firstPart["text"] as? String {
            
            // Limpiamos espacios en blanco o saltos de línea que la IA pueda agregar
            return text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        return "No pude analizar la imagen."
    }
}
