//
//  AddClientCaseViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import UIKit

final class AddClientCaseViewController: BaseViewController {
    private lazy var caseTypeLabel = UILabel().setup({ $0.text = "Тип дела:" })
    private lazy var caseTypeButton = UIButton(configuration: .tinted()).setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.caseTypeActions)
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 32) })
        $0.isEnabled = self.viewModel.clientCase == nil
    }
    
    private lazy var caseStatusLabel = UILabel().setup({ $0.text = "Статус дела:" })
    private lazy var caseStatusButton = UIButton(configuration: .tinted()).setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.caseStatusActions)
    }
    
    private lazy var startDateLabel = UILabel().setup({ $0.text = "Дата начала:" })
    private lazy var startDatePickerView = UIDatePicker().setup {
        $0.date = self.viewModel.clientCase?.startDate.toDate ?? Date()
        $0.datePickerMode = .date
        $0.maximumDate = Date()
        $0.addTarget(self, action: #selector(startDateDidChange), for: .valueChanged)
        $0.isEnabled = self.viewModel.clientCase == nil
    }
    
    private lazy var endDateLabel = UILabel().setup {
        $0.text = "Дата окончания:"
        $0.isHidden = true
    }
    
    private lazy var endDatePickerView = UIDatePicker().setup {
        $0.datePickerMode = .date
        $0.maximumDate = Date()
        $0.addTarget(self, action: #selector(endDateDidChange), for: .valueChanged)
        if let endDate = self.viewModel.clientCase?.endDate?.toDate {
            $0.date = endDate
        }
        
        $0.isHidden = true
    }
    
    private lazy var eventDatesLabel = UILabel().setup({ $0.text = "События по делу:" })
    private lazy var eventDatesTableView = UITableView().setup {
        $0.register(TextFieldDatePickerTableViewCell.self)
        $0.dataSource = self
        $0.separatorStyle = .none
    }
    
    private lazy var addEventDateButton = UIButton(configuration: .tinted()).setup {
        $0.setTitle("Добавить новое событие", for: .normal)
        $0.addTarget(self, action: #selector(addEventDateDidTap), for: .touchUpInside)
    }
    
    private lazy var dynamicVStackView = DynamicScrollView(axis: .vertical).setup {
        $0.addSubview(self.caseTypeLabel, spacingAfter: 16)
        $0.addSubview(self.caseTypeButton, spacingAfter: 16)
        $0.addSubview(self.caseStatusLabel, spacingAfter: 16)
        $0.addSubview(self.caseStatusButton, spacingAfter: 16)
        $0.addSubview(self.startDateLabel, spacingAfter: 16)
        $0.addSubview(self.startDatePickerView, spacingAfter: 16)
        $0.addSubview(self.endDateLabel, spacingAfter: 16)
        $0.addSubview(self.endDatePickerView, spacingAfter: 16)
        $0.addSubview(self.eventDatesLabel, spacingAfter: 16)
        $0.addSubview(self.eventDatesTableView, spacingAfter: 16)
        $0.addSubview(self.addEventDateButton)
    }
    
    private lazy var addCaseButton = UIButton(configuration: .filled()).setup {
        $0.setTitle(self.viewModel.clientCase == nil ? "Добавить событие" : "Изменить событие", for: .normal)
        $0.addTarget(self, action: #selector(addCaseDidTap), for: .touchUpInside)
    }
    
    private let viewModel: AddClientCaseViewModelProtocol

	init(viewModel: AddClientCaseViewModelProtocol) {
		self.viewModel = viewModel
		super.init()
	}
    
    override func setupInterface() {
        super.setupInterface()
        
        self.addKeyboardDismiss()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.dynamicVStackView)
        self.view.addSubview(self.addCaseButton)
    }
    
    override func setupConstraints() {
        self.dynamicVStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.addCaseButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.dynamicVStackView.snp.bottom).offset(16)
        }
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = self.viewModel.clientCase == nil ? "Добавление дела" : "Изменение дела"
    }
    
    override func setupBindings() {
        self.viewModel.selectedCaseTypePublished.sink { [weak self] caseType in
            self?.caseTypeButton.setTitle(caseType.title, for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.selectedCaseStatusPublished.sink { [weak self] status in
            self?.caseStatusButton.setTitle(status.title, for: .normal)
            self?.endDateLabel.isHidden = status == .active
            self?.endDatePickerView.isHidden = status == .active
        }.store(in: &cancellables)
        
        self.viewModel.startDatePublished.sink { [weak self] startDate in
            self?.endDatePickerView.minimumDate = startDate
            self?.refreshDateInCells()
        }.store(in: &cancellables)
        
        self.viewModel.endDatePublished.sink { [weak self] _ in
            self?.refreshDateInCells()
        }.store(in: &cancellables)
        
        self.viewModel.eventDatesPublished.sink { [weak self] _ in
            guard let self else { return }
            
            self.eventDatesTableView.reloadData()
            self.eventDatesTableView.snp.updateConstraints({ $0.height.equalTo(self.eventDatesTableView.contentSize.height) })
        }.store(in: &cancellables)
        
        self.viewModel.presentAlert.sink { [weak self] alert in
            self?.present(alert, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.popVC.sink { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
    }
}

// MARK: - Actions
private extension AddClientCaseViewController {
    @objc func startDateDidChange(_ sender: UIDatePicker) {
        self.viewModel.setStartDate(sender.date)
    }
    
    @objc func endDateDidChange(_ sender: UIDatePicker) {
        self.viewModel.setEndDate(sender.date)
    }
    
    @objc func addEventDateDidTap(_ sender: UIButton) {
        self.viewModel.addNewEventDate()
    }
    
    @objc func addCaseDidTap(_ sender: UIButton) {
        var cells = [TextFieldDatePickerTableViewCell]()
        for i in 0..<self.viewModel.eventDates.count {
            guard let cell = self.eventDatesTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? TextFieldDatePickerTableViewCell else { continue }
            
            cells.append(cell)
        }
        
        self.viewModel.addCase(cells.enumerated().compactMap({ ($0.offset, $0.element.text, $0.element.date) }))
    }
}

// MARK: - UITableViewDataSource
extension AddClientCaseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.eventDates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldDatePickerTableViewCell.id, for: indexPath)
        (cell as? TextFieldDatePickerTableViewCell)?.setup {
            $0.datePickerMode = .date
            $0.placeholder = "Событие..."
            $0.minimumDate = self.viewModel.startDate
            $0.maximumDate = self.viewModel.endDate
            $0.selectionStyle = .none
            if self.viewModel.clientCase != nil,
               let date = self.viewModel.eventDates[indexPath.row].date {
                $0.text = self.viewModel.eventDates[indexPath.row].text
                $0.date = date
            }
        }
        
        return cell
    }
}

// MARK: - Private
private extension AddClientCaseViewController {
    func refreshDateInCells() {
        self.eventDatesTableView.visibleCells.compactMap({ $0 as? TextFieldDatePickerTableViewCell }).forEach {
            $0.maximumDate = self.viewModel.endDate
            $0.minimumDate = self.viewModel.startDate
        }
    }
}
