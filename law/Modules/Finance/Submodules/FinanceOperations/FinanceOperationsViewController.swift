//
//  FinanceOperationsViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class FinanceOperationsViewController: BaseViewController {
    private lazy var tableView = UITableView().setup {
        $0.register(FinanceOperationTableViewCell.self)
        $0.dataSource = self
        $0.delegate = self
    }
    
    private let viewModel: FinanceOperationsViewModelProtocol

	init(viewModel: FinanceOperationsViewModelProtocol) {
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
        self.viewModel.operationsPublished.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
        
        self.viewModel.present.sink { [weak self] vc in
            self?.present(vc, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.pushVC.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .fetchOperations).receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.viewModel.fetchOperations()
        }.store(in: &cancellables)
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Финансовые операции"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить", style: .done, target: self, action: #selector(rightBarButtonDidTap))
    }
}

// MARK: - UITableViewDataSource
extension FinanceOperationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.operations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FinanceOperationTableViewCell.id, for: indexPath)
        (cell as? FinanceOperationTableViewCell)?.operation = self.viewModel.operations[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FinanceOperationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.tableViewDidTap(at: indexPath)
    }
}

// MARK: - Actions
private extension FinanceOperationsViewController {
    @objc func rightBarButtonDidTap(_ sender: UIBarButtonItem) {
        self.viewModel.rightBarButtonDidTap()
    }
}
