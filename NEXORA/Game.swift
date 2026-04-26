import Foundation

//filter buttons on Home screen
enum Genre: String {
    case all = "All"
    case rpg = "RPG"
    case action = "Action"
    case indie = "Indie"
    case shooter = "Shooter"
}

//RAWG API nested structures
struct GenreObject: Codable {
    let id: Int
    let name: String
}

struct PlatformWrapper: Codable {
    let platform: PlatformObject
}

struct PlatformObject: Codable {
    let id: Int
    let name: String
}

//game data model
struct Game: Identifiable, Codable {
    var id: Int
    var name: String
    var released: String?
    var background_image: String?
    var rating: Double
    var genres: [GenreObject]
    var platforms: [PlatformWrapper]
    var developers: [String]?
    var publishers: [String]?
}

//converts arrays into a string for UI display
extension Game {
    var genreText: String {
        genres.map { $0.name }.joined(separator: ", ")
    }
    var platformText: String {
        platforms.map { $0.platform.name }.joined(separator: ", ")
    }
    var developerText: String {
        developers?.joined(separator: ", ") ?? "N/A"
    }
    var publisherText: String {
        publishers?.joined(separator: ", ") ?? "N/A"
    }
}

struct GameListResponse: Codable {
    let count: Int
    let results: [Game]
}
    
struct GameResponse: Decodable {
    let results: [Game]
}
    
    

