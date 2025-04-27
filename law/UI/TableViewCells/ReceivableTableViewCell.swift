//
//  ReceivableTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 28.04.25.
//

import UIKit

final class ReceivableTableViewCell: BaseTableViewCell {
    private lazy var personImageView = UIImageView().setup {
        $0.contentMode = .scaleAspectFit
        $0.snp.makeConstraints({ $0.size.equalTo(49) })
        $0.image = .fillClientInfo
    }
    
    private lazy var clientLabel = UILabel().setup {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 21, weight: .medium)
        $0.textColor = .black
    }
    
    private lazy var debtTitleLabel = UILabel().setup {
        $0.numberOfLines = 1
        $0.text = "Долг"
        $0.font = .systemFont(ofSize: 18)
        $0.textColor = UIColor(hex: "#3B3D3D")
    }
    
    private lazy var debtLabel = UILabel().setup {
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 19, weight: .medium)
        $0.textColor = .black
    }
    
    private lazy var debtHStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.addArrangedSubview(self.debtTitleLabel)
        $0.addArrangedSubview(self.debtLabel)
    }
    
    private lazy var textVStackView = UIStackView().setup {
        $0.axis = .vertical
        $0.spacing = 6
        $0.addArrangedSubview(self.clientLabel)
        $0.addArrangedSubview(self.debtHStackView)
    }
    
    private lazy var mainContentView = UIView().setup {
        $0.backgroundColor = UIColor(hex: "#FBF9FF")
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.addSubview(self.personImageView)
        self.personImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        $0.addSubview(self.textVStackView)
        self.textVStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.personImageView.snp.trailing).offset(13)
            make.top.equalToSuperview().inset(17)
            make.bottom.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(13)
        }
    }
    
    var clientDebt: (ClientInfo, Double)? {
        didSet {
            guard let clientDebt else { return }
            
            self.clientLabel.text = clientDebt.0.fullName
            self.debtLabel.text = "\(clientDebt.1)"
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.mainContentView)
    }
    
    override func setupConstraints() {
        self.mainContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(17)
            make.verticalEdges.equalToSuperview().inset(7)
        }
    }
}
