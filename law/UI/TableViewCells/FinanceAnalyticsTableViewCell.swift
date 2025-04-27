//
//  FinanceAnalyticsTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 28.04.25.
//

import UIKit

final class FinanceAnalyticsTableViewCell: BaseTableViewCell {
    private lazy var iconImageView = UIImageView().setup {
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints({ $0.size.equalTo(36) })
    }
    
    private lazy var titleLabel = UILabel().setup {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .black
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private lazy var valueLabel = UILabel().setup {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .right
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private lazy var mainContentView = UIView().setup {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.layer.borderColor = UIColor(hex: "#ECEBEC").cgColor
        $0.layer.borderWidth = 1
        $0.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
        }
        
        $0.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(10)
            make.verticalEdges.equalToSuperview().inset(20)
        }
        
        $0.addSubview(self.valueLabel)
        self.valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.leading.equalTo(self.titleLabel.snp.trailing).offset(10)
        }
    }
    
    var financeAnaltyics: FinanceAnalyticsType? {
        didSet {
            self.iconImageView.image = self.financeAnaltyics?.icon
            self.iconImageView.isHidden = self.financeAnaltyics?.icon == nil
            self.titleLabel.text = self.financeAnaltyics?.title
            self.valueLabel.text = self.financeAnaltyics?.value
        }
    }
    
    override func setupInterface() {
        super.setupInterface()
        
        self.selectionStyle = .none
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.mainContentView)
    }
    
    override func setupConstraints() {
        self.mainContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(7)
            make.bottom.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview().inset(21)
        }
    }
}
