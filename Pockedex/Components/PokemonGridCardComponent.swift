//
//  PokemonGridCardComponent.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 21/05/26.
//

import SwiftUI

struct PokemonGridCardComponent: View {
    
    let name: String
    let imagenURL: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow( color: Color.black.opacity(0.1), radius: 5, x:0, y: 2)
            
            VStack {
               // el AsyncImage piede la imgen solo cuando se muestra en pantalla 
                AsyncImage(url: URL(string: imagenURL)) { image in
                image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 90)
                .padding(.top, 5)
                
                Spacer();
                
                ZStack {
                    Rectangle()
                        .fill(Color(UIColor.tertiarySystemBackground))
                        .frame(height: 40)
                    
                    Text(name.capitalized)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
            }
                
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        
    }
}




#Preview {
    PokemonGridCardComponent(name: "Jona", imagenURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png" )
}
