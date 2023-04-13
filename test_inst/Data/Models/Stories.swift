//
//  User.swift
//  test_inst
//
//  Created by Viktor Malieichyk on 13.04.2023.
//

import Foundation

struct Stories: Codable {
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data: [UserData]
    let support: SupportData
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case data
        case support
    }
}

struct UserData: Codable {
    let id: Int32
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}

struct SupportData: Codable {
    let url: String
    let text: String
}

extension UserData: Equatable {
    static func ==(lhs: UserData, rhs: UserData) -> Bool {
        return lhs.id == rhs.id
    }
}
