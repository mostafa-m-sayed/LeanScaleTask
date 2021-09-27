//
//  File.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 26/09/2021.
//

import Foundation
class Constants {
    var baseURL = "https://api.rawg.io/api/"
    
    enum APIUrls: String {
        case games = "games"
        func getURL() -> String {
            switch self {
                case .games:
                    return "\(Constants.shared.baseURL)\(self.rawValue)"
            }
        }
    }
}
