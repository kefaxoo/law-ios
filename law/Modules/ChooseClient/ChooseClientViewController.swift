//
//  ChooseClientViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 07.01.25.
//

import UIKit

final class ChooseClientViewController: BaseViewController {
    private lazy var clientsTableView = UITableView().setup {
        $0.dataSource = self
        $0.register(TextTableViewCell.self)
        $0.delegate = self
    }
    
    private let viewModel: ChooseClientViewModelProtocol

    weak var delegate: ChooseClientDelegate?
    
    init(viewModel: ChooseClientViewModelProtocol, delegate: ChooseClientDelegate?) {
		self.viewModel = viewModel
        self.delegate = delegate
        
		super.init()
	}
    
    override func setupNavigationController() {
        self.navigationItem.title = "Выберите клиента:"
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
        
        self.viewModel.clientDidSelect.sink { [weak self] client in
            self?.delegate?.clientDidChoose(client)
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension ChooseClientViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.id, for: indexPath)
        (cell as? TextTableViewCell)?.text = self.viewModel.clients[indexPath.row].fullName
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChooseClientViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.clientDidSelect(at: indexPath)
    }
}
