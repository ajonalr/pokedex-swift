//
//  PokemonGridCardComponent.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 21/05/26.
//

import SwiftUI

struct PokemonGridCardComponent: View {
    
    let name: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow( color: Color.black.opacity(0.1), radius: 5, x:0, y: 2)
            
            VStack {
                Image(systemName: "circle.grid.hex.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray.opacity(0.3))
                    .padding(.top, 20)
                
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
    PokemonGridCardComponent(name: "Jona" )
}
