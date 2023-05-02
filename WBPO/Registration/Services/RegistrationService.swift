//
//  RegistrationService.swift
//  WBPO
//
//  Created by Marek Baláž on 01/05/2023.
//

import Foundation
import RxSwift

protocol RegistrationProtocol {
    func registration(data: RegistrationRequest) -> Observable<(response: RegistrationResponse, statusCode: Int)>
}

class RegistrationService: RegistrationProtocol {
    
    func registration(data: RegistrationRequest) -> Observable<(response: RegistrationResponse, statusCode: Int)> {
        return NetworkService.shared.encodeObjectToDictionary(data)
            .flatMap { json in
                NetworkService.shared.request(url: ReqresAPI.url(path: "register"), method: .post, body: json, headers: ReqresAPI.headers())
            }
    }

}
