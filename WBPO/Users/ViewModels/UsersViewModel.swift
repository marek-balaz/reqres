//
//  UsersViewModel.swift
//  WBPO
//
//  Created by Marek Baláž on 01/05/2023.
//

import Foundation
import RxSwift

class UsersViewModel {
    
    private let disposeBag = DisposeBag()
    private let usersService: UsersProtocol
    
    let usersSuccess = PublishSubject<Void>()
    let usersError = PublishSubject<(String, Int)>()
    let networkError = PublishSubject<Error>()
    let internalError = PublishSubject<Void>()
    let startLoading = PublishSubject<Void>()
    let stopLoading = PublishSubject<Void>()
    
    var users: [User] = []
    let followingDataService = FollowingDataService()
    
    public var page: Int = 1
    private let perPage: Int = 4
    var didReachEnd: Bool = false
    
    init(usersService: UsersProtocol) {
        self.usersService = usersService
    }
    
    func fetchUsers() {
        startLoading.onNext(())
        usersService.users(page: page, perPage: perPage)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] reqres in
                Log.d(reqres.statusCode)
                switch reqres.statusCode {
                case 200..<300:
                    if reqres.response.data.isEmpty {
                        self?.didReachEnd = true
                    } else {
                        self?.users += reqres.response.data
                    }
                    self?.stopLoading.onNext(())
                    self?.usersSuccess.onNext(())
                case 300..<600:
                    self?.usersError.onNext((reqres.response.error ?? "Unknown error occured.", reqres.statusCode))
                default:
                    self?.usersError.onNext(("Unknown error occured.", -1))
                }
                Log.d(reqres.response)
            }, onError: { [weak self] error in
                self?.stopLoading.onNext(())
                self?.networkError.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
}
