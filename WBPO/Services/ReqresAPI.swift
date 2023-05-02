//
//  NetworkConstants.swift
//  WBPO
//
//  Created by Marek Baláž on 01/05/2023.
//

import Foundation
import Alamofire

final class ReqresAPI {

    private static let baseUrl = Const.getStringFor(key: "ReqresAPI")
    
    static func headers() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        return headers
    }
    
    static func url(path: String) -> String {
        return baseUrl + "/" + path
    }

}
