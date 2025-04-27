//
//  BaseBlueButton.swift
//  law
//
//  Created by Bahdan Piatrouski on 27.04.25.
//

import UIKit

final class BaseBlueButton: UIButton {
    init() {
        super.init(frame: .zero)
        
        self.setTitleColor(UIColor(hex: "#FFFDFD"), for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        self.backgroundColor = UIColor(hex: "#367EFF")
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.contentEdgeInsets = .init(top: 13, left: 0, bottom: 13, right: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
