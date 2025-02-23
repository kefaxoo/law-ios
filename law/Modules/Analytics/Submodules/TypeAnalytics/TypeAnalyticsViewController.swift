//
//  TypeAnalyticsViewController.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit

fileprivate extension UIStackView {
    var textField: UITextField? {
        self.subviews.compactMap({ $0 as? UITextField }).first
    }
}

class TypeAnalyticsViewController: BaseViewController {
    private lazy var togglePeriodLabel = UILabel().setup {
        $0.text = "Фильтр по периоду:"
    }
    
    private lazy var togglePeriodSwitch = UISwitch().setup {
        $0.addTarget(self, action: #selector(togglePeriodSwitchValueChanged), for: .valueChanged)
    }
    
    private lazy var togglePeriodHStackView = UIStackView().setup {
        $0.axis = .horizontal
        $0.addArrangedSubview(self.togglePeriodLabel)
        $0.addArrangedSubview(.spacer)
        $0.addArrangedSubview(self.togglePeriodSwitch)
        $0.snp.makeConstraints({ $0.width.equalTo(UIScreen.main.bounds.width - 32) })
    }
    
    private lazy var beginHStackView = self.createPeriodStackView(isBegin: true)
    private lazy var endHStackView = self.createPeriodStackView(isBegin: false)
    
    private lazy var generateButton = UIButton(configuration: .filled()).setup {
        $0.setTitle("Сгенерировать отчет", for: .normal)
        $0.addTarget(self, action: #selector(generateButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var dynamicVScrollView = DynamicScrollView(axis: .vertical).setup {
        $0.addSubview(self.togglePeriodHStackView, spacingAfter: 16)
        $0.addSubview(self.beginHStackView, spacingAfter: 8)
        $0.addSubview(self.endHStackView, spacingAfter: 16)
    }
    
    private let viewModel: TypeAnalyticsViewModelProtocol

    init(viewModel: TypeAnalyticsViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func setupLayout() {
        self.view.addSubview(self.dynamicVScrollView)
        self.view.addSubview(self.generateButton)
    }
    
    override func setupConstraints() {
        self.dynamicVScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        self.generateButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(16)
            make.top.equalTo(self.dynamicVScrollView.snp.bottom).offset(16)
        }
    }
    
    override func setupNavigationController() {
        self.navigationItem.title = "Статистика дел"
    }
    
    override func setupBindings() {
        self.viewModel.present.sink { [weak self] vc in
            self?.present(vc, animated: true)
        }.store(in: &cancellables)
        
        self.viewModel.isPeriodPublished.sink { [weak self] isPeriod in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self?.beginHStackView.isHidden = !isPeriod
                self?.endHStackView.isHidden = !isPeriod
                self?.dynamicVScrollView.layoutIfNeeded()
            }
        }.store(in: &cancellables)
        
        self.viewModel.selectedStartPeriodPublished.sink { [weak self] selectedStartPeriod in
            self?.beginHStackView.textField?.text = selectedStartPeriod?.toDateFormat("dd.MM.yyyy")
        }.store(in: &cancellables)
        
        self.viewModel.selectedEndPeriodPublished.sink { [weak self] selectedEndPeriod in
            self?.endHStackView.textField?.text = selectedEndPeriod?.toDateFormat("dd.MM.yyyy")
        }.store(in: &cancellables)
    }
}

// MARK: - UI
private extension TypeAnalyticsViewController {
    func createPeriodStackView(isBegin: Bool) -> UIStackView {
        let label = UILabel().setup {
            $0.text = "\(isBegin ? "Начало" : "Конец") периода:"
        }
        
        let textField = UITextField.roundedRect.setup {
            $0.tag = 1000 + (isBegin ? 1 : 2)
            $0.addTarget(self, action: #selector(periodTextFieldDidTap), for: .editingDidBegin)
        }
        
         return UIStackView().setup {
             $0.axis = .horizontal
             $0.addArrangedSubview(label)
             $0.addArrangedSubview(.spacer)
             $0.addArrangedSubview(textField)
             $0.isHidden = true
        }
    }
}

// MARK: - Actions
private extension TypeAnalyticsViewController {
    @objc func periodTextFieldDidTap(_ sender: UITextField) {
        self.view.endEditing(true)
        self.viewModel.periodTextFieldDidSelect(isBegin: sender.tag == 1001)
    }
    
    @objc func togglePeriodSwitchValueChanged(_ sender: UISwitch) {
        self.viewModel.setIsPeriod(sender.isOn)
    }
    
    @objc func generateButtonDidTap(_ sender: UIButton) {
        self.viewModel.generateButtonDidTap()
    }
}
