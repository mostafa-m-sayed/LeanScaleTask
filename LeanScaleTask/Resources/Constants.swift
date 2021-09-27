//
//  File.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 26/09/2021.
//

import Foundation
class Constants {
    static var shared = Constants()

    private var baseURL = "https://api.rawg.io/api/"
    let apiKey = "3be8af6ebf124ffe81d90f514e59856c"

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
