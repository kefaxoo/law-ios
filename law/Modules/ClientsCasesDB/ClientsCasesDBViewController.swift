//
//  ClientsCasesDBViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit

final class ClientsCasesDBViewController: BaseViewController {
    private lazy var segmentedControl = UISegmentedControl(items: ["Clients", "Cases"]).setup {
        $0.selectedSegmentIndex = 0
        $0.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    private lazy var contentTableView = UITableView().setup {
        $0.register(ClientInfoTableViewCell.self)
        $0.dataSource = self
//        $0.delegate = self
    }
    
    private let viewModel: ClientsCasesDBViewModelProtocol

	init(viewModel: ClientsCasesDBViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupLayout() {
        self.view.addSubview(self.segmentedControl)
        self.view.addSubview(self.contentTableView)
    }
    
    override func setupConstraints() {
        self.segmentedControl.snp.makeConstraints({ $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16) })
        
        self.contentTableView.snp.makeConstraints { make in
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    override func setupBindings() {
        self.viewModel.pushVC.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .fetchClientsInfo).receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.viewModel.fetchClientsInfo()
        }.store(in: &cancellables)
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Clients and cases database"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarButtonItemDidTap))
    }
}

// MARK: - Actions
private extension ClientsCasesDBViewController {
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.viewModel.setSelectedSegmentIndex(sender.selectedSegmentIndex)
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: self.viewModel.cellId, for: indexPath)
        if self.viewModel.selectedSegmentIndex == 0 {
            (cell as? ClientInfoTableViewCell)?.clientInfo = self.viewModel.tableViewContent[indexPath.row] as? ClientInfo
        }
        
        return cell
    }
}
