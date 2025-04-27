//
//  NewTextTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 19.04.25.
//

import UIKit

final class NewTextTableViewCell: BaseTableViewCell {
    private lazy var titleLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 21, weight: .medium)
        $0.numberOfLines = 0
        $0.textColor = .white
    }
    
    private lazy var chevronRightImageView = UIImageView().setup {
        $0.image = UIImage(systemName: "chevron.right")?.withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22, weight: .medium)))
        $0.tintColor = UIColor(hex: "#C9D1E3")
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints { make in
            make.width.equalTo(17)
            make.height.equalTo(41)
        }
    }
    
    private lazy var mainContentView = UIView().setup {
        $0.backgroundColor = UIColor(hex: "#527AB9")
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(19)
        }
        
        $0.addSubview(self.chevronRightImageView)
        self.chevronRightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(10)
        }
    }
    
    var text: String? {
        get {
            self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.mainContentView)
    }
    
    override func setupConstraints() {
        self.mainContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(6)
        }
    }
}
