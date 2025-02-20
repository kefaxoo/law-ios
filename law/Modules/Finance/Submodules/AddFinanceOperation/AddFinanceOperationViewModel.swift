//
//  AddFinanceOperationViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class AddFinanceOperationViewModel: AddFinanceOperationViewModelProtocol {
    var statusMenu: UIMenu {
        UIMenu(
            options: .displayInline,
            children: FinanceOperation.Status.allCases.compactMap({ [weak self] status in
                UIAction(title: status.title) { _ in
                    self?.currentStatus = status
                }
            })
        )
    }
    
    @Published private var currentStatus: FinanceOperation.Status
    var currentStatusPublished: CPublisher<FinanceOperation.Status> {
        $currentStatus.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var paymentMethodMenu: UIMenu {
        UIMenu(
            options: .displayInline,
            children: FinanceOperation.PaymentMethod.allCases.compactMap({ [weak self] method in
                UIAction(title: method.title) { _ in
                    self?.currentPaymentMethod = method
                }
            })
        )
    }
    
    @Published private var currentPaymentMethod: FinanceOperation.PaymentMethod
    var currentPaymentMethodPublished: CPublisher<FinanceOperation.PaymentMethod> {
        $currentPaymentMethod.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var transactionTypeMenu: UIMenu {
        UIMenu(
            options: .displayInline,
            children: FinanceOperation.TransactionType.allCases.compactMap({ [weak self] type in
                UIAction(title: type.title) { _ in
                    self?.currentTransactionType = type
                }
            })
        )
    }
    
    @Published private var currentTransactionType: FinanceOperation.TransactionType
    var currentTransactionTypePublished: CPublisher<FinanceOperation.TransactionType> {
        $currentTransactionType.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published private var selectedClient: ClientInfo?
    var selectedClientPublished: CPublisher<ClientInfo?> {
        $selectedClient.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published private var selectedCase: ClientCase?
    var selectedCasePublished: CPublisher<ClientCase?> {
        $selectedCase.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var showChooseClientScreen = CPassthroughSubject<Void>()
    var showChooseCaseScreen = CPassthroughSubject<ClientInfo>()
    
    var present = CPassthroughSubject<UIViewController>()
    var pop = CPassthroughSubject<Void>()
    
    private var operation: FinanceOperation?
    
    @Published private var amount: Double?
    var amountPublished: CPublisher<Double?> {
        $amount.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    init(operation: FinanceOperation? = nil) {
        self.operation = operation
        
        if let operation {
            self.currentTransactionType = operation.transactionType
            self.currentStatus = operation.status
            self.currentPaymentMethod = operation.paymentMethod
           
            let clientId = operation.clientId
            let caseId = operation.caseId
            DatabaseService.shared.fetchObjects(type: ClientInfo.self, predicate: #Predicate { $0.id == clientId }) { [weak self] objects, error in
                self?.selectedClient = objects?.first
            }
            
            DatabaseService.shared.fetchObjects(type: ClientCase.self, predicate: #Predicate { $0.id == caseId }) { [weak self] objects, error in
                self?.selectedCase = objects?.first
            }
            
            self.amount = operation.amount
        } else {
            self.currentTransactionType = .servicePayment
            self.currentStatus = .pending
            self.currentPaymentMethod = .cash
        }
    }
}

// MARK: - Actions
extension AddFinanceOperationViewModel {
    func clientButtonDidTap() {
        self.showChooseClientScreen.send(())
    }
    
    func caseButtonDidTap() {
        guard let selectedClient else {
            self.present.send(UIAlertController(errorText: "Выберите клиента"))
            return
        }
        
        self.showChooseCaseScreen.send(selectedClient)
    }
    
    func addOperation(amount: String?) {
        guard let selectedClient else {
            self.present.send(UIAlertController(errorText: "Выберите клиента"))
            return
        }
        
        guard let selectedCase else {
            self.present.send(UIAlertController(errorText: "Выберите дело"))
            return
        }
        
        guard let amount = Double(amount ?? ""),
              amount >= 0
        else {
            self.present.send(UIAlertController(errorText: "Введите сумму"))
            return
        }
        
        let operation = self.operation ?? FinanceOperation(clientId: selectedClient.id, caseId: selectedCase.id, amount: amount, transactionType: self.currentTransactionType, status: self.currentStatus, paymentMethod: self.currentPaymentMethod)
        if self.operation == nil {
            DatabaseService.shared.saveObject(operation)
        } else {
            self.operation?.clientId = selectedClient.id
            self.operation?.caseId = selectedCase.id
            self.operation?.amount = amount
            self.operation?.transactionType = self.currentTransactionType
            self.operation?.status = self.currentStatus
            self.operation?.paymentMethod = self.currentPaymentMethod
            
            DatabaseService.shared.saveChanges()
        }
        
        NotificationCenter.default.post(name: .fetchOperations, object: nil)
        self.pop.send(())
    }
}

// MARK: - Setters
extension AddFinanceOperationViewModel {
    func setSelectedClient(_ client: ClientInfo) {
        self.selectedClient = client
        self.selectedCase = nil
    }
    
    func setSelectedCase(_ case: ClientCase) {
        self.selectedCase = `case`
    }
}
