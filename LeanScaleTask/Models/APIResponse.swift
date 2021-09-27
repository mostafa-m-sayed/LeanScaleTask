//
//  APIResponse.swift
//  LeanScaleTask
//
//  Created by Mostafa Sayed on 26/09/2021.
//

import Foundation
struct APIResponse: Codable {
    var count: Int?
    var next: String?
    var results: [Game]?
}
