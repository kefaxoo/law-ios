//
//  NewClientInfoTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 19.04.25.
//

import UIKit

final class NewClientInfoTableViewCell: BaseTableViewCell {
    private lazy var clientTypeLabel = UILabel().setup {
        $0.numberOfLines = 0
        $0.textColor = UIColor(hex: "#10224E")
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    private lazy var clientInfoLabel = UILabel().setup {
        $0.numberOfLines = 0
        $0.textColor = UIColor(hex: "#000016")
        $0.font = .systemFont(ofSize: 17, weight: .medium)
    }
    
    private lazy var clientInfoContentView = UIView().setup {
        $0.backgroundColor = UIColor(hex: "#FFFEFE")
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.addSubview(self.clientInfoLabel)
        self.clientInfoLabel.snp.makeConstraints({ $0.edges.equalToSuperview().inset(13) })
    }
    
    var client: ClientInfo? {
        didSet {
            guard let client else { return }
            
            self.clientTypeLabel.text = client.clientType.title
            self.clientInfoLabel.text = """
                \(client.fullName)
                День рождения: \(client.birthDateTimestamp.toDate(withFormat: "dd/MM/yyyy"))
                Номер телефона: \(client.phoneNumber)
                Email: \(client.email)
                \(client.address)
                """
        }
    }
    
    override func setupInterface() {
        super.setupInterface()
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.selectionStyle = .none
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.clientTypeLabel)
        self.contentView.addSubview(self.clientInfoContentView)
    }
    
    override func setupConstraints() {
        self.clientTypeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        self.clientInfoContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(7)
            make.top.equalTo(self.clientTypeLabel.snp.bottom).offset(9)
        }
    }
}
