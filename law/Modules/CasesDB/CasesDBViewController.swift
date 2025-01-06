//
//  CasesDBViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import UIKit

final class CasesDBViewController: BaseViewController {
    private lazy var clientsTableView = UITableView().setup {
        $0.register(ClientShortTableViewCell.self)
        $0.dataSource = self
        $0.delegate = self
    }
    
    private let viewModel: CasesDBViewModelProtocol

	init(viewModel: CasesDBViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupLayout() {
        self.view.addSubview(self.clientsTableView)
    }
    
    override func setupConstraints() {
        self.clientsTableView.snp.makeConstraints({ $0.edges.equalTo(self.view.safeAreaLayoutGuide) })
    }
    
    override func setupBindings() {
        self.viewModel.clientsPublished.sink { [weak self] _ in
            self?.clientsTableView.reloadData()
        }.store(in: &cancellables)
        
        self.viewModel.pushVC.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Дела клиентов"
    }
}

// MARK: - UITableViewDataSource
extension CasesDBViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.clients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClientShortTableViewCell.id, for: indexPath)
        (cell as? ClientShortTableViewCell)?.clientInfo = self.viewModel.clients[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CasesDBViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.clientDidTap(at: indexPath)
    }
}
