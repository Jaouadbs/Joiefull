//
//  JoiefullApp.swift
//  Joiefull
//
//  Created by Jaouad on 16/04/2026.
//

import SwiftUI

@main
struct JoiefullApp: App {
    
    @State private var isActive = false
    @StateObject private var favoritesStore = FavoritesStore()
    @StateObject private var ratingsStore = RatingsStore()
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
                    .environmentObject(favoritesStore)
                    .environmentObject(ratingsStore)
            } else {
                LaunchView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                isActive = true
                            }
                        }
                    }
            }
        }
    }
}
