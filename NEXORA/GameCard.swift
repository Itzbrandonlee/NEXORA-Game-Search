import SwiftUI

struct GameCard: View {
    let game: Game
    var body: some View {
        HStack(spacing: 15){
            AsyncImage(url: URL(string: game.background_image ?? "")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else if phase.error != nil {
                                Color.white.opacity(0.1)
                                    .overlay(Image(systemName: "exclamationmark.triangle").foregroundColor(.gray))
                            } else {
                                ProgressView() 
                            }
                        }
                        .frame(width: 60, height: 80)
                        .cornerRadius(8)
                        .clipped()
            
            VStack(alignment: .leading, spacing: 6){
                Text(game.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption2)
                    Text(String(format: "%.1f", game.rating))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Text("• \(game.genreText)")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                }
            }
            
            Spacer()
            Text("View")
                .font(.caption.bold())
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color("NexoraRed"))
                .foregroundColor(.white)
                .cornerRadius(8)
                
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}


