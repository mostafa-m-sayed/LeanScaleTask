//
//  File.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 26/09/2021.
//

import Foundation
class Constants {
    static var shared = Constants()

    private let baseURL = Bundle.main.infoDictionary?["BASE_URL"] ?? ""
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] ?? ""

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
