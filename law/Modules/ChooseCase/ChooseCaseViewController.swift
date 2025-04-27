//
//  ChooseCaseViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 07.01.25.
//

import UIKit

final class ChooseCaseViewController: BaseViewController {
    private lazy var casesTableView = UITableView().setup {
        $0.dataSource = self
        $0.register(ShortClientCaseTableViewCell.self)
        $0.delegate = self
        $0.separatorStyle = .none
        $0.contentInset = .init(top: 6, left: 0, bottom: 0, right: 0)
    }
    
    private let viewModel: ChooseCaseViewModelProtocol
    
    weak var delegate: ChooseCaseDelegate?

    init(viewModel: ChooseCaseViewModelProtocol, delegate: ChooseCaseDelegate?) {
		self.viewModel = viewModel
        self.delegate = delegate
        
		super.init()
	}
    
    override func setupNavigationController() {
        self.navigationItem.title = "Выберите дело"
    }
    
    override func setupLayout() {
        self.view.addSubview(self.casesTableView)
    }
    
    override func setupConstraints() {
        self.casesTableView.snp.makeConstraints({ $0.edges.equalTo(self.view.safeAreaLayoutGuide) })
    }
    
    override func setupBindings() {
        self.viewModel.casesPublished.sink { [weak self] _ in
            self?.casesTableView.reloadData()
        }.store(in: &cancellables)
        
        self.viewModel.caseDidSelect.sink { [weak self] `case` in
            self?.delegate?.caseDidChoose(`case`)
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension ChooseCaseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.cases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShortClientCaseTableViewCell.id, for: indexPath)
        (cell as? ShortClientCaseTableViewCell)?.clientCase = self.viewModel.cases[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChooseCaseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.caseDidSelect(at: indexPath)
    }
}

