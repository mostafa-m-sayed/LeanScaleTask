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
        
        if paginationURL == nil {
            getCachedGames(url: originalURL, completion: completion)
        }
        
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

            self.cacheGamesList(data: data, url: originalURL)
        }
        task.resume()
    }
    
    func getCachedGames(url: String, completion: @escaping (_ success: Bool) -> Void) {
        if let cachedData = CachingController(type: .gamesList).get(url: url) {
            if let games: APIResponse = cachedData.getObject() {
                let gamesVM = games.results.map {game in
                    game.map { item in
                        GameVM(game: item)
                    }
                }
                self.games = gamesVM ?? []
                completion(true)
            }
        }
    }
    
    func cacheGamesList(data: Data, url: String) {
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            CachingController(type: .gamesList).save(response: dictionary as NSDictionary, url: url)
        } catch let error as NSError {
            print("Unable to cache list: \(error.localizedDescription)" )
        }
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
