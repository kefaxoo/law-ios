//
//  TextFieldDatePickerTableViewCell.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.12.24.
//

import UIKit

final class TextFieldDatePickerTableViewCell: BaseTableViewCell {
    private lazy var textField = UITextField().setup({ $0.borderStyle = .roundedRect })
    private lazy var datePicker = UIDatePicker()
    
    private lazy var hStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.addArrangedSubview(self.textField)
        $0.addArrangedSubview(self.datePicker)
    }
    
    var datePickerMode: UIDatePicker.Mode {
        get {
            self.datePicker.datePickerMode
        }
        set {
            self.datePicker.datePickerMode = newValue
        }
    }
    
    var placeholder: String? {
        get {
            self.textField.placeholder
        }
        set {
            self.textField.placeholder = newValue
        }
    }
    
    var text: String? {
        get {
            self.textField.text
        }
        set {
            self.textField.text = newValue
        }
    }
    
    var minimumDate: Date? {
        get {
            self.datePicker.minimumDate
        }
        set {
            self.datePicker.minimumDate = newValue
        }
    }
    
    var maximumDate: Date? {
        get {
            self.datePicker.maximumDate
        }
        set {
            self.datePicker.maximumDate = newValue
        }
    }
    
    var date: Date {
        get {
            self.datePicker.date
        }
        set {
            self.datePicker.date = newValue
        }
    }
    
    override func setupLayout() {
        self.contentView.addSubview(self.hStackView)
    }
    
    override func setupConstraints() {
        self.hStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview()
        }
    }
}
