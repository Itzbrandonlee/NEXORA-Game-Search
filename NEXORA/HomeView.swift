import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @StateObject var viewModel = GameViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color("NexoraBlue"), Color("NexoraPurple")],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack (spacing: 20){
                    Text("Welcome to Nexora!")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                    
                    //Search Bar
                    TextField("Search Games...", text: $searchText)
                        .padding()
                        .background(Color(.white))
                        .opacity(0.6)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .onSubmit {
                            print("search text submitted")
                            if !searchText.isEmpty {
                                viewModel.fetchGames(searchText: searchText)
                            }
                            searchText=""
                        }
                    Spacer()
                    

                    //GameCard List from search
                    ScrollView{
                        VStack(spacing: 12){
                            ForEach(viewModel.games) { game in
                                NavigationLink(destination: GameDetailView(game: game)){
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
                }
            }

            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    HomeView()
}

