//
//  BaseView.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

class BaseView: UIView {
    init() {
        super.init(frame: .zero)
        
        self.setupInterface()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInterface() {
        self.setupLayout()
        self.setupConstraints()
    }
    
    func setupLayout() {}
    func setupConstraints() {}
}
