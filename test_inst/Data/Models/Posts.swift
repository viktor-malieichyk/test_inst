//
//  Resources.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import Foundation

struct Posts: Codable {
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data: [Post]
    let support: Support

    private enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data
        case support
    }
}

struct Post: Codable {
    let id: Int32
    let name: String
    let year: Int32
    let color: String
    let pantoneValue: String

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case year
        case color
        case pantoneValue = "pantone_value"
    }
}

struct Support: Codable {
    let url: String
    let text: String
}

extension Post: Equatable {
    static func ==(lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}
