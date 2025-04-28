//
//  ClientTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 26.04.25.
//

import UIKit

final class ClientTableViewCell: BaseTableViewCell {
    private lazy var personImageView = UIImageView().setup {
        $0.contentMode = .scaleAspectFit
        $0.image = .fillClientInfo
        $0.snp.makeConstraints({ $0.size.equalTo(41) })
    }
    
    private lazy var personLabel = UILabel().setup {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 19, weight: .semibold)
        $0.textColor = .black
    }
    
    private lazy var clientTypeLabel = UILabel().setup {
        $0.numberOfLines = 1
        $0.font = .systemFont(ofSize: 16, weight: .light)
        $0.textColor = UIColor(hex: "#5C5C5C")
    }
    
    private lazy var separatorLine = UIView().setup {
        $0.snp.makeConstraints({ $0.height.equalTo(1) })
        $0.backgroundColor = UIColor(hex: "#B8B9B7")
    }
    
    var client: ClientInfo? {
        didSet {
            self.personLabel.text = self.client?.fullName
            self.clientTypeLabel.text = self.client?.clientType.title
        }
    }
    
    var user: User? {
        didSet {
            self.personLabel.text = self.user?.login
            self.clientTypeLabel.text = self.user?.role?.title
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.personImageView)
        self.contentView.addSubview(self.personLabel)
        self.contentView.addSubview(self.clientTypeLabel)
        self.contentView.addSubview(self.separatorLine)
    }
    
    override func setupConstraints() {
        self.personImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(28)
        }
        
        self.personLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.equalTo(self.personImageView.snp.trailing).offset(13.7)
            make.trailing.equalToSuperview().inset(18)
        }
        
        self.clientTypeLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.personLabel)
            make.top.equalTo(self.personLabel.snp.bottom).offset(4)
        }
        
        self.separatorLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalTo(self.personImageView)
            make.trailing.equalTo(self.personLabel)
            make.top.equalTo(self.clientTypeLabel.snp.bottom).offset(15)
        }
    }
}

