//
//  ActionsViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

class ActionsViewController<T>: BaseViewController, UITableViewDataSource, UITableViewDelegate where T: ActionsViewModelProtocol {
    private lazy var menuTableView = UITableView().setup {
        $0.register(TextTableViewCell.self)
        $0.dataSource = self
        $0.delegate = self
    }
    
    private let viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.menuTableView)
    }
    
    override func setupConstraints() {
        self.menuTableView.snp.makeConstraints({ $0.edges.equalTo(self.view.safeAreaLayoutGuide) })
    }
    
    override func setupBindings() {
        self.viewModel.actionsPublisher.sink { [weak self] _ in
            self?.menuTableView.reloadData()
        }.store(in: &cancellables)
        
        self.viewModel.pushVC.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.id, for: indexPath)
        (cell as? TextTableViewCell)?.text = self.viewModel.actions[indexPath.row].title
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.actionDidTap(at: indexPath)
    }
}
