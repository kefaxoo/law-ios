//
//  ClientShortTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import UIKit

final class ClientShortTableViewCell: BaseTableViewCell {
    private lazy var clientNameLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 19, weight: .regular)
        $0.textColor = UIColor(hex: "#083B81")
        $0.numberOfLines = 0
    }
    
    private lazy var clientTypeLabel = UILabel().setup {
        $0.numberOfLines = 0
        $0.textColor = UIColor(hex: "#232728")
        $0.font = .systemFont(ofSize: 19, weight: .regular)
    }
    
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
        self.vStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(17)
            make.top.equalToSuperview().inset(11)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
