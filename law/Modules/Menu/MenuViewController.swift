//
//  MenuViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class MenuViewController: NewActionsViewController<MenuViewModel> {
    private lazy var signOutButton = UIButton().setup {
        $0.setTitle("Выйти", for: .normal)
        $0.setTitleColor(UIColor(hex: "#0B359D"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 19, weight: .regular)
        $0.addTarget(self, action: #selector(signOutButtonDidTap), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.viewDidLoad()
    }
    
    override func setupInterface() {
        super.setupInterface()
        
        self.viewTitle = "Меню"
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        self.topHStackView.addArrangedSubview(.spacer)
        self.topHStackView.addArrangedSubview(self.signOutButton)
    }
    
    override func setupBindings() {
        super.setupBindings()
        
        self.viewModel.presentAlert.sink { [weak self] alert in
            self?.present(alert, animated: true)
        }.store(in: &cancellables)
    }
}

// MARK: - Actions
private extension MenuViewController {
    @objc func signOutButtonDidTap(_ sender: UIButton) {
        self.viewModel.rightBarButtonDidTap()
    }
}
