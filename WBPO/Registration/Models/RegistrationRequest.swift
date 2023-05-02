//
//  RegistrationReq.swift
//  WBPO
//
//  Created by Marek Baláž on 30/04/2023.
//

import Foundation

struct RegistrationRequest: Codable {
    
    let username: String?
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
        case password
    }
    
}
