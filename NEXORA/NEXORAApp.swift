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
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                HomeView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}
