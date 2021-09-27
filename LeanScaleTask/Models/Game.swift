//
//  Game.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 26/09/2021.
//

import Foundation
struct Game: Codable {
    var id: Int?
    var name: String?
    var slug: String?
    var backgroundImage: String?
    var metacritic: Int?
    var genres: [GameGenre]?
    var description: String?
}
