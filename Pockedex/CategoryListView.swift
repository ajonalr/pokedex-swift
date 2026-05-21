//
//  CategoryListView.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 20/05/26.
//

import SwiftUI

struct CategoryListView: View {
    
    @State private var selectedType : PokemonType? = nil
    
    var body: some View {

      ScrollView(.horizontal, showsIndicators: false) {
         
        HStack(spacing: 12) {
              
            
            // cerea el "select" en la vista
            CategoryChip(
                title: "All",
                isSelected: selectedType == nil,
                baseColor: .gray
            ){
                selectedType = nil
            }
            
         //obtenemos los enums
            ForEach(PokemonType.allCases) {tipo in CategoryChip(
                title: tipo.nombreEnEspanol,
                isSelected: selectedType == tipo,
                baseColor: tipo.colorBase,
            ) {
                selectedType = tipo
            }
                

            }
            
            
          }
        .padding(20)
          
          Spacer()
          
        }

    }
}

// componente reutilizable
struct CategoryChip: View {
    
    let title: String
    let isSelected: Bool
    let baseColor: Color
    let actionBt: ()-> Void
    
    var body : some View {
        
        Button(action: actionBt) {
            Text( title )
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .medium)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            
                // si esta el item seleccionado cambiamos de color
                .background(isSelected ? baseColor: Color.gray.opacity( 0.15))
                .foregroundStyle(isSelected ? .white: .primary)
                //sirve para ponerlo tpo pildora
                .clipShape(Capsule())
                .animation(.easeInOut(duration: 0.2), value: isSelected)
            
        }
        
    }
}

#Preview {
    CategoryListView()
}
