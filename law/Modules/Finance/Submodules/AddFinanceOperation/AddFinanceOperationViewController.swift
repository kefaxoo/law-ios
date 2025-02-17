//
//  AddFinanceOperationViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class AddFinanceOperationViewController: BaseViewController {
    private lazy var clientLabel = UILabel().setup {
        $0.text = "Выберите клиента:"
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 32) })
    }
    
    private lazy var clientButton = UIButton(configuration: .tinted()).setup {
        $0.setTitle("Выберите клиента", for: .normal)
    }
    
    private lazy var caseLabel = UILabel().setup { $0.text = "Выберите дело:" }
    
    private lazy var caseButton = UIButton(configuration: .tinted()).setup {
        $0.setTitle("Выберите дело", for: .normal)
    }
    
    private lazy var amountLabel = UILabel().setup { $0.text = "Введите сумму:" }
    private lazy var amountTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Введите сумму..."
        $0.keyboardType = .decimalPad
        $0.delegate = self
    }
    
    private lazy var statusLabel = UILabel().setup { $0.text = "Выберите статус операции:" }
    
    private lazy var statusButton = UIButton(configuration: .tinted()).setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = self.viewModel.statusMenu
    }
    
    private lazy var paymentMethodLabel = UILabel().setup { $0.text = "Выберите способ оплаты:" }
    
    private lazy var paymentMethodButton = UIButton(configuration: .tinted()).setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = self.viewModel.paymentMethodMenu
    }
    
    private lazy var dynamicVStackView = DynamicScrollView(axis: .vertical).setup {
        $0.addSubview(self.clientLabel, spacingAfter: 8)
        $0.addSubview(self.clientButton, spacingAfter: 16)
        $0.addSubview(self.caseLabel, spacingAfter: 8)
        $0.addSubview(self.caseButton, spacingAfter: 16)
        $0.addSubview(self.amountLabel, spacingAfter: 8)
        $0.addSubview(self.amountTextField, spacingAfter: 16)
        $0.addSubview(self.statusLabel, spacingAfter: 8)
        $0.addSubview(self.statusButton, spacingAfter: 16)
        $0.addSubview(self.paymentMethodLabel, spacingAfter: 8)
        $0.addSubview(self.paymentMethodButton, spacingAfter: 16)
    }
    
    private lazy var bottomButton = UIButton(configuration: .filled()).setup {
        $0.setTitle("Добавить операцию", for: .normal)
    }
    
    private let viewModel: AddFinanceOperationViewModelProtocol

	init(viewModel: AddFinanceOperationViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupInterface() {
        super.setupInterface()
        
        self.addKeyboardDismiss()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.dynamicVStackView)
        self.view.addSubview(self.bottomButton)
    }
    
    override func setupConstraints() {
        self.dynamicVStackView.snp.makeConstraints({ $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16) })
        self.bottomButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.dynamicVStackView.snp.bottom).offset(16)
        }
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Добавление операции"
    }
    
    override func setupBindings() {
        self.viewModel.currentPaymentMethodPublished.sink { [weak self] paymentMethod in
            self?.paymentMethodButton.setTitle(paymentMethod.title, for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.currentStatusPublished.sink { [weak self] status in
            self?.statusButton.setTitle(status.title, for: .normal)
        }.store(in: &cancellables)
    }
}

// MARK: - UITextFieldDelegate
extension AddFinanceOperationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let decimalSeparator = ","
        
        // Handling backspace properly
        if string.isEmpty {
            return true // Allow backspace normally
        }
        
        // Construct the new text
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // If user types "0" as the first character, auto-insert "0,"
        if currentText.isEmpty && string == "0" {
            textField.text = "0\(decimalSeparator)"
            return false
        }
        
        if currentText.isEmpty, string == "," {
            textField.text = "0,"
            return false
        }
        
        // If the text is "0," and user tries to delete "0", allow full deletion
        if newText == decimalSeparator {
            textField.text = ""
            return false
        }
        
        // Regex pattern:
        // - Starts with a non-zero digit or "0,"
        // - Allows only one decimal separator
        // - Allows up to two decimal places
        let regexPattern = "^(0\(decimalSeparator)?|[1-9][0-9]*)\(decimalSeparator)?[0-9]{0,2}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexPattern)
        
        return predicate.evaluate(with: newText)
    }
}
