//
//  AppCoordinator.swift
//  WBPO
//
//  Created by Marek Baláž on 30/04/2023.
//

import Foundation
import UIKit
import RxSwift

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
 
class AppCoordinator: Coordinator {
    private let disposeBag = DisposeBag()
    private var window = UIWindow(frame: UIScreen.main.bounds)
    
    var navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
        window.rootViewController = navigationController
    }
    
    func start() {
        showUsers()
        // UserDefaults.standard.set(nil, forKey: "token")
        if UserDefaults.standard.string(forKey: "token") == nil {
            showRegistration()
        }
    }
    
    func showRegistration() {
        let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        guard let registrationController = viewController as? RegistrationController else { return }

        let registrationViewModel = RegistrationViewModel(registrationService: RegistrationService())
        registrationController.viewModel = registrationViewModel

        registrationViewModel.registrationSuccess
            .subscribe(onNext: { [weak self] in
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(registrationController, animated: true)
    }
    
    func showUsers() {
        let viewController = UIStoryboard.init(name: "Users", bundle: nil).instantiateInitialViewController()
        guard let usersController = viewController as? UsersController else { return }
        
        let usersViewModel = UsersViewModel(usersService: UsersService())
        usersController.viewModel = usersViewModel
        
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(usersController, animated: true)
    }
}
