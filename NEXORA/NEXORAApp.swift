//
//  NEXORAApp.swift
//  NEXORA
//
//  Created by csuftitan on 4/20/26.
//

import SwiftUI

@main
struct NEXORAApp: App {
    @State private var isLoggedIn: Bool = false
    @StateObject var gameFavorites = GameFavorites()
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                HomeView().environmentObject(gameFavorites)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
