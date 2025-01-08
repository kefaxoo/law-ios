//
//  AuthViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 09.01.25.
//

import UIKit

final class AuthViewController: BaseViewController {
	private let viewModel: AuthViewModelProtocol
    
    private lazy var loginLabel = UILabel().setup { $0.text = "Логин:" }
    private lazy var loginTextField = UITextField.roundedRect.setup { $0.placeholder = "Введите логин..." }
    
    private lazy var passwordLabel = UILabel().setup { $0.text = "Пароль:" }
    private lazy var passwordTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Введите пароль..."
        $0.isSecureTextEntry = true
    }
    
    private lazy var vStackView = UIStackView().setup {
        $0.axis = .vertical
        $0.spacing = 8
        $0.addArrangedSubview(self.loginLabel)
        $0.addArrangedSubview(self.loginTextField)
        $0.addArrangedSubview(self.passwordLabel)
        $0.addArrangedSubview(self.passwordTextField)
    }
    
    private lazy var changeModeButton = UIButton(configuration: .tinted()).setup {
        $0.setTitle(self.viewModel.mode.changeModeButtonText, for: .normal)
        $0.addTarget(self, action: #selector(changeModeButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var signButton = UIButton(configuration: .filled()).setup {
        $0.setTitle(self.viewModel.mode.mainButtonText, for: .normal)
        $0.addTarget(self, action: #selector(bottomButtonDidTap), for: .touchUpInside)
    }

	init(viewModel: AuthViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupLayout() {
        self.view.addSubview(self.vStackView)
        self.view.addSubview(self.changeModeButton)
        self.view.addSubview(self.signButton)
    }
    
    override func setupConstraints() {
        self.vStackView.snp.makeConstraints({ $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16) })
        self.signButton.snp.makeConstraints({ $0.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16) })
        self.changeModeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.signButton.snp.top).offset(-16)
        }
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = self.viewModel.mode.title
    }
    
    override func setupBindings() {
        self.viewModel.popVC.sink { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.pushVC.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.presentAlert.sink { [weak self] alert in
            self?.present(alert, animated: true)
        }.store(in: &cancellables)
    }
}

// MARK: - Actions
private extension AuthViewController {
    @objc func changeModeButtonDidTap(_ sender: UIButton) {
        self.viewModel.changeModeButtonDidTap()
    }
    
    @objc func bottomButtonDidTap(_ sender: UIButton) {
        self.viewModel.bottomButtonDidTap(login: self.loginTextField.text, password: self.passwordTextField.text)
    }
}
