//
//  CategoryListView.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 20/05/26.
//

import SwiftUI

struct CategoryListView: View {
    
    // 1. Quitamos el @State privado
//    @State private var selectedType : PokemonType? = nil
    // y pedimos que nos pasen el ViewModel desde afuera
    var viewModel: PokedexViewModel
    
    var body: some View {

      ScrollView(.horizontal, showsIndicators: false) {
         
        HStack(spacing: 10) {
            
            // cerea el "select" en la vista
            CategoryChip(
                title: "All",
                isSelected: viewModel.selectedType == nil,
                baseColor: .gray
            ){
                Task {
                    await viewModel.changeType(to: nil)
                }
            }
            
         //obtenemos los enums
            ForEach(PokemonType.allCases) {tipo in CategoryChip(
                title: tipo.nombreEnEspanol,
                isSelected: viewModel.selectedType == tipo,
                baseColor: tipo.colorBase,
            ) {
                Task{ await viewModel.changeType(to: tipo) }
                }
            }
          }
        .padding(.horizontal, 2)
        .padding(.vertical, 1)
        .onAppear{ print("on appear") }
          
//          Spacer()
          
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
    CategoryListView(viewModel: PokedexViewModel())
}
