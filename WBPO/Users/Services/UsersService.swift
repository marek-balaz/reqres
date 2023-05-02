//
//  UsersService.swift
//  WBPO
//
//  Created by Marek Baláž on 01/05/2023.
//

import Foundation
import RxSwift

protocol UsersProtocol {
    func users(page: Int, perPage: Int) -> Observable<(response: UsersResponse, statusCode: Int)>
}

class UsersService: UsersProtocol {
    
    func users(page: Int, perPage: Int) -> Observable<(response: UsersResponse, statusCode: Int)> {
        return NetworkService.shared.request(url: ReqresAPI.url(path: "users?page=\(page)&per_page=\(perPage)"), method: .get, body: nil, headers: ReqresAPI.headers())
    }

}
