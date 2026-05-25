//
//  PockedexApp.swift
//  Pockedex
//
//  Created by Ariel Ramirez on 20/05/26.
//

import SwiftUI

@main
struct PockedexApp: App {
    
//    init() {
//        
////        AudioComponent.shared.startBGM()
//    }
    
    
    //  Leemos la misma llave que usamos en SettingsView
        @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    

    var body: some Scene {
        WindowGroup {
            
            TabsView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .onAppear{
                    AudioComponent.shared.startBGM()
                }
           
            
        }
    }
}
