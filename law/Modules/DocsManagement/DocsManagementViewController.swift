//
//  DocsManagementViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import UIKit

final class DocsManagementViewController: BaseViewController {
    private lazy var documentsTableView = UITableView().setup {
        $0.dataSource = self
        $0.register(TextTableViewCell.self)
        $0.delegate = self
    }
    
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
        
        NotificationCenter.default.publisher(for: .fetchDocuments).receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.viewModel.fetchDocuments()
        }.store(in: &cancellables)
        
        self.viewModel.documentsPublished.sink { [weak self] _ in
            self?.documentsTableView.reloadData()
        }.store(in: &cancellables)
        
        self.viewModel.present.sink { [weak self] vc in
            self?.present(vc, animated: true)
        }.store(in: &cancellables)
    }
    
    override func setupLayout() {
        self.view.addSubview(self.documentsTableView)
    }
    
    override func setupConstraints() {
        self.documentsTableView.snp.makeConstraints({ $0.edges.equalTo(self.view.safeAreaLayoutGuide) })
    }
}

// MARK: - Actions
private extension DocsManagementViewController {
    @objc func rightBarButtonDidTap(_ sender: UIBarButtonItem) {
        self.viewModel.rightBarButtonDidTap()
    }
}

// MARK: - UITableViewDataSource
extension DocsManagementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.id, for: indexPath)
        (cell as? TextTableViewCell)?.text = self.viewModel.documents[indexPath.row].cellText
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DocsManagementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.tableViewDidSelect(at: indexPath, delegate: self)
    }
}

// MARK: - UIDocumentInteractionControllerDelegate
extension DocsManagementViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        self
    }
}
