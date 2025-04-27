//
//  FinanceOperationsTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 27.04.25.
//

import UIKit

final class FinanceOperationsTableViewCell: BaseTableViewCell {
    private lazy var clientLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 19, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private lazy var sumTitleLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 19, weight: .light)
        $0.numberOfLines = 1
        $0.textColor = UIColor(hex: "#696B6C")
        $0.text = "Сумма"
    }
    
    private lazy var sumLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 21, weight: .medium)
        $0.numberOfLines = 1
        $0.textAlignment = .right
    }
    
    private lazy var sumHStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.addArrangedSubview(self.sumTitleLabel)
        $0.addArrangedSubview(self.sumLabel)
    }
    
    private lazy var statusTitleLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 19, weight: .light)
        $0.numberOfLines = 1
        $0.textColor = UIColor(hex: "#696B6C")
        $0.text = "Cтатус"
    }
    
    private lazy var statusLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 21, weight: .medium)
        $0.numberOfLines = 1
        $0.textAlignment = .right
    }
    
    private lazy var statusHStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.addArrangedSubview(self.statusTitleLabel)
        $0.addArrangedSubview(self.statusLabel)
    }
    
    private lazy var mainContentView = UIView().setup {
        $0.backgroundColor = UIColor(hex: "#EFF0F2")
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.addSubview(self.clientLabel)
        self.clientLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
            make.leading.equalToSuperview().inset(19)
            make.trailing.equalToSuperview().inset(16)
        }
        
        $0.addSubview(self.sumHStackView)
        self.sumHStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.clientLabel)
            make.top.equalTo(self.clientLabel.snp.bottom).offset(11)
        }
        
        $0.addSubview(self.statusHStackView)
        self.statusHStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.clientLabel)
            make.top.equalTo(self.sumHStackView.snp.bottom).offset(11)
            make.bottom.equalToSuperview().inset(22)
        }
    }
    
    var operation: FinanceOperation? {
        didSet {
            guard let operation else { return }
            
            let id = operation.clientId as String
            DatabaseService.shared.fetchObjects(type: ClientInfo.self, predicate: #Predicate { $0.id == id }) { [weak self] objects, error in
                self?.clientLabel.text = objects?.first?.fullName
                
                self?.sumLabel.text = "\(operation.amount)"
                self?.sumLabel.textColor = operation.amount < 0 ? UIColor(hex: "#BA1014") : UIColor(hex: "#29864F")
                
                self?.statusLabel.text = operation.status.title
                self?.statusLabel.textColor = operation.status.color
            }
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.mainContentView)
    }
    
    override func setupConstraints() {
        self.mainContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(5)
        }
    }
}
