//
//  NewAuthViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 19.04.25.
//

import UIKit

final class NewAuthViewController: BaseViewController {
    private lazy var titleLabel = UILabel().setup {
        $0.textColor = UIColor(hex: "#103779")
        $0.font = .systemFont(ofSize: 45, weight: .bold)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.text = self.viewModel.mode.title
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 56) })
    }
    
    private lazy var loginTextField = BaseTextField().setup {
        $0.attributedPlaceholder = NSAttributedString(string: "Введите логин...", attributes: [
            .foregroundColor: UIColor(hex: "#838A8F"),
            .font: UIFont.systemFont(ofSize: 22, weight: .regular)
        ])
        
        $0.title = "Логин:"
    }
    
    private lazy var passwordTextField = BaseTextField().setup {
        $0.attributedPlaceholder = NSAttributedString(string: "Введите пароль...", attributes: [
            .foregroundColor: UIColor(hex: "#838A8F"),
            .font: UIFont.systemFont(ofSize: 22, weight: .regular)
        ])
        
        $0.title = "Пароль:"
        $0.isSecureTextEntry = true
    }
    
    private lazy var signUpButton = UIButton().setup {
        $0.setTitle(self.viewModel.mode.changeModeButtonText, for: .normal)
        $0.setTitleColor(UIColor(hex: "#1C81FF"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 22, weight: .regular)
        $0.addTarget(self, action: #selector(changeModeButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var vDynamicScrollView = DynamicScrollView(axis: .vertical).setup {
        $0.contentInset = UIEdgeInsets(top: 48, left: 28, bottom: 0, right: 28)
        $0.addSubview(self.titleLabel, spacingAfter: 37)
        $0.addSubview(self.loginTextField, spacingAfter: 22)
        $0.addSubview(self.passwordTextField, spacingAfter: 44)
        $0.addSubview(self.signUpButton)
    }
    
    private lazy var signButton = UIButton().setup {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 18, leading: 0, bottom: 18, trailing: 0)
        configuration.title = self.viewModel.mode.mainButtonText
        configuration.titleTextAttributesTransformer = .init {
            var output = $0
            output.font = .systemFont(ofSize: 22, weight: .regular)
            return output
        }
        
        configuration.baseForegroundColor = UIColor(hex: "#FDF8F9")
        $0.configuration = configuration
        
        $0.backgroundColor = UIColor(hex: "#3187FF")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        
        $0.addTarget(self, action: #selector(bottomButtonDidTap), for: .touchUpInside)
    }
    
    private let viewModel: AuthViewModelProtocol
    
    init(viewModel: AuthViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func setupInterface() {
        super.setupInterface()
    
        self.setupKeyboardSupport { height in
            self.signButton.snp.updateConstraints({ $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(height == 0 ? 83 : 22 + height) })
        }
    }
    
    override func setupLayout() {
        self.view.addSubview(self.vDynamicScrollView)
        self.view.addSubview(self.signButton)
    }
    
    override func setupConstraints() {
        self.vDynamicScrollView.snp.makeConstraints({ $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide) })
        self.signButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(28)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(83)
            make.top.equalTo(self.vDynamicScrollView.snp.bottom).offset(22)
        }
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
private extension NewAuthViewController {
    @objc func changeModeButtonDidTap(_ sender: UIButton) {
        self.viewModel.changeModeButtonDidTap()
    }
    
    @objc func bottomButtonDidTap(_ sender: UIButton) {
        self.viewModel.bottomButtonDidTap(login: self.loginTextField.text, password: self.passwordTextField.text)
    }
}


#Preview {
    UINavigationController(rootViewController: AuthFactory.create(mode: .signIn))
}
