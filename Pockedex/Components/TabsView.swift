//
//  TabsView.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 22/05/26.
//

import SwiftUI

struct TabsView: View {
    var body: some View {
        
        TabView{
            PokedexView()
                .tabItem{
                    Label(
                        "Pokedex", systemImage: "books.vertical.fill"
                    )
                }
            
            MinigameView()
                .tabItem{
                    Label(
                        "Jugar", systemImage: "gamecontroller.fill"
                    )
                }
            
        }
        .tint(.red)
        
       
        
    }
}

#Preview {
    TabsView()
}
