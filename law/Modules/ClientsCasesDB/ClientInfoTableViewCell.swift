//
//  ClientInfoTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class ClientInfoTableViewCell: BaseTableViewCell {
    private lazy var clientInitialsLabel = UILabel().setup({ $0.numberOfLines = 0})
    private lazy var birthDateLabel = UILabel().setup({ $0.numberOfLines = 0 })
    private lazy var phoneNumberLabel = UILabel().setup({ $0.numberOfLines = 0})
    private lazy var emailLabel = UILabel().setup({ $0.numberOfLines = 0})
    private lazy var addressLabel = UILabel().setup({ $0.numberOfLines = 0})
    private lazy var clientTypeLabel = UILabel().setup({ $0.numberOfLines = 0})
    
    private lazy var vStackView = UIStackView().setup {
        $0.axis = .vertical
        $0.spacing = 8
        $0.addArrangedSubview(self.clientInitialsLabel)
        $0.addArrangedSubview(self.birthDateLabel)
        $0.addArrangedSubview(self.phoneNumberLabel)
        $0.addArrangedSubview(self.emailLabel)
        $0.addArrangedSubview(self.addressLabel)
        $0.addArrangedSubview(self.clientTypeLabel)
    }
    
    var clientInfo: ClientInfo? {
        didSet {
            guard let clientInfo else { return }
            
            self.clientInitialsLabel.text = "\(clientInfo.lastName) \(clientInfo.firstName) \(clientInfo.fatherName ?? "")"
            self.birthDateLabel.text = "День рождения: \(clientInfo.birthDateTimestamp.toDate(withFormat: "dd/MM/yyyy"))"
            self.phoneNumberLabel.text = "Номер телефона: \(clientInfo.phoneNumber)"
            self.emailLabel.text = "Email: \(clientInfo.email)"
            self.addressLabel.text = "Адрес: \(clientInfo.address)"
            self.clientTypeLabel.text = clientInfo.clientType.title
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.vStackView)
    }
    
    override func setupConstraints() {
        self.vStackView.snp.makeConstraints({ $0.edges.equalToSuperview().inset(8) })
    }
}
