//
//  AddEventViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 06.01.25.
//

import UIKit
import MessageUI

final class AddEventViewController: BaseViewController {
    private lazy var eventTypeImageView = UIImageView().setup {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
        $0.snp.makeConstraints { make in
            make.width.equalTo(36)
            make.height.equalTo(30)
        }
    }
    
    private lazy var eventTypeImageViewContentView = UIView().setup {
        $0.backgroundColor = UIColor(hex: "#3082ED")
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.addSubview(self.eventTypeImageView)
        self.eventTypeImageView.snp.makeConstraints({ $0.edges.equalToSuperview().inset(10) })
    }
    
    private lazy var eventTypeLabel = UILabel().setup {
        $0.font = .systemFont(ofSize: 19, weight: .medium)
        $0.textColor = .black
        $0.numberOfLines = 1
    }
    
    private lazy var eventTypeButton = UIButton().setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.eventTypeActions)
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 38) })
        $0.addSubview(self.eventTypeImageViewContentView)
        self.eventTypeImageViewContentView.snp.makeConstraints({ $0.verticalEdges.leading.equalToSuperview() })
        $0.backgroundColor = UIColor(hex: "#FBFCFC")
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 10
        $0.addSubview(self.eventTypeLabel)
        self.eventTypeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.eventTypeImageViewContentView.snp.trailing).offset(13)
            make.trailing.equalToSuperview().inset(13)
        }
    }
    
    private lazy var nameLabel = UILabel().setup {
        $0.text = "Название события:"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 17, weight: .medium)
    }
    
    private lazy var nameTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Плановая встреча"
    }
    
    private lazy var descriptionLabel = UILabel().setup { $0.text = "Описание:" }
    private lazy var descriptionTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Введите описание..."
    }
    
    private lazy var dateImageView = UIImageView().setup {
        $0.contentMode = .scaleAspectFit
        $0.image = .calendarIcon
        $0.snp.makeConstraints({ $0.size.equalTo(17) })
        $0.tintColor = .black
    }
    
    private lazy var dateLabel = UILabel().setup {
        $0.text = "Дата и время"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 18)
    }
    
    private lazy var datePickerView = UIDatePicker().setup {
        $0.minimumDate = Date()
        $0.datePickerMode = .dateAndTime
        $0.contentHorizontalAlignment = .leading
        $0.addTarget(self, action: #selector(dateDidChange), for: .valueChanged)
    }
    
    private lazy var dateHStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.spacing = 6
        $0.addArrangedSubview(self.dateImageView)
        $0.addArrangedSubview(self.dateLabel)
    }
    
    private lazy var dateVStackView = UIStackView().setup {
        $0.axis = .vertical
        $0.spacing = 8
        $0.addArrangedSubview(self.dateHStackView)
        $0.addArrangedSubview(self.datePickerView)
    }
    
    private lazy var locationLabel = UILabel().setup {
        $0.text = "Место события:"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 18)
    }
    
    private lazy var locationTextField = UITextField.roundedRect.setup {
        $0.placeholder = "Введите место события..."
    }
    
    private lazy var clientLabel = UILabel().setup {
        $0.text = "Клиент, связанный с событием:"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 18)
    }
    
    private lazy var clientButton = AddEventButton().setup {
        $0.addTarget(self, action: #selector(clientButtonDidTap), for: .touchUpInside)
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#C6C6C6").cgColor
        $0.image = .clientIcon
        $0.text = "Выберите клиента"
        $0.tintColor = UIColor(hex: "#2076F3")
    }
    
    private lazy var caseLabel = UILabel().setup({ $0.text = "Дело, связанное с событием:" })
    
    private lazy var caseButton = AddEventButton().setup {
        $0.addTarget(self, action: #selector(caseButtonDidTap), for: .touchUpInside)
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#C6C6C6").cgColor
        $0.image = .caseIcon
        $0.text = "Выберите дело"
        $0.tintColor = UIColor(hex: "#2076F3")
    }
    
    private lazy var toggleReminderLabel = UILabel().setup {
        $0.text = "Добавить напоминание?"
    }
    
    private lazy var toggleReminderSwitch = UISwitch().setup {
        $0.addTarget(self, action: #selector(toggleReminderSwitchValueChanged), for: .valueChanged)
    }
    
    private lazy var toggleReminderHStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.addArrangedSubview(self.toggleReminderLabel)
        $0.addArrangedSubview(.spacer)
        $0.addArrangedSubview(self.toggleReminderSwitch)
    }
    
    private lazy var setupReminderLabel = UILabel().setup {
        $0.text = "Напомнить за"
    }
    
    private lazy var setupReminderButton = UIButton(configuration: .tinted()).setup {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(options: .displayInline, children: self.viewModel.remindersActions)
    }
    
    private lazy var setupReminderHStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.addArrangedSubview(self.setupReminderLabel)
        $0.addArrangedSubview(.spacer)
        $0.addArrangedSubview(self.setupReminderButton)
        $0.isHidden = true
    }
    
    private lazy var dynamicVScrollView = DynamicScrollView(axis: .vertical).setup {
        $0.addSubview(self.eventTypeButton, spacingAfter: 21)
        $0.addSubview(self.nameLabel, spacingAfter: 8)
        $0.addSubview(self.nameTextField, spacingAfter: 18)
        $0.addSubview(self.descriptionLabel, spacingAfter: 8)
        $0.addSubview(self.descriptionTextField, spacingAfter: 18)
        $0.addSubview(self.dateVStackView, spacingAfter: 27)
        $0.addSubview(self.locationLabel, spacingAfter: 16)
        $0.addSubview(self.locationTextField, spacingAfter: 16)
        $0.addSubview(self.clientLabel, spacingAfter: 8)
        $0.addSubview(self.clientButton, spacingAfter: 16)
        $0.addSubview(self.caseLabel, spacingAfter: 8)
        $0.addSubview(self.caseButton, spacingAfter: 16)
        $0.addSubview(self.toggleReminderHStackView, spacingAfter: 16)
        $0.addSubview(self.setupReminderHStackView, spacingAfter: 16)
    }
    
    private lazy var addEventButton = UIButton().setup {
        $0.setTitle("Добавить событие", for: .normal)
        $0.addTarget(self, action: #selector(addButtonDidTap), for: .touchUpInside)
        $0.setTitleColor(UIColor(hex: "#FFFDFD"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        $0.backgroundColor = UIColor(hex: "#367EFF")
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.contentEdgeInsets = .init(top: 13, left: 0, bottom: 13, right: 0)
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
        self.view.addSubview(self.addEventButton)
    }
    
    override func setupConstraints() {
        self.dynamicVScrollView.snp.makeConstraints({ $0.top.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(19) })
        
        self.addEventButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(19)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.dynamicVScrollView.snp.bottom).offset(16)
        }
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Добавление события"
    }
    
    override func setupBindings() {
        self.viewModel.selectedEventTypePublished.sink { [weak self] eventType in
            self?.eventTypeImageView.image = eventType.image
            self?.eventTypeLabel.text = eventType.title
        }.store(in: &cancellables)
        
        self.viewModel.pushVC.sink { [weak self] vc in
            self?.navigationController?.pushViewController(vc, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.selectedClientPublished.sink { [weak self] client in
            self?.clientButton.text = client?.fullName ?? "Выберите клиента"
        }.store(in: &cancellables)
        
        self.viewModel.selectedCasePublished.sink { [weak self] `case` in
            self?.caseButton.text = `case`?.title ?? "Выберите дело"
        }.store(in: &cancellables)
        
        self.viewModel.present.sink { [weak self] alert in
            self?.present(alert, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.popVC.sink { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.eventToShowPublished.sink { [weak self] eventToShow in
            guard let eventToShow else { return }
            
            self?.eventTypeLabel.text = eventToShow.eventType.title
            self?.nameTextField.text = eventToShow.name
            self?.descriptionTextField.text = eventToShow.eventDescription ?? " "
            self?.datePickerView.date = Date(timeIntervalSince1970: eventToShow.date)
            self?.locationTextField.text = eventToShow.location ?? " "
            let clientId = eventToShow.clientId
            DatabaseService.shared.fetchObjects(type: ClientInfo.self, predicate: #Predicate { $0.id == clientId }) { objects, error in
                self?.clientButton.text = objects?.first?.fullName
            }
            
            let caseId = eventToShow.caseId
            DatabaseService.shared.fetchObjects(type: ClientCase.self, predicate: #Predicate { $0.id == caseId }) { objects, error in
                self?.caseButton.text = objects?.first?.title
            }
            
            self?.eventTypeButton.isEnabled = false
            self?.nameTextField.isEnabled = false
            self?.descriptionTextField.isEnabled = false
            self?.datePickerView.isEnabled = false
            self?.locationTextField.isEnabled = false
            self?.clientButton.isEnabled = false
            self?.caseButton.isEnabled = false
            
            self?.addEventButton.setTitle("Отправить напоминание клиенту?", for: .normal)
            
            self?.setupReminderHStackView.isHidden = true
            self?.toggleReminderHStackView.isHidden = true
        }.store(in: &cancellables)
        
        self.viewModel.isReminderPublished.sink { [weak self] isReminder in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self?.setupReminderHStackView.isHidden = !isReminder
                self?.dynamicVScrollView.layoutIfNeeded()
            }
        }.store(in: &cancellables)
        
        self.viewModel.selectedReminderPeriodPublished.sink { [weak self] period in
            self?.setupReminderButton.setTitle(period?.title, for: .normal)
        }.store(in: &cancellables)
        
        self.viewModel.presentMailVC.sink { [weak self] vc in
            vc.delegate = self
            self?.present(vc, animated: true)
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
    
    @objc func toggleReminderSwitchValueChanged(_ sender: UISwitch) {
        self.viewModel.setIsReminder(sender.isOn)
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

// MARK: - MFMailComposeViewControllerDelegate
extension AddEventViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        
    }
}
