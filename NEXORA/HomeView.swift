import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [Color("NexoraBlue"), Color("NexoraPurple")],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack {
                    Text("Welcome to Nexora!")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                        .foregroundColor(.white)
                    //Search Bar
                    TextField("Search Games...", text: $searchText)
                        .padding()
                        .background(Color(.white))
                        .opacity(0.6)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    Spacer()
                    
                    //Testing API... Displays lis of games
                    List(viewModel.games) { game in
                        Text(game.name)
                    }
                    .onAppear {
                        viewModel.fetchGames()
                    }
                    
                }
                //.navigationTitle("Home page")
            }
            
        }
        
    }
}

#Preview {
    HomeView()
}

