//
//  BaseTextField.swift
//  law
//
//  Created by Bahdan Piatrouski on 19.04.25.
//

import UIKit

final class BaseTextField: BaseView {
    private lazy var titleLabel = UILabel().setup {
        $0.textColor = UIColor(hex: "#000005")
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 22, weight: .regular)
    }
    
    private lazy var textField = UITextField().setup {
        $0.font = .systemFont(ofSize: 22, weight: .regular)
        $0.textColor = UIColor(hex: "#000005")
    }
    
    private lazy var textFieldBorderView = UIView().setup {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#C9E4FF").cgColor
        $0.addSubview(self.textField)
        self.textField.snp.makeConstraints({ $0.edges.equalToSuperview().inset(14) })
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    var title: String? {
        get {
            self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
    var attributedPlaceholder: NSAttributedString? {
        get {
            self.textField.attributedPlaceholder
        }
        set {
            self.textField.attributedPlaceholder = newValue
        }
    }
    
    var text: String? {
        get {
            self.textField.text
        }
        set {
            self.textField.text = newValue
        }
    }
    
    var isSecureTextEntry: Bool {
        get {
            self.textField.isSecureTextEntry
        }
        set {
            self.textField.isSecureTextEntry = newValue
        }
    }
    
    override func setupInterface() {
        super.setupInterface()
        
        self.backgroundColor = .clear
    }
    
    override func setupLayout() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.textFieldBorderView)
    }
    
    override func setupConstraints() {
        self.titleLabel.snp.makeConstraints({ $0.top.horizontalEdges.equalToSuperview() })
        self.textFieldBorderView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(9)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
