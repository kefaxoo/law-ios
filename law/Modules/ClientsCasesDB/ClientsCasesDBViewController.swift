//
//  ClientsCasesDBViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class ClientsCasesDBViewController: BaseViewController {
    private lazy var searchController = UISearchController().setup {
        $0.searchBar.placeholder = "Введите ФИО клиента..."
        $0.searchBar.delegate = self
    }
    
    private lazy var contentTableView = UITableView().setup {
        $0.register(NewClientInfoTableViewCell.self)
        $0.dataSource = self
        $0.backgroundColor = UIColor(hex: "#EEF0F6")
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.separatorStyle = .none
    }
    
    private let viewModel: ClientsCasesDBViewModelProtocol

	init(viewModel: ClientsCasesDBViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupLayout() {
        self.view.addSubview(self.contentTableView)
    }
    
    override func setupConstraints() {
        self.contentTableView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    override func setupBindings() {
        self.viewModel.pushVC.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .fetchClientsInfo).receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.viewModel.fetchClientsInfo()
        }.store(in: &cancellables)
        
        self.viewModel.tableViewContentPublished.sink { [weak self] _ in
            self?.contentTableView.reloadData()
        }.store(in: &cancellables)
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "База данных клиентов"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarButtonItemDidTap))
        self.navigationItem.searchController = self.searchController
    }
}

// MARK: - Actions
private extension ClientsCasesDBViewController {
    @objc func rightBarButtonItemDidTap(_ sender: UIBarButtonItem) {
        self.viewModel.rightBarButtonItemDidTap()
    }
}

// MARK: - UITableViewDataSource
extension ClientsCasesDBViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.tableViewContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewClientInfoTableViewCell.id, for: indexPath)
        (cell as? NewClientInfoTableViewCell)?.client = self.viewModel.tableViewContent[indexPath.row] as? ClientInfo
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension ClientsCasesDBViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.searchBar(textDidChange: searchText)
    }
}
