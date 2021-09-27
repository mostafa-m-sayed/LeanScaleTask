//
//  GameVM.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 26/09/2021.
//

import Foundation
struct GameVM {
    var game: Game
    var id: Int {
        return game.id ?? 0
    }
    var name: String {
        return game.name ?? ""
    }

    var slug: String {
        return game.slug ?? ""
    }

    var image: String {
        return game.backgroundImage ?? ""
    }
    var description: NSAttributedString {
        return game.description?.html2AttributedString ?? NSAttributedString()
    }

    var genres: String {
        guard let gens = game.genres, gens.count > 0 else { return ""}
        return gens.compactMap {$0.name}.joined(separator: ", ")
    }
    
    var redditURL: URL? {
        return URL(string: game.redditUrl ?? "")
    }
    
    var website: URL? {
        return URL(string: game.website ?? "")
    }

    var metacritic: String? {
        if let meta = game.metacritic {
            return "\(meta)"
        }
        return nil
    }

    var viewed: Bool = false
    
    static func get(gameId: Int, completion: @escaping (_ game: GameVM?, _ error: String?) -> Void) {
        guard let url = URL(string:  "\(Constants.APIUrls.games.getURL())/\(gameId)?key=\(Constants.shared.apiKey)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data, let game: Game = data.getObject()  else {
                return
            }
            completion(GameVM(game: game), nil)
        }
        task.resume()
    }
    
    func addToFavourite() {
        let defaults = UserDefaults.standard
        var updatedGames = [Game]()

        if let games: [Game] = defaults.getObject(key: "favourite-games") {
            if games.contains(where: {$0.id == self.game.id}) {
                return
            }

            updatedGames = games
            updatedGames.append(self.game)
        } else {
            updatedGames = [self.game]
        }

        defaults.saveObject(rawData: updatedGames, forKey: "favourite-games")
    }
    
    func removeFromFavourite() {
        let defaults = UserDefaults.standard

        if var games: [Game] = defaults.getObject(key: "favourite-games") {
            games.removeAll(where: {$0.id == self.game.id})
            defaults.saveObject(rawData: games, forKey: "favourite-games")
        }
    }
}
