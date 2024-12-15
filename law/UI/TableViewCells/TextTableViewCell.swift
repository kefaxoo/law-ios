//
//  TextTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit
import SnapKit

final class TextTableViewCell: BaseTableViewCell {
    private lazy var titleLabel = UILabel().setup({ $0.numberOfLines = 0 })
    
    var text: String? {
        get {
            self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.titleLabel)
    }
    
    override func setupConstraints() {
        self.titleLabel.snp.makeConstraints({ $0.edges.equalToSuperview().inset(8) })
    }
}
