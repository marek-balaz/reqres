//
//  RegistrationAns.swift
//  WBPO
//
//  Created by Marek Baláž on 30/04/2023.
//

import Foundation

struct RegistrationResponse: Codable {
    
    let id: Int?
    let token: String?
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case token
        case error
    }
}
