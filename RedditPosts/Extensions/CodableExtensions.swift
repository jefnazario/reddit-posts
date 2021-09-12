//
//  CodableExtensions.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import Foundation

extension Decodable {
    init?(from json: String) throws {
        guard let data = json.data(using: .utf8) else { return nil }
        guard let value = try? JSONDecoder().decode(Self.self, from: data) else { return nil }
        self = value
    }
}
