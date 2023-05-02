//
//  UsersController.swift
//  WBPO
//
//  Created by Marek Baláž on 01/05/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class UsersController: UIViewController {
    
    @IBOutlet weak var usersView: UsersView!
    
    private let disposeBag = DisposeBag()
    var viewModel: UsersViewModel!
    internal let userReuseIdentifier: String = "UserCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersView.tableUsers.delegate = self
        usersView.tableUsers.dataSource = self
        usersView.tableUsers.register(UINib(nibName: userReuseIdentifier, bundle: nil), forCellReuseIdentifier: userReuseIdentifier)
        setBindings()
        viewModel.fetchUsers()
    }
    
    private func setBindings() {
        
        viewModel.usersSuccess.subscribe(onNext: {
            self.usersView.tableUsers.reloadData()
        })
        .disposed(by: disposeBag)
        
        viewModel.usersError
            .subscribe(onNext: { (error, statusCode) in
                let alert = UIAlertController(title: "\(statusCode)", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}

extension UsersController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userReuseIdentifier, for: indexPath) as! UserCell
        cell.set(user: viewModel.users[indexPath.row], userViewModel: viewModel)
        
        if indexPath.row == viewModel.users.count - 1 && viewModel.didReachEnd == false {
            viewModel.page += 1
            viewModel.fetchUsers()
        }
        
        return cell
    }
    
}

