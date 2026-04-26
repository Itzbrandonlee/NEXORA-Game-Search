import Foundation

//filter buttons on Home screen
enum Genre: String {
    case all = "All"
    case rpg = "RPG"
    case action = "Action"
    case indie = "Indie"
    case shooter = "Shooter"
}


//game data model
struct Game: Identifiable {
    var id: Int
    
    var name: String
    var description: String
    var released: String
    var imageURL: String
    var rating: Double
    var genres: [String]
    var platforms: [String]
    var developers: [String]
    var publishers: [String]
}

//converts arrays into a single string for display
extension Game {
    var genreText: String {
        return genres.joined(separator: ", ")
    }
    var platformText: String {
        return platforms.joined(separator: ", ")
    }
    var developerText: String {
        return developers.joined(separator: ", ")
    }
    var publisherText: String {
        return publishers.joined(separator: ", ")
    }
}
    
    
    
    
    

