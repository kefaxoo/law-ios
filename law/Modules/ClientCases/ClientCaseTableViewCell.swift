//
//  ClientCaseTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 6.01.25.
//

import UIKit

final class ClientCaseTableViewCell: BaseTableViewCell {
    private lazy var caseTypeLabel = UILabel()
    private lazy var caseStatusLabel = UILabel()
    private lazy var startDateLabel = UILabel()
    private lazy var endDateLabel = UILabel().setup({ $0.isHidden = true })
    
    private lazy var vStackView = UIStackView().setup {
        $0.axis = .vertical
        $0.spacing = 8
        $0.addArrangedSubview(self.caseTypeLabel)
        $0.addArrangedSubview(self.caseStatusLabel)
        $0.addArrangedSubview(self.startDateLabel)
    }
    
    var `case`: ClientCase? {
        didSet {
            guard let `case` else { return }
            
            self.caseTypeLabel.text = "Тип дела: \(`case`.type.title)"
            self.caseStatusLabel.text = "Статус дела: \(`case`.status.title)"
            self.startDateLabel.text = "Дата начала дела: \(`case`.startDate.toDate(withFormat: "dd.MM.yyyy"))"
            self.endDateLabel.isHidden = `case`.endDate == nil
            if let endDate = `case`.endDate?.toDate(withFormat: "dd.MM.yyyy") {
                self.endDateLabel.text = "Дата окончания дела: \(endDate)"
            }
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.vStackView)
    }
    
    override func setupConstraints() {
        self.vStackView.snp.makeConstraints({ $0.edges.equalToSuperview().inset(8) })
    }
}
