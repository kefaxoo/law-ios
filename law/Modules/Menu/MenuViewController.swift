//
//  MenuViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class MenuViewController: ActionsViewController<MenuViewModel> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.viewDidLoad()
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Menu"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", style: .done, target: self, action: #selector(rightBarButtonDidTap))
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
    @objc func rightBarButtonDidTap(_ sender: UIBarButtonItem) {
        self.viewModel.rightBarButtonDidTap()
    }
}
