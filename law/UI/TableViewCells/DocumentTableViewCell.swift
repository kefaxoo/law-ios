//
//  DocumentTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 27.04.25.
//

import UIKit

final class DocumentTableViewCell: BaseTableViewCell {
    private lazy var iconImageView = UIImageView().setup {
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints({ $0.size.equalTo(40) })
        $0.image = .documentIcon.withRenderingMode(.alwaysTemplate)
        $0.tintColor = UIColor(hex: "#367EFF")
    }
    
    private lazy var titleLabel = UILabel().setup {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 19, weight: .medium)
        $0.textColor = .black
    }
    
    private lazy var typeLabel = UILabel().setup {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = UIColor(hex: "#2F2D2F")
    }
    
    private lazy var textVStackView = UIStackView().setup {
        $0.axis = .vertical
        $0.spacing = 3
        $0.addArrangedSubview(self.titleLabel)
        $0.addArrangedSubview(self.typeLabel)
    }
    
    private lazy var mainContentView = UIView().setup {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor(hex: "#D8DBE1").cgColor
        $0.layer.borderWidth = 1
        
        $0.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
        }
        
        $0.addSubview(self.textVStackView)
        self.textVStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(17)
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(18)
        }
    }
    
    var document: ClientDocument? {
        didSet {
            self.titleLabel.text = self.document?.title
            if let type = self.document?.type {
                self.typeLabel.text = "Тип документа: \(type.title)"
            }
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.mainContentView)
    }
    
    override func setupConstraints() {
        self.mainContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(6)
        }
    }
}
