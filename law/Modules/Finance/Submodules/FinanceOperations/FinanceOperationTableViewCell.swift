//
//  FinanceOperationTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class FinanceOperationTableViewCell: BaseTableViewCell {
    private lazy var contentLabel = UILabel().setup { $0.numberOfLines = 0 }
    
    var operation: FinanceOperation? {
        didSet {
            guard let operation else { return }
            
            let id = operation.clientId as String
            DatabaseService.shared.fetchObjects(
                type: ClientInfo.self,
                predicate: #Predicate { $0.id == id }
            ) { [weak self] objects, error in
                guard let client = objects?.first else { return }
                
                self?.contentLabel.text = """
                Клиент: \(client.fullName)
                Сумма: \(operation.amount)
                Статус: \(operation.status.title)
                """
            }
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.contentLabel)
    }
    
    override func setupConstraints() {
        self.contentLabel.snp.makeConstraints({ $0.edges.equalToSuperview().inset(8) })
    }
}
