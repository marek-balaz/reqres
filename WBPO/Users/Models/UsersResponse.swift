//
//  UsersResponse.swift
//  WBPO
//
//  Created by Marek Baláž on 01/05/2023.
//

import Foundation

struct User: Codable {
    
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
    var isFollowing: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
    
    mutating func followUnfollow() {
        if isFollowing {
            self.isFollowing = false
        } else {
            self.isFollowing = true
        }
    }
    
    mutating func follow() {
        self.isFollowing = true
    }
    
    mutating func unfollow() {
        self.isFollowing = true
    }
    
}

struct UsersResponse: Codable {
    
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let error: String?
    let data: [User]
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case totalPages = "total_pages"
        case error
        case data
    }
    
}

