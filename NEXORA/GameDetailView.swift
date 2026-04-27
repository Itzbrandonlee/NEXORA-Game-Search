import SwiftUI

struct GameDetailView: View {
    let game: Game
    @State private var isFavorite = false
    
    var body: some View {
        ZStack {
            Color("NexoraBlue").ignoresSafeArea()
            
            ScrollView{
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: game.background_image ?? "")) { phase in
                            if let image = phase.image {
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else if phase.error != nil {
                                Color.white.opacity(0.1)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(height: 350)
                        .clipped()
                        
                        LinearGradient (colors: [.clear, Color("NexoraBlue")],
                                        startPoint: .center, endPoint: .bottom)
                        .frame(height: 150)
                    }
                    
                    VStack (alignment: .leading, spacing: 15) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(game.name)
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                            HStack(spacing: 15) {
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill").foregroundColor(.yellow)
                                    Text(String(format: "%.1f", game.rating))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.black.opacity(0.4))
                                .cornerRadius(8)
                                
                                if let releaseDate = game.released {
                                    Text("Released: , \(releaseDate)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(game.genres, id: \.id) { genre in
                                    Text(genre.name)
                                        .font(.caption.bold())
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color("NexoraPurple").opacity(0.3))
                                        .foregroundColor(Color("NexoraPurple").opacity(0.9))
                                        .overlay(
                                            Capsule().stroke(Color("NexoraPurple").opacity(0.5), lineWidth: 1)
                                        )
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Game Details")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            
                            DetailRow(title: "Platforms", text: game.platformText)
                            Divider().background(Color.white.opacity(0.1))
                            DetailRow(title: "Developer", text: game.developerText)
                            Divider().background(Color.white.opacity(0.1))
                            DetailRow(title: "Publisher", text: game.publisherText)
                        }
                        .padding(20)
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                        
                        // Add to Favorites button
                        Button(action: {
                            isFavorite.toggle()
                        }) {
                            HStack(spacing: 10) {
                                Text(isFavorite ? "ADDED TO FAVORITES" : "ADD TO FAVORITES")
                                    .font(.headline)
                                    .tracking(1.2)
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(isFavorite ? Color("NexoraRed") : .white)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                isFavorite
                                ? AnyShapeStyle(Color("NexoraPurple"))
                                : AnyShapeStyle(Color.white.opacity(0.05))
                            )
                            .cornerRadius(14)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color("NexoraBlue"), Color("NexoraPurple")],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                        }
                        .padding(.top, 8)
                        
                        
                    }
                    .padding(.horizontal, 20)
                    .offset(y: -20)
                }
            }
        }
        .toolbarBackground(Color("NexoraBlue"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
    }
}
    
    
struct DetailRow: View {
    let title: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(width: 90, alignment: .leading)
                
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
    
#Preview {
    let mockGame = Game(
        id: 1,
        name: "Cyberpunk 2077",
        released: "2020-12-10",
        background_image:"https://media.rawg.io/media/games/26d/26d440a0eeed5cbd6e0c8b93060c4109.jpg",
        rating: 4.8,
        genres: [GenreObject(id: 1, name: "RPG"), GenreObject(id: 2, name: "Action")],
        platforms: [PlatformWrapper(platform: PlatformObject(id: 1, name: "PC")),
                        PlatformWrapper(platform: PlatformObject(id: 2, name: "PlayStation 5"))],
        developers: ["CD PROJEKT RED"],
        publishers: ["CD PROJEKT RED"]
        )
    GameDetailView(game: mockGame)
}

