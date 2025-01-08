//
//  AddClientViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class AddClientViewController: BaseViewController {
    private lazy var firstNameTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Имя"
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 32) })
        $0.delegate = self
    }
    
    private lazy var lastNameTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Фамилия"
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 32) })
        $0.delegate = self
    }
    
    private lazy var fatherNameTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Отчество"
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 32) })
        $0.delegate = self
    }
    
    private lazy var birthDatePickerView = UIDatePicker().setup {
        $0.datePickerMode = .date
        $0.maximumDate = Date()
    }
    
    private lazy var phoneNumberTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Номер телефона"
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 32) })
        $0.keyboardType = .numberPad
    }
    
    private lazy var emailTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Email"
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 32) })
    }
    
    private lazy var addressTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Адрес"
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 32) })
    }
    
    private lazy var clientTypeButton = UIButton(configuration: .tinted()).setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.clientTypeActions)
    }
    
    private lazy var vStackView = DynamicScrollView(axis: .vertical).setup {
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.addSubview(self.firstNameTextField, spacingAfter: 16)
        $0.addSubview(self.lastNameTextField, spacingAfter: 16)
        $0.addSubview(self.fatherNameTextField, spacingAfter: 16)
        $0.addSubview(self.birthDatePickerView, spacingAfter: 16)
        $0.addSubview(self.phoneNumberTextField, spacingAfter: 16)
        $0.addSubview(self.emailTextField, spacingAfter: 16)
        $0.addSubview(self.addressTextField, spacingAfter: 16)
        $0.addSubview(self.clientTypeButton)
    }
    
    private lazy var addClientButton = UIButton(configuration: .filled()).setup {
        $0.setTitle("Cоздать клиента", for: .normal)
        $0.addTarget(self, action: #selector(addClientButtonDidTap), for: .touchUpInside)
    }
    
    private let viewModel: AddClientViewModelProtocol

	init(viewModel: AddClientViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupInterface() {
        super.setupInterface()
        
        self.addKeyboardDismiss()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.vStackView)
        self.view.addSubview(self.addClientButton)
    }
    
    override func setupConstraints() {
        self.vStackView.snp.makeConstraints({ $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide) })
        
        self.addClientButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.vStackView.snp.bottom).offset(16)
        }
    }
    
    override func setupBindings() {
        self.viewModel.currentClientTypePublished.sink { [weak self] type in
            self?.clientTypeButton.setTitle(type.title, for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.presentAlert.sink { [weak self] alert in
            self?.present(alert, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.popVC.sink { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Add client"
    }
}

// MARK: - Actions
private extension AddClientViewController {
    @objc func addClientButtonDidTap(_ sender: UIButton) {
        self.viewModel.createClient(lastName: self.lastNameTextField.text, firstName: self.firstNameTextField.text, fatherName: self.fatherNameTextField.text, birthDateTimestamp: self.birthDatePickerView.date.timeIntervalSince1970, phoneNumber: self.phoneNumberTextField.text, email: self.emailTextField.text, address: self.addressTextField.text)
    }
}

// MARK: - UITextFieldDelegate
extension AddClientViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (string.filter(\.isLetter) + string.filter(\.isWhitespace)).count == string.count
    }
}
