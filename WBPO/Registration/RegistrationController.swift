//
//  ViewController.swift
//  WBPO
//
//  Created by Marek Baláž on 01/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class RegistrationController: UIViewController {
    
    @IBOutlet weak var registrationView: RegistrationView!
    
    private let disposeBag = DisposeBag()
    var viewModel: RegistrationViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registrationView.emailView.type = .email
        registrationView.passwordView.type = .password
        registrationView.registrationBtn.state = .disabled
        registrationView.registrationBtn.title = "Continue"
        setBindings()
        
        // eve.holt@reqres.in
        // pistol
    }

    private func setBindings() {
        
        registrationView.emailView.textField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.emailAddress)
            .disposed(by: disposeBag)
        
        registrationView.passwordView.textField
            .rx
            .text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        registrationView.emailView.textField.rx
            .controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe { [weak self] _ in
                guard let self = self else {
                    return
                }
                if self.registrationView.emailView.isEmpty() {
                    self.registrationView.emailView.animatePlaceholderToTooltip()
                }
            }
            .disposed(by: disposeBag)
        
        registrationView.emailView.textField.rx
            .controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe { [weak self] _ in
                guard let self = self else {
                    return
                }
                if self.registrationView.emailView.isEmpty() {
                    self.registrationView.emailView.animateTooltipToPlaceholder()
                } else {
                    if self.registrationView.emailView.textField.text?.isValidEmail() == false {
                        self.registrationView.emailView.showError(type: .invalidEmail)
                    } else {
                        self.registrationView.emailView.hideError()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        registrationView.passwordView.textField.rx
            .controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe { [weak self] _ in
                guard let self = self else {
                    return
                }
                if self.registrationView.passwordView.isEmpty() {
                    self.registrationView.passwordView.animatePlaceholderToTooltip()
                }
            }
            .disposed(by: disposeBag)
        
        registrationView.passwordView.textField.rx
            .controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe { [weak self] _ in
                guard let self = self else {
                    return
                }
                if self.registrationView.passwordView.isEmpty() {
                    self.registrationView.passwordView.animateTooltipToPlaceholder()
                } else {
                    if self.registrationView.passwordView.textField.text?.isValidPassword() == false {
                        self.registrationView.passwordView.showError(type: .invalidPassword)
                    } else {
                        self.registrationView.passwordView.hideError()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        registrationView.registrationBtn.button.rx.tap
            .bind { [weak self] in
                self?.view.endEditing(true)
                self?.viewModel.registrationBtnAction()
            }
            .disposed(by: disposeBag)
        
        viewModel.startLoading.bind(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.registrationView.registrationBtn.state = .loading
        })
        .disposed(by: disposeBag)
        
        viewModel.stopLoading.bind(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.registrationView.registrationBtn.state = self.registrationView.registrationBtn.stateBeforeLoading
        })
        .disposed(by: disposeBag)
        
        viewModel.isValidForm.bind(onNext: {
            [weak self] bool in if bool {
                self?.registrationView.registrationBtn.state = .enabled
            } else {
                self?.registrationView.registrationBtn.state = .disabled
            }
        })
            .disposed(by: disposeBag)
        
        viewModel.registrationError
            .subscribe(onNext: { (error, statusCode) in
                let alert = UIAlertController(title: "\(statusCode)", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.networkError
            .subscribe(onNext: { error in
                let alert = UIAlertController(title: "", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
}
