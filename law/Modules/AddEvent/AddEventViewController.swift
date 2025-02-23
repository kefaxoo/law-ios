//
//  AddEventViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 06.01.25.
//

import UIKit

final class AddEventViewController: BaseViewController {
    private lazy var eventTypeLabel = UILabel().setup { $0.text = "Тип события:" }
    private lazy var eventTypeButton = UIButton(configuration: .tinted()).setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.eventTypeActions)
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 32) })
    }
    
    private lazy var nameLabel = UILabel().setup { $0.text = "Название события:" }
    private lazy var nameTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Введите название события..."
    }
    
    private lazy var descriptionLabel = UILabel().setup { $0.text = "Описание события:" }
    private lazy var descriptionTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Введите описание события..."
    }
    
    private lazy var dateLabel = UILabel().setup({ $0.text = "Дата и время события:" })
    private lazy var datePickerView = UIDatePicker().setup {
        $0.minimumDate = Date()
        $0.datePickerMode = .dateAndTime
        $0.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    }
    
    private lazy var locationLabel = UILabel().setup({ $0.text = "Место события:" })
    private lazy var locationTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Введите место события..."
    }
    
    private lazy var clientLabel = UILabel().setup({ $0.text = "Клиент, связанный с событием:" })
    private lazy var clientButton = UIButton(configuration: .tinted()).setup {
        $0.setTitle("Выберите клиента, связанного с событием", for: .normal)
        $0.addTarget(self, action: #selector(clientButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var caseLabel = UILabel().setup({ $0.text = "Дело, связанное с событием:" })
    private lazy var caseButton = UIButton(configuration: .tinted()).setup {
        $0.setTitle("Выберите дело, связанное с событием", for: .normal)
        $0.addTarget(self, action: #selector(caseButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var addButton = UIButton(configuration: .filled()).setup {
        $0.setTitle("Добавить событие", for: .normal)
        $0.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var dynamicVScrollView = DynamicScrollView(axis: .vertical).setup {
        $0.addSubview(self.eventTypeLabel, spacingAfter: 16)
        $0.addSubview(self.eventTypeButton, spacingAfter: 16)
        $0.addSubview(self.nameLabel, spacingAfter: 16)
        $0.addSubview(self.nameTextField, spacingAfter: 16)
        $0.addSubview(self.descriptionLabel, spacingAfter: 16)
        $0.addSubview(self.descriptionTextField, spacingAfter: 16)
        $0.addSubview(self.dateLabel, spacingAfter: 16)
        $0.addSubview(self.datePickerView, spacingAfter: 16)
        $0.addSubview(self.locationLabel, spacingAfter: 16)
        $0.addSubview(self.locationTextField, spacingAfter: 16)
        $0.addSubview(self.clientLabel, spacingAfter: 16)
        $0.addSubview(self.clientButton, spacingAfter: 16)
        $0.addSubview(self.caseLabel, spacingAfter: 16)
        $0.addSubview(self.caseButton, spacingAfter: 16)
    }
    
    private let viewModel: AddEventViewModelProtocol
    
    init(viewModel: AddEventViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupInterface() {
        super.setupInterface()
        
        self.addKeyboardDismiss()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.dynamicVScrollView)
        self.view.addSubview(self.addButton)
    }
    
    override func setupConstraints() {
        self.dynamicVScrollView.snp.makeConstraints({ $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(16) })
        
        self.addButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.dynamicVScrollView.snp.bottom).offset(16)
        }
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Добавление события"
    }
    
    override func setupBindings() {
        self.viewModel.selectedEventTypePublished.sink { [weak self] eventType in
            self?.eventTypeButton.setTitle(eventType.title, for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.pushVC.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.selectedClientPublished.sink { [weak self] client in
            self?.clientButton.setTitle(client?.fullName ?? "Выберите клиента, связанного с событием", for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.selectedCasePublished.sink { [weak self] `case` in
            self?.caseButton.setTitle(`case`?.title ?? "Выберите дело, связанное с событием", for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.presentAlert.sink { [weak self] alert in
            self?.present(alert, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.popVC.sink { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.eventToShowPublished.sink { [weak self] eventToShow in
            guard let eventToShow else { return }
            
            self?.eventTypeButton.setTitle(eventToShow.eventType.title, for: .normal)
            self?.nameTextField.text = eventToShow.name
            self?.descriptionTextField.text = eventToShow.eventDescription ?? " "
            self?.datePickerView.date = Date(timeIntervalSince1970: eventToShow.date)
            self?.locationTextField.text = eventToShow.location ?? " "
            let clientId = eventToShow.clientId
            DatabaseService.shared.fetchObjects(type: ClientInfo.self, predicate: #Predicate { $0.id == clientId }) { objects, error in
                self?.clientButton.setTitle(objects?.first?.fullName, for: .normal)
            }
            
            let caseId = eventToShow.caseId
            DatabaseService.shared.fetchObjects(type: ClientCase.self, predicate: #Predicate { $0.id == caseId }) { objects, error in
                self?.caseButton.setTitle(objects?.first?.title, for: .normal)
            }
            
            self?.eventTypeButton.isEnabled = false
            self?.nameTextField.isEnabled = false
            self?.descriptionTextField.isEnabled = false
            self?.datePickerView.isEnabled = false
            self?.locationTextField.isEnabled = false
            self?.clientButton.isEnabled = false
            self?.caseButton.isEnabled = false
            
            self?.addButton.alpha = 0
            self?.addButton.isEnabled = false
        }.store(in: &cancellables)
    }
}

// MARK: - Actions
private extension AddEventViewController {
    @objc func dateDidChange(_ sender: UIDatePicker) {
        self.viewModel.setDate(sender.date)
    }
    
    @objc func clientButtonDidTap(_ sender: UIButton) {
        self.viewModel.clientButtonDidTap(delegate: self)
    }
    
    @objc func caseButtonDidTap(_ sender: UIButton) {
        self.viewModel.caseButtonDidTap(delegate: self)
    }
    
    @objc func addButtonDidTap(_ sender: UIButton) {
        self.viewModel.addButtonDidTap(title: self.nameTextField.text, description: self.descriptionTextField.text, location: self.locationTextField.text)
    }
}

// MARK: - ChooseClientDelegate
extension AddEventViewController: ChooseClientDelegate {
    func clientDidChoose(_ client: ClientInfo) {
        self.viewModel.setSelectedClient(client)
    }
}

// MARK: - ChooseCaseDelegate
extension AddEventViewController: ChooseCaseDelegate {
    func caseDidChoose(_ case: ClientCase) {
        self.viewModel.setSelectedCase(`case`)
    }
}
