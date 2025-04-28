//
//  UsersViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 28.04.25.
//

import UIKit

final class UsersViewController: BaseViewController {
    private lazy var usersTableView = UITableView().setup {
        $0.dataSource = self
        $0.register(ClientTableViewCell.self)
        $0.delegate = self
        $0.separatorStyle = .none
        $0.contentInset = .init(top: 9, left: 0, bottom: 0, right: 0)
    }
    
    private let viewModel: UsersViewModelProtocol
    
    init(viewModel: UsersViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Пользователи"
    }
    
    override func setupLayout() {
        self.view.addSubview(self.usersTableView)
    }
    
    override func setupConstraints() {
        self.usersTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    override func setupBindings() {
        self.viewModel.usersPublished.sink { [weak self] _ in
            self?.usersTableView.reloadData()
        }.store(in: &cancellables)
        
        self.viewModel.present.sink { [weak self] vc in
            self?.present(vc, animated: true)
        }.store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ClientTableViewCell.id, for: indexPath)
        (cell as? ClientTableViewCell)?.user = self.viewModel.users[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.userDidSelect(at: indexPath)
    }
}

