//
//  ClientCaseTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 6.01.25.
//

import UIKit

final class ClientCaseTableViewCell: BaseTableViewCell {
    private lazy var caseTypeLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 0
    }
    
    private lazy var caseStatusLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 0
    }
    
    private lazy var startDateLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 0
    }
    
    private lazy var endDateLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 18, weight: .medium)
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    
    private lazy var vStackView = UIStackView().setup {
        $0.axis = .vertical
        $0.spacing = 13
        $0.addArrangedSubview(self.caseTypeLabel)
        $0.addArrangedSubview(self.caseStatusLabel)
        $0.addArrangedSubview(self.startDateLabel)
        $0.addArrangedSubview(self.endDateLabel)
    }
    
    private lazy var mainContentView = UIView().setup {
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.addSubview(self.vStackView)
        self.vStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(19)
            make.top.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(20)
        }
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
            
            self.vStackView.subviews.compactMap({ $0 as? UILabel }).forEach({ $0.textColor = `case`.status.textColor })
            self.mainContentView.backgroundColor = `case`.status.backgroundColor
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.mainContentView)
    }
    
    override func setupConstraints() {
        self.mainContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(6)
        }
    }
}
