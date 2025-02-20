//
//  ReceivablesClientsViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 20.02.25.
//

import UIKit

final class ReceivablesClientsViewController: BaseViewController {
    private lazy var tableView = UITableView().setup {
        $0.register(TextTableViewCell.self)
        $0.dataSource = self
    }
    
    private let viewModel: ReceivablesClientsViewModelProtocol

	init(viewModel: ReceivablesClientsViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupLayout() {
        self.view.addSubview(self.tableView)
    }
    
    override func setupConstraints() {
        self.tableView.snp.makeConstraints({ $0.edges.equalTo(self.view.safeAreaLayoutGuide) })
    }
    
    override func setupBindings() {
        self.viewModel.clientsAndDebtsPublished.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Дебиторская задолженность"
    }
}

extension ReceivablesClientsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.clientsAndDebts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.id, for: indexPath)
        cell.selectionStyle = .none
        
        let clientAndDebt = self.viewModel.clientsAndDebts[indexPath.row]
        (cell as? TextTableViewCell)?.text = "Клиент: \(clientAndDebt.client.fullName)\nДолг: \(clientAndDebt.debt)"
        
        return cell
    }
}
