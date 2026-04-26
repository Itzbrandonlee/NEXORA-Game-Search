import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var games: [Game] = []
    private let apiKey = "db63719dccd7411ca6d067f64f19539a"

    func fetchGames() {
        let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKey)")!

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let decoded = try? JSONDecoder().decode(GameResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.games = decoded.results
                    }
                }
            }
        }.resume()
    }
}

