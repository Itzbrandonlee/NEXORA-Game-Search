//
//  FavoritesView.swift
//  NEXORA
//
//  Created by csuftitan on 4/26/26.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var gameFavorites: GameFavorites

    var body: some View {
        ZStack {
            Color("NexoraBlue").ignoresSafeArea()

            if gameFavorites.favoriteGames.isEmpty {
                Text("No favorite games yet")
                    .foregroundColor(.white.opacity(0.7))
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(gameFavorites.favoriteGames) { game in
                            NavigationLink(destination: GameDetailView(game: game)) {
                                GameCard(game: game)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Favorites")
    }
}
