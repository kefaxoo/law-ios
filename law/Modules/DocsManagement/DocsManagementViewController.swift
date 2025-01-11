//
//  DocsManagementViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import UIKit

final class DocsManagementViewController: BaseViewController {
	private let viewModel: DocsManagementViewModelProtocol

	init(viewModel: DocsManagementViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupNavigationController() {
        self.navigationItem.title = "Документооборот"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(rightBarButtonDidTap))
    }
    
    override func setupBindings() {
        self.viewModel.pushVC.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
    }
}

// MARK: - Actions
private extension DocsManagementViewController {
    @objc func rightBarButtonDidTap(_ sender: UIBarButtonItem) {
        self.viewModel.rightBarButtonDidTap()
    }
}
