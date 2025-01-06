//
//  ClientCasesViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import UIKit

final class ClientCasesViewController: BaseViewController {
    private lazy var casesTableView = UITableView().setup {
        $0.dataSource = self
        $0.register(ClientCaseTableViewCell.self)
        $0.delegate = self
    }
    
    private let viewModel: ClientCasesViewModelProtocol

	init(viewModel: ClientCasesViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupNavigationController() {
        self.navigationItem.title = self.viewModel.client.fullName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarButtonDidTap))
    }
    
    override func setupBindings() {
        self.viewModel.pushVC.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .fetchClientCasesInfo).receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.viewModel.fetchCases()
        }.store(in: &cancellables)
        
        self.viewModel.casesPublised.sink { [weak self] _ in
            self?.casesTableView.reloadData()
        }.store(in: &cancellables)
    }
    
    override func setupLayout() {
        self.view.addSubview(self.casesTableView)
    }
    
    override func setupConstraints() {
        self.casesTableView.snp.makeConstraints({ $0.edges.equalTo(self.view.safeAreaLayoutGuide) })
    }
}

// MARK: - Actions
private extension ClientCasesViewController {
    @objc func rightBarButtonDidTap(_ sender: UIBarButtonItem) {
        self.viewModel.rightBarButtonDidTap()
    }
}

// MARK: - UITableViewDataSource
extension ClientCasesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClientCaseTableViewCell.id, for: indexPath)
        (cell as? ClientCaseTableViewCell)?.case = self.viewModel.cases[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ClientCasesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.caseDidTap(at: indexPath)
    }
}
