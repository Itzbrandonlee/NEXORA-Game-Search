//
//  GameFavorites.swift
//  NEXORA
//
//  Created by csuftitan on 4/26/26.
//

import Foundation
import SwiftUI
import Combine

class GameFavorites: ObservableObject {
    @Published var favoriteGames: [Game] = [] {
        didSet {
            saveFavorites()
        }
    }
    
    init() {
        loadFavorites()
    }
    
    func toggleFavorite(game: Game) {
        if isFavorite(game: game) {
            favoriteGames.removeAll { $0.id == game.id }
        } else {
            favoriteGames.append(game)
        }
    }
    
    func isFavorite(game: Game) -> Bool {
        favoriteGames.contains { $0.id == game.id }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteGames) {
            UserDefaults.standard.set(encoded, forKey: "favorite_games")
        }
    }
        
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "favorite_games"),
            let decoded = try? JSONDecoder().decode([Game].self, from: data) {
            favoriteGames = decoded
        }
    }
}

