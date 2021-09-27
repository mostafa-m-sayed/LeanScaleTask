//
//  GameListVM.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 26/09/2021.
//

import Foundation
class GameListVM {
    var games = [GameVM]()
    var paginationURL: String? = nil
    var searchTerm: String = ""

    func getGames(completion: @escaping (_ success: Bool) -> Void) {
        let originalURL = "\(Constants.APIUrls.games.getURL())?page_size=10&page=1&search=\(searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")&key=\(Constants.shared.apiKey)"

        guard let url = URL(string:  paginationURL ?? originalURL) else { return }
        

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data, let games: APIResponse = data.getObject()  else { return }
            let gamesVM = games.results.map {game in
                game.map { item in
                    GameVM(game: item)
                }
            }
            self.paginationURL == nil ? {
                self.games = gamesVM ?? []
            }() : {
                self.games.append(contentsOf: gamesVM ?? [])
            }()
            self.paginationURL = games.next
            completion(true)
        }
        task.resume()
    }
    
    func getFavouriteGames() {
        let defaults = UserDefaults.standard
        if let games: [Game] = defaults.getObject(key: "favourite-games") {
            self.games = games.map {GameVM(game: $0)}
        }
        else {
            self.games = [GameVM]()
        }
    }
}
