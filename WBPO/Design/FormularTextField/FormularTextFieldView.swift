//
//  FormularTextField.swift
//  WBPO
//
//  Created by Marek Baláž on 01/05/2023.
//

import Foundation
import UIKit

protocol ErrorHint {
    var message: String { get }
}

enum FormularTextFieldErrorHint: ErrorHint {
    case invalidEmail
    case invalidPassword
    
    var message: String {
        switch self {
        case .invalidEmail:
            return "Email is in wrong format."
        case .invalidPassword:
            return "The password must contain at least 6 characters."
        }
    }
}

enum FormularTextFieldType {
    
    case email
    case password
    case username
    
}

class FormularTextFieldView: UIView, DesignProtocol {
    
    // MARK: Outlets
    
    @IBOutlet var contentTextFieldView              : UIView!
    @IBOutlet weak var textField                    : UITextField!
    @IBOutlet weak var placeholderLbl               : UILabel!
    @IBOutlet weak var placeholderView              : UIView!
    @IBOutlet weak var placeholderLeftConstraint    : NSLayoutConstraint!
    @IBOutlet weak var placeholderMiddleConstraint  : NSLayoutConstraint!
    @IBOutlet weak var placeholderTrailing          : NSLayoutConstraint!
    @IBOutlet weak var placeholderLeading           : NSLayoutConstraint!
    @IBOutlet weak var errorLbl                     : UILabel!
    @IBOutlet weak var rightBtn                     : UIButton!
    
    // MARK: Constants
    
    public static let HEIGHT: CGFloat = 56
    public var type: FormularTextFieldType? {
        didSet {
            setTypeSettings()
        }
    }
    
    // MARK: Setup
    
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
        contentTextFieldView = view
        addSubview(contentTextFieldView)
    }
    
    private func loadXib() -> UIView? {
        
        Bundle.main.loadNibNamed("FormularTextFieldView", owner: self, options: nil)
        
        setFonts()
        setColors()
        
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        
        textField.setLeftPaddingPoints(20)
        textField.setRightPaddingPoints(4)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        return contentTextFieldView
    }
    
    func setFonts() {
        textField.font = UIFont.systemRegular17()
        placeholderLbl.font = UIFont.systemRegular17()
    }
    
    func setColors() {
        textField.layer.borderColor = UIColor.content20.cgColor
        textField.textColor = UIColor.content
        placeholderLbl.textColor = UIColor.content20
        textField.tintColor = UIColor.content
    }
    
    func presetText(_ text: String) {
        textField.text = text
        if text == "" {
            animateTooltipToPlaceholder()
        } else {
            animatePlaceholderToTooltip()
        }
    }
    
    func setDelegate(delegate: UITextFieldDelegate) {
        textField.delegate = delegate
    }
    
    func setTypeSettings() {
        switch type {
        case .email:
            placeholderLbl.text = "Email"
            textField.keyboardType = .emailAddress
            textField.textContentType = .emailAddress
            rightBtn.isHidden = true
            createToolbar(for: textField)
        case .password:
            placeholderLbl.text = "Password"
            textField.keyboardType = .default
            textField.textContentType = .password
            textField.isSecureTextEntry = true
            textField.returnKeyType = .done
            rightBtn.isHidden = false
            createToolbar(for: textField)
        case .username:
            placeholderLbl.text = "Password"
            textField.keyboardType = .default
            textField.textContentType = .nickname
            textField.autocapitalizationType = .sentences
            textField.returnKeyType = .next
            createToolbar(for: textField)
        case .none:
            ()
        }
    }
    
    func createToolbar(for textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(resignFirstResponder))
        cancelButton.tintColor = UIColor.primary
        toolBar.setItems([cancelButton], animated: true)
        textField.inputAccessoryView = toolBar
    }
    
    @objc override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func isEmpty() -> Bool {
        return (textField.text?.isEmpty ?? true)
    }
    
    func showError(type: FormularTextFieldErrorHint) {
        errorLbl.text = type.message
        UIView.animate(withDuration: Animation.TIME) {
            self.errorLbl.isHidden = false
            self.layoutIfNeeded()
        }
    }
    
    func hideError() {
        UIView.animate(withDuration: Animation.TIME) {
            self.errorLbl.isHidden = true
            self.layoutIfNeeded()
        }
    }
    
    func animatePlaceholderToTooltip(borderColor: UIColor = UIColor.primary) {
        // Animation

        placeholderLbl.animate(font: UIFont.systemFont(ofSize: 10, weight: .regular), duration: Animation.TIME)
        textField.animateBorderColor(toColor: borderColor, duration: Animation.TIME)
        textField.animateBorderWitdh(toSize: 1.5, duration: Animation.TIME)
        
        placeholderMiddleConstraint.constant = -29 //-23
        
        UIView.transition(with: placeholderLbl, duration: Animation.TIME, options: .transitionCrossDissolve, animations: {
            self.placeholderLbl.textColor = borderColor
        }, completion: nil)
        
        UIView.animate(withDuration: Animation.TIME, animations: {
            self.layoutIfNeeded()
        }) { (true) in
            self.placeholderLeftConstraint.constant = 8
            self.placeholderLeading.constant = 13
            self.placeholderTrailing.constant = 8
            UIView.animate(withDuration: Animation.TIME, animations: {
                self.layoutIfNeeded()
            })
        }

    }
    
    func animateTooltipToPlaceholder(borderColor: UIColor = UIColor.content20) {
        
        self.placeholderLeftConstraint.constant = 0
        self.placeholderLeading.constant = 24
        self.placeholderTrailing.constant = 0
        UIView.animate(withDuration: Animation.TIME, animations: {
            self.layoutIfNeeded()
        })
        
        placeholderLbl.animate(font: UIFont.systemFont(ofSize: 15, weight: .regular), duration: Animation.TIME)
        textField.animateBorderColor(toColor: borderColor, duration: Animation.TIME)
        textField.animateBorderWitdh(toSize: 1.0, duration: Animation.TIME)
        
        placeholderMiddleConstraint.constant = 0
        
        UIView.transition(with: placeholderLbl, duration: Animation.TIME, options: .transitionCrossDissolve, animations: {
            self.placeholderLbl.textColor = borderColor
        }, completion: nil)
        
        UIView.animate(withDuration: Animation.TIME, animations: {
            self.layoutIfNeeded()
        })
        
    }
    
}

extension UILabel {
    
    func animate(font: UIFont, duration: TimeInterval) {
        let oldFrame = frame
        let labelScale = self.font.pointSize / font.pointSize
        self.font = font
        let oldTransform = transform
        transform = transform.scaledBy(x: labelScale, y: labelScale)
        let newOrigin = frame.origin
        frame.origin = oldFrame.origin
        setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration) {
            self.frame.origin = newOrigin
            self.transform = oldTransform
            self.layoutIfNeeded()
        }
    }
    
}

extension UIView {
    
    func animateBorderColor(toColor: UIColor, duration: Double) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = layer.borderColor
        animation.toValue = toColor.cgColor
        animation.duration = duration
        layer.add(animation, forKey: "borderColor")
        layer.borderColor = toColor.cgColor
    }
    
    func animateBorderWitdh(toSize: CGFloat, duration: Double) {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = 1.0
        animation.toValue = toSize
        animation.duration = duration
        layer.add(animation, forKey: "borderWidth")
        layer.borderWidth = toSize
    }
    
}

extension UITextField {
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}
