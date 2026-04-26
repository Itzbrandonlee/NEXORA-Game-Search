import SwiftUI

struct GameCard: View {
    let title: String
    let imageName: String
    var body: some View {
        HStack(spacing: 15){
            ZStack{
                Color.white.opacity(0.1)
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white.opacity(0.5))
            }
            .frame(width: 60, height: 80)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6){
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption2)
                    Text("4.5")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            Text("View")
                .font(.caption.bold())
                .padding(.horizontal, 16)
                .background(Color("NexoraRed"))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.vertical, 8)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }
}


