//
//  ShortClientCaseTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 27.04.25.
//

import UIKit

final class ShortClientCaseTableViewCell: BaseTableViewCell {
    private lazy var iconImageView = UIImageView().setup {
        $0.snp.makeConstraints({ $0.size.equalTo(30) })
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor(hex: "#4B88E1")
    }
    
    private lazy var iconContentView = UIView().setup {
        $0.snp.makeConstraints({ $0.size.equalTo(60) })
        $0.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints({ $0.center.equalToSuperview() })
        $0.layer.cornerRadius = 30
        $0.layer.masksToBounds = true
    }
    
    private lazy var caseTypeLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 21, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 1
    }
    
    private lazy var startDateLabel = UILabel().setup {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor(hex: "#434D5B")
    }
    
    private lazy var textVStackView = UIStackView().setup {
        $0.axis = .vertical
        $0.spacing = 4
        $0.addArrangedSubview(self.caseTypeLabel)
        $0.addArrangedSubview(self.startDateLabel)
    }
    
    private lazy var mainContentView = UIView().setup {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#DFECFC").cgColor
        
        $0.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.verticalEdges.equalToSuperview().inset(16)
        }
        
        $0.addSubview(self.textVStackView)
        self.textVStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(18)
        }
    }
    
    var clientCase: ClientCase? {
        didSet {
            self.iconImageView.image = self.clientCase?.type.image.withRenderingMode(.alwaysTemplate)
            self.caseTypeLabel.text = self.clientCase?.type.title
            if let startDate = self.clientCase?.startDate {
                self.startDateLabel.text = "Дата начала: \(startDate.toDate(withFormat: "dd.MM.yyyy"))"
            }
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.mainContentView)
    }
    
    override func setupConstraints() {
        self.mainContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(19)
            make.verticalEdges.equalToSuperview().inset(6)
        }
    }
}
