import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    // Used to debounce autocomplete requests so we don't hit the API on every keystroke
    @State private var debounceTask: DispatchWorkItem?

    @StateObject var viewModel = GameViewModel()

    // Whether to show the dropdown (recents OR live suggestions)
    private var shouldShowDropdown: Bool {
        guard isSearchFocused else { return false }
        if searchText.isEmpty {
            return !viewModel.recentSearches.isEmpty
        }
        return !viewModel.suggestions.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color("NexoraBlue"), Color("NexoraPurple")],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Welcome to Nexora!")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .foregroundColor(.white)

                    // Search Bar + dropdown stacked together
                    VStack(spacing: 0) {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search Games...", text: $searchText)
                                .focused($isSearchFocused)
                                .submitLabel(.search)
                                .onSubmit { runSearch(with: searchText) }
                                .onChange(of: searchText) { _, newValue in
                                    scheduleSuggestionFetch(for: newValue)
                                }
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                    viewModel.clearSuggestions()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                        // Dropdown
                        if shouldShowDropdown {
                            suggestionsDropdown
                                .padding(.horizontal)
                                .padding(.top, 6)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .animation(.easeInOut(duration: 0.15), value: shouldShowDropdown)
                    .zIndex(1) // keep dropdown above the results list

                    // GameCard List from search
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.games) { game in
                                NavigationLink(destination: GameDetailView(game: game)) {
                                    GameCard(game: game)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    .onAppear {
                        viewModel.fetchGames(searchText: nil)
                    }
                    // Tapping the results area dismisses the keyboard / dropdown
                    .onTapGesture {
                        isSearchFocused = false
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    // MARK: - Dropdown content
    @ViewBuilder
    private var suggestionsDropdown: some View {
        VStack(spacing: 0) {
            if searchText.isEmpty {
                // Header for recent searches with a "Clear All" button
                HStack {
                    Text("Recent Searches")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    Spacer()
                    Button("Clear All") {
                        viewModel.clearAllRecents()
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)

                Divider()

                ForEach(viewModel.recentSearches, id: \.self) { term in
                    recentRow(term: term)
                    if term != viewModel.recentSearches.last {
                        Divider().padding(.leading, 44)
                    }
                }
            } else {
                ForEach(viewModel.suggestions, id: \.self) { name in
                    suggestionRow(name: name)
                    if name != viewModel.suggestions.last {
                        Divider().padding(.leading, 44)
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }

    private func recentRow(term: String) -> some View {
        HStack {
            Image(systemName: "clock.arrow.circlepath")
                .foregroundColor(.gray)
                .frame(width: 20)
            Text(term)
                .foregroundColor(.primary)
            Spacer()
            Button {
                viewModel.removeRecent(term)
            } label: {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(8) // larger tap target
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .contentShape(Rectangle()) // make whole row tappable
        .onTapGesture {
            searchText = term
            runSearch(with: term)
        }
    }

    private func suggestionRow(name: String) -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .frame(width: 20)
            highlightedText(for: name, query: searchText)
                .foregroundColor(.primary)
            Spacer()
            // Tapping this fills the search bar so the user can edit before searching,
            // mirroring the up-arrow behavior in Google/YouTube.
            Button {
                searchText = name
            } label: {
                Image(systemName: "arrow.up.left")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .onTapGesture {
            runSearch(with: name)
        }
    }

    // Bolds the portion of the suggestion that matches what the user typed
    private func highlightedText(for full: String, query: String) -> Text {
        guard let range = full.range(of: query, options: .caseInsensitive) else {
            return Text(full)
        }
        let before = String(full[..<range.lowerBound])
        let match = String(full[range])
        let after = String(full[range.upperBound...])
        return Text(before) + Text(match).bold() + Text(after)
    }

    // MARK: - Actions
    private func runSearch(with term: String) {
        let trimmed = term.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }

        viewModel.addRecent(trimmed)
        viewModel.fetchGames(searchText: trimmed)
        viewModel.clearSuggestions()

        searchText = ""
        isSearchFocused = false
    }

    // Debounce: wait ~300ms after the last keystroke before hitting the API
    private func scheduleSuggestionFetch(for query: String) {
        debounceTask?.cancel()
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            viewModel.clearSuggestions()
            return
        }
        let task = DispatchWorkItem {
            viewModel.fetchSuggestions(for: trimmed)
        }
        debounceTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
}

#Preview {
    HomeView()
}
