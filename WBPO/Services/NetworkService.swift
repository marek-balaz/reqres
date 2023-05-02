//
//  NetworkService.swift
//  WBPO
//
//  Created by Marek Baláž on 30/04/2023.
//

import Foundation
import RxSwift
import Alamofire

enum NetworkError: Error {
    case invalidRequest
    case invalidURL
    case invalidResponse
    case apiError
    case unknown
    case taskAlreadyExists
    case noInternetConnection
}

class NetworkService {
    
    static let shared = NetworkService()

    func request<T: Codable> (url: String, method: HTTPMethod, body: [String: AnyObject]?, headers: HTTPHeaders? = nil) -> Observable<( response: T, statusCode: Int)> {
        return Observable<(response: T, statusCode: Int)>.create { observer in
            let request = AF.request(url,
                                     method: method,
                                     parameters: body,
                                     encoding: JSONEncoding.default,
                                     headers: headers)
                .responseDecodable(of: T.self)
            { response in
                switch response.result {
                case .success(let value):
                    observer.onNext((value, response.response?.statusCode ?? -1))
                    observer.onCompleted()
                case .failure(let error):
                    Log.d(error)
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func encodeObjectToDictionary<T: Encodable>(_ object: T?) -> Observable<[String: AnyObject]> {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(object) else {
            return Observable.error(NetworkError.invalidRequest)
        }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
            return Observable.error(NetworkError.invalidRequest)
        }
        return Observable.just(json)
    }
    
}


