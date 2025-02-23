//
//  FinanceAnalyticsViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit

final class FinanceAnalyticsViewController: BaseViewController {
    private lazy var toggleTransactionTypeLabel = UILabel().setup {
        $0.text = "Фильтр по типу транзакции:"
    }
    
    private lazy var toggleTransactionTypeSwitch = UISwitch().setup {
        $0.addTarget(self, action: #selector(toggleTransactionTypeSwitchValueChanged), for: .valueChanged)
    }
    
    private lazy var toggleTransactionTypeHStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.addArrangedSubview(self.toggleTransactionTypeLabel)
        $0.addArrangedSubview(.spacer)
        $0.addArrangedSubview(self.toggleTransactionTypeSwitch)
    }
    
    private lazy var transactionTypeLabel = UILabel().setup {
        $0.text = "Тип транзакции:"
    }
    
    private lazy var transactionTypeButton = UIButton(configuration: .tinted()).setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.transactionTypeActions)
    }
    
    private lazy var transactionTypeHStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.addArrangedSubview(self.transactionTypeLabel)
        $0.addArrangedSubview(.spacer)
        $0.addArrangedSubview(self.transactionTypeButton)
        $0.isHidden = true
    }
    
    private lazy var transactionTypeVStackView = UIStackView().setup {
        $0.axis = .vertical
        $0.spacing = 16
        $0.addArrangedSubview(self.toggleTransactionTypeHStackView)
        $0.addArrangedSubview(self.transactionTypeHStackView)
    }
    
    private lazy var tableView = UITableView().setup {
        $0.register(TextTableViewCell.self)
        $0.dataSource = self
        $0.isScrollEnabled = false
    }
    
    private lazy var generationButton = UIButton(configuration: .filled()).setup {
        $0.setTitle("Сгенерировать отчет", for: .normal)
        $0.addTarget(self, action: #selector(generationButtonDidTap), for: .touchUpInside)
    }
    
    private let viewModel: FinanceAnalyticsViewModelProtocol

	init(viewModel: FinanceAnalyticsViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupLayout() {
        self.view.addSubview(self.transactionTypeVStackView)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.generationButton)
    }
    
    override func setupConstraints() {
        self.transactionTypeVStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.transactionTypeVStackView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.generationButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(self.tableView.snp.bottom).offset(16)
        }
    }
    
    override func setupBindings() {
        self.viewModel.financeAnalyticsPublished.sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
        
        self.viewModel.selectedTransactionTypePublished.sink { [weak self] type in
            self?.transactionTypeButton.setTitle(type?.title, for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.isTransactionTypePublished.sink { [weak self] isTransactionType in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self?.transactionTypeHStackView.isHidden = !isTransactionType
                self?.transactionTypeVStackView.layoutIfNeeded()
            }
        }.store(in: &cancellables)
        
        self.viewModel.present.sink { [weak self] vc in
            self?.present(vc, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.push.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Финансовые показатели"
    }
}

// MARK: - UITableViewDataSource
extension FinanceAnalyticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.financeAnalytics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.id, for: indexPath)
        (cell as? TextTableViewCell)?.text = self.viewModel.financeAnalytics[indexPath.row].text
        return cell
    }
}

// MARK: - Actions
private extension FinanceAnalyticsViewController {
    @objc func toggleTransactionTypeSwitchValueChanged(_ sender: UISwitch) {
        self.viewModel.setIsTransactionType(sender.isOn)
    }
    
    @objc func generationButtonDidTap(_ sender: UIButton) {
        self.viewModel.generationButtonDidTap()
    }
}
