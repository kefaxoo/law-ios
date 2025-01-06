//
//  ClientShortTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import UIKit

final class ClientShortTableViewCell: BaseTableViewCell {
    private lazy var clientNameLabel = UILabel()
    private lazy var clientTypeLabel = UILabel()
    
    private lazy var vStackView = UIStackView().setup {
        $0.axis = .vertical
        $0.spacing = 8
        $0.addArrangedSubview(self.clientNameLabel)
        $0.addArrangedSubview(self.clientTypeLabel)
    }
    
    var clientInfo: ClientInfo? {
        didSet {
            self.clientNameLabel.text = self.clientInfo?.fullName
            self.clientTypeLabel.text = self.clientInfo?.clientType.title
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.vStackView)
    }
    
    override func setupConstraints() {
        self.vStackView.snp.makeConstraints({ $0.edges.equalToSuperview().inset(8) })
    }
}
