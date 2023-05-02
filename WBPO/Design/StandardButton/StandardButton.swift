//
//  StandardButton.swift
//  WBPO
//
//  Created by Marek Baláž on 01/05/2023.
//

import Foundation
import UIKit

enum StandardButtonState {
    
    case loading
    case enabled
    case disabled
    
}

class StandardButton: UIView, DesignProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet weak var componentContentView: UIView!
    
    @IBOutlet weak var loadingIndicator : UIActivityIndicatorView!
    @IBOutlet weak var button           : UIButton!
    
    // MARK: - Constants
    
    let HEIGHT: CGFloat = 56
    
    // MARK: - Variables
    
    var title: String = "" {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }
    var state: StandardButtonState = .enabled {
        didSet {
            switch state {
            case .loading:
                button.setTitle(nil, for: .normal)
                button.layer.backgroundColor = UIColor.primary.cgColor
                loadingIndicator.startAnimating()
                loadingIndicator.isHidden = false
            case .enabled:
                button.setTitle(title, for: .normal)
                button.layer.backgroundColor = UIColor.primary.cgColor
                loadingIndicator.isHidden = true
                stateBeforeLoading = .enabled
            case .disabled:
                button.setTitle(title, for: .normal)
                button.layer.backgroundColor = UIColor.primaryDisabled.cgColor
                loadingIndicator.isHidden = true
                stateBeforeLoading = .disabled
            }
        }
    }
    var stateBeforeLoading: StandardButtonState = .enabled
    
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
        
        setColors()
        setFonts()
        button.layer.cornerRadius = 4
        
        return componentContentView
    }
    
    func setFonts() {
        button.titleLabel?.font = UIFont.systemRegular17()
    }
    
    func setColors() {
        button.layer.backgroundColor = UIColor.primary.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
}
