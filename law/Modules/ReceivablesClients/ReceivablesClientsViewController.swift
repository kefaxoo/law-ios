//
//  ReceivablesClientsViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 20.02.25.
//

import UIKit

final class ReceivablesClientsViewController: BaseViewController {
    private lazy var tableView = UITableView().setup {
        $0.register(ReceivableTableViewCell.self)
        $0.dataSource = self
        $0.contentInset = .init(top: 7, left: 0, bottom: 0, right: 0)
        $0.separatorStyle = .none
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
        self.tableView.snp.makeConstraints { make in
            make.verticalEdges.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ReceivableTableViewCell.id, for: indexPath)
        cell.selectionStyle = .none
        
        (cell as? ReceivableTableViewCell)?.clientDebt = self.viewModel.clientsAndDebts[indexPath.row]
        
        return cell
    }
}
