//
//  UsersView.swift
//  WBPO
//
//  Created by Marek Baláž on 02/05/2023.
//

import Foundation
import UIKit

class UsersView: UIView {
    
    // MARK: - Outlets
    
    @IBOutlet weak var componentContentView: UIView!
    @IBOutlet weak var tableUsers: UITableView!
    
    // MARK: - Overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    private func setupXib() {
        let view = loadXib()
        view?.frame = self.bounds
        view?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(componentContentView)
        componentContentView = view
    }
    
    private func loadXib() -> UIView? {
        Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        
        return componentContentView
    }
    
}
