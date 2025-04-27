//
//  AddFinanceOperationViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class AddFinanceOperationViewController: BaseViewController {
    private lazy var clientLabel = UILabel().setup {
        $0.text = "Клиент, связанный с операцией:"
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 38) })
    }
    
    private lazy var clientButton = AddEventButton().setup {
        $0.addTarget(self, action: #selector(clientButtonDidTap), for: .touchUpInside)
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#C6C6C6").cgColor
        $0.image = .clientIcon
        $0.text = "Выберите клиента"
        $0.tintColor = UIColor(hex: "#2076F3")
    }
    
    private lazy var caseButton = AddEventButton().setup {
        $0.addTarget(self, action: #selector(caseButtonDidTap), for: .touchUpInside)
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#C6C6C6").cgColor
        $0.image = .caseIcon
        $0.text = "Выберите дело"
        $0.tintColor = UIColor(hex: "#2076F3")
    }
    
    private lazy var amountLabel = UILabel().setup { $0.text = "Введите сумму" }
    private lazy var amountTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Введите сумму..."
        $0.keyboardType = .decimalPad
        $0.delegate = self
    }
    
    private lazy var transactionTypeLabel = UILabel().setup { $0.text = "Выберите тип транзакции:" }
    private lazy var transactionTypeButton = BaseBlueButton().setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = self.viewModel.transactionTypeMenu
    }
    
    private lazy var statusLabel = UILabel().setup { $0.text = "Выберите статус операции:" }
    private lazy var statusButton = BaseBlueButton().setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = self.viewModel.statusMenu
    }
    
    private lazy var paymentMethodLabel = UILabel().setup { $0.text = "Выберите способ оплаты:" }
    
    private lazy var paymentMethodButton = BaseBlueButton().setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = self.viewModel.paymentMethodMenu
    }
    
    private lazy var dynamicVStackView = DynamicScrollView(axis: .vertical).setup {
        $0.addSubview(self.clientLabel, spacingAfter: 8)
        $0.addSubview(self.clientButton, spacingAfter: 21)
        $0.addSubview(self.caseButton, spacingAfter: 21)
        $0.addSubview(self.amountLabel, spacingAfter: 8)
        $0.addSubview(self.amountTextField, spacingAfter: 21)
        $0.addSubview(self.transactionTypeLabel, spacingAfter: 11)
        $0.addSubview(self.transactionTypeButton, spacingAfter: 21)
        $0.addSubview(self.statusLabel, spacingAfter: 11)
        $0.addSubview(self.statusButton, spacingAfter: 21)
        $0.addSubview(self.paymentMethodLabel, spacingAfter: 11)
        $0.addSubview(self.paymentMethodButton, spacingAfter: 21)
    }
    
    private lazy var bottomButton = BaseBlueButton().setup {
        $0.setTitle("\(self.isAdd ? "Добавить" : "Редактировать") операции", for: .normal)
        $0.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }
    
    private let viewModel: AddFinanceOperationViewModelProtocol

    private var isAdd = true {
        didSet {
            self.navigationItem.title = "\(self.isAdd ? "Добавление" : "Редактирование") операции"
            self.bottomButton.setTitle("\(self.isAdd ? "Добавить" : "Редактировать") операции", for: .normal)
        }
    }
    
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
        self.dynamicVStackView.snp.makeConstraints({ $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(19) })
        self.bottomButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(19)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.dynamicVStackView.snp.bottom).offset(16)
        }
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "\(self.isAdd ? "Добавление" : "Редактирование") операции"
    }
    
    override func setupBindings() {
        self.viewModel.currentPaymentMethodPublished.sink { [weak self] paymentMethod in
            self?.paymentMethodButton.setTitle(paymentMethod.title, for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.currentStatusPublished.sink { [weak self] status in
            self?.statusButton.setTitle(status.title, for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.showChooseClientScreen.sink { [weak self] _ in
            self?.navigationController?.pushViewController(ChooseClientFactory.create(delegate: self), animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.selectedClientPublished.sink { [weak self] client in
            self?.clientButton.text = client?.fullName ?? "Выберите клиента"
        }.store(in: &cancellables)
        
        self.viewModel.showChooseCaseScreen.sink { [weak self] client in
            self?.navigationController?.pushViewController(ChooseCaseFactory.create(client: client, delegate: self), animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.selectedCasePublished.sink { [weak self] clientCase in
            self?.caseButton.text = clientCase?.title ?? "Выберите дело"
        }.store(in: &cancellables)
        
        self.viewModel.present.sink { [weak self] vc in
            self?.present(vc, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.currentTransactionTypePublished.sink { [weak self] transactionType in
            self?.transactionTypeButton.setTitle(transactionType.title, for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.pop.sink { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.amountPublished.sink { [weak self] amount in
            guard let amount else { return }
            
            self?.amountTextField.text = "\(amount)"
            self?.isAdd = false
        }.store(in: &cancellables)
    }
}

// MARK: - UITextFieldDelegate
extension AddFinanceOperationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let decimalSeparator = "."
        
        if string.isEmpty {
            return true
        }
        
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if currentText.isEmpty,
           string == "0" {
            textField.text = "0\(decimalSeparator)"
            return false
        }
        
        if currentText.isEmpty,
            string == "," {
            textField.text = "0."
            return false
        }
        
        if newText == decimalSeparator {
            textField.text = ""
            return false
        }
        
        let regexPattern = "^(0\(decimalSeparator)?|[1-9][0-9]*)\(decimalSeparator)?[0-9]{0,2}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexPattern)
        
        return predicate.evaluate(with: newText)
    }
}

// MARK: - ChooseClientDelegate
extension AddFinanceOperationViewController: ChooseClientDelegate {
    func clientDidChoose(_ client: ClientInfo) {
        self.viewModel.setSelectedClient(client)
    }
}

// MARK: - Actions
private extension AddFinanceOperationViewController {
    @objc func clientButtonDidTap(_ sender: UIButton) {
        self.viewModel.clientButtonDidTap()
    }
    
    @objc func caseButtonDidTap(_ sender: UIButton) {
        self.viewModel.caseButtonDidTap()
    }
    
    @objc func addButtonDidTap(_ sender: UIButton) {
        self.viewModel.addOperation(amount: self.amountTextField.text)
    }
}

// MARK: - ChooseCaseDelegate
extension AddFinanceOperationViewController: ChooseCaseDelegate {
    func caseDidChoose(_ case: ClientCase) {
        self.viewModel.setSelectedCase(`case`)
    }
}
