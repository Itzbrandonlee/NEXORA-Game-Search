import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var suggestions: [String] = []
    @Published var recentSearches: [String] = []

    private let apiKey = "1630b9dccd12423da5a55b02f95add1a"
    private let recentsKey = "NexoraRecentSearches"
    private let maxRecents = 8

    // Holds the in-flight suggestion task so we can cancel when the user keeps typing
    private var suggestionTask: URLSessionDataTask?

    init() {
        loadRecents()
    }

    // MARK: - Main game search (used on submit)
    func fetchGames(searchText: String!) {
        let searchInput = (searchText != nil) ? "&search_precise=true&search=\(searchText ?? "")" : ""
        guard let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKey)&ordering=-rating" + searchInput) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data,
               let decoded = try? JSONDecoder().decode(GameResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.games = decoded.results
                }
            }
        }.resume()
    }

    // MARK: - Autocomplete suggestions (used while typing)
    func fetchSuggestions(for query: String) {
        // Cancel any previous request so only the most recent keystroke matters
        suggestionTask?.cancel()

        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            DispatchQueue.main.async { self.suggestions = [] }
            return
        }

        // URL-encode the query so spaces and special characters don't break the request
        guard let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.rawg.io/api/games?key=\(apiKey)&search=\(encoded)&page_size=8") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            // Ignore cancellation errors — they're expected when the user keeps typing
            if let error = error as NSError?, error.code == NSURLErrorCancelled { return }

            guard let data = data,
                  let decoded = try? JSONDecoder().decode(GameResponse.self, from: data) else { return }

            let names = decoded.results.map { $0.name }
            DispatchQueue.main.async {
                self.suggestions = names
            }
        }
        suggestionTask = task
        task.resume()
    }

    func clearSuggestions() {
        suggestionTask?.cancel()
        suggestions = []
    }

    // MARK: - Recent searches (persisted to UserDefaults)
    func addRecent(_ term: String) {
        let trimmed = term.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        // Move-to-front: remove any existing match (case-insensitive), then prepend
        recentSearches.removeAll { $0.caseInsensitiveCompare(trimmed) == .orderedSame }
        recentSearches.insert(trimmed, at: 0)
        if recentSearches.count > maxRecents {
            recentSearches = Array(recentSearches.prefix(maxRecents))
        }
        saveRecents()
    }

    func removeRecent(_ term: String) {
        recentSearches.removeAll { $0 == term }
        saveRecents()
    }

    func clearAllRecents() {
        recentSearches = []
        saveRecents()
    }

    private func loadRecents() {
        if let saved = UserDefaults.standard.array(forKey: recentsKey) as? [String] {
            recentSearches = saved
        }
    }

    private func saveRecents() {
        UserDefaults.standard.set(recentSearches, forKey: recentsKey)
    }
}
