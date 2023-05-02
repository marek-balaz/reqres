//
//  RegistrationViewModel.swift
//  WBPO
//
//  Created by Marek Baláž on 30/04/2023.
//

import Foundation
import RxSwift

class RegistrationViewModel {
    
    private let disposeBag = DisposeBag()
    private let registrationService: RegistrationProtocol
    
    let emailAddress = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")
    
    var isValidForm: Observable<Bool> {
        return Observable.combineLatest(emailAddress, password) {
            email, password in
            return email.isValidEmail() && password.isValidPassword()
        }
    }

    let registrationSuccess = PublishSubject<Void>()
    let registrationError = PublishSubject<(String, Int)>()
    let networkError = PublishSubject<Error>()
    let internalError = PublishSubject<Void>()
    let startLoading = PublishSubject<Void>()
    let stopLoading = PublishSubject<Void>()
    
    init(registrationService: RegistrationProtocol) {
        self.registrationService = registrationService
    }
    
    func registrationBtnAction() {
        do {
            let email = try emailAddress.value()
            let password = try password.value()
            
            startLoading.onNext(())
            registrationService.registration(data: RegistrationRequest(username: nil, email: email, password: password))
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] reqres in
                    Log.d(reqres.statusCode)
                    switch reqres.statusCode {
                    case 200..<300:
                        UserDefaults.standard.set(reqres.response.token, forKey: "token")
                        self?.stopLoading.onNext(())
                        self?.registrationSuccess.onNext(())
                    case 300..<600:
                        self?.registrationError.onNext((reqres.response.error ?? "Unknown error occured.", reqres.statusCode))
                    default:
                        self?.registrationError.onNext(("Unknown error occured.", -1))
                    }
                    Log.d(reqres.response.token ?? -1)
                }, onError: { [weak self] error in
                    self?.stopLoading.onNext(())
                    self?.networkError.onNext(error)
                })
                .disposed(by: disposeBag)
            
        } catch {
            Log.d("Error in email or password.")
            internalError.onNext(())
        }
        
    }
}
