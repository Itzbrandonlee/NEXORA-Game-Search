import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var gamesList: [Game] = [
        Game(id: 1, name: "Final Fantasy VII Rebirth", released: nil, background_image: "https://media.rawg.io/media/games/84b/84b1a4574972f85ea0101b1386455114.jpg", rating: 4.8, genres: [GenreObject(id: 1, name: "RPG")], platforms: [], developers: nil, publishers: nil),
        Game(id: 2, name: "Diablo IV", released: nil, background_image: "https://media.rawg.io/media/games/a1c/a1bea26315c13b2cebf28f4cc1f92e70.jpg", rating: 4.5, genres: [GenreObject(id: 2, name: "Action")], platforms: [], developers: nil, publishers: nil)
    ]
    
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
                    
                    
                    //.navigationTitle("Home page")
                    ScrollView{
                        VStack(spacing: 12){
                            ForEach(gamesList) { game in
                                GameCard(game: game)}
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                
            }
            .padding(.top, 10)
            
        }
    }
}

#Preview {
    HomeView()
}

