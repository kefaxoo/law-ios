//
//  NewActionsViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 19.04.25.
//

import UIKit

class NewActionsViewController<T>: BaseViewController, UITableViewDataSource, UITableViewDelegate where T: ActionsViewModelProtocol {
    private lazy var titleLabel = UILabel().setup {
        $0.textColor = UIColor(hex: "#181925")
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 45, weight: .bold)
    }
    
    private(set) lazy var topHStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.addArrangedSubview(self.titleLabel)
    }
    
    private lazy var actionsTableView = UITableView().setup {
        $0.register(NewTextTableViewCell.self)
        $0.dataSource = self
        $0.delegate = self
        $0.separatorStyle = .none
    }
    
    let viewModel: T
    
    var viewTitle: String? {
        get {
            self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
    init(viewModel: T) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.topHStackView)
        self.view.addSubview(self.actionsTableView)
    }
    
    override func setupConstraints() {
        self.topHStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.trailing.equalToSuperview().inset(17)
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(9)
        }
        
        self.actionsTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(21)
            make.trailing.equalToSuperview().inset(18)
            make.top.equalTo(self.topHStackView.snp.bottom).offset(28)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func setupBindings() {
        self.viewModel.actionsPublisher.sink { [weak self] _ in
            self?.actionsTableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: NewTextTableViewCell.id, for: indexPath)
        (cell as? NewTextTableViewCell)?.text = self.viewModel.actions[indexPath.row].title
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.actionDidTap(at: indexPath)
    }
}
