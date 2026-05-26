//
//  TabsView.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 22/05/26.
//

import SwiftUI

struct TabsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
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
            
            SettingsView()
                .tabItem{
                    Label ("Config", systemImage: "gearshape.fill")
                }
            
            MiniGameIAView()
                .tabItem{
                    Label(
                        "Jugar", systemImage: "gamecontroller.fill"
                    )
                }
            
        }
        .tint(.red)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        
       
        
    }
}

#Preview {
    TabsView()
}
