import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var games: [Game] = []
    private let apiKey = "1630b9dccd12423da5a55b02f95add1a"

    func fetchGames(searchText: String!) {
        let searchInput = (searchText != nil) ? "&search_precise=true&search=\(searchText)" : ""
        let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKey)&ordering=-rating" + searchInput)!
        
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

