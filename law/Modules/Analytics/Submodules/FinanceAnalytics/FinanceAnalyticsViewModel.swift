//
//  FinanceAnalyticsViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import UIKit

final class FinanceAnalyticsViewModel: FinanceAnalyticsViewModelProtocol {
    @Published var financeAnalytics = [FinanceAnalyticsType]()
    var financeAnalyticsPublished: CPublisher<[FinanceAnalyticsType]> {
        $financeAnalytics.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published private var isTransactionType = false
    var isTransactionTypePublished: CPublisher<Bool> {
        $isTransactionType.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    @Published private var selectedTransactionType: FinanceOperation.TransactionType?
    var selectedTransactionTypePublished: CPublisher<FinanceOperation.TransactionType?> {
        $selectedTransactionType.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var transactionTypeActions: [UIAction] {
        FinanceOperation.TransactionType.allCases.compactMap { [weak self] type in
            UIAction(title: type.title) { _ in
                self?.selectedTransactionType = type
                self?.fetch()
            }
        }
    }
    
    var present = CPassthroughSubject<UIViewController>()
    
    @UserDefaultsWrapper(key: .currentUserId, value: nil)
    private var currentUserId: String?
    private var currentUser: User?
    
    init() {
        self.fetch()
        if let currentUserId {
            DatabaseService.shared.fetchObjects(type: User.self, predicate: #Predicate { $0.id == currentUserId }) { [weak self] objects, error in
                self?.currentUser = objects?.first
            }
        }
    }
}

// MARK: - Fetch
private extension FinanceAnalyticsViewModel {
    func fetch() {
        DatabaseService.shared.fetchObjects(type: FinanceOperation.self) { [weak self] objects, error in
            guard let self,
                  var objects
            else { return }
            
            if self.isTransactionType,
               let selectedTransactionType {
                objects = objects.filter({ $0.transactionType == selectedTransactionType })
            }
            
            self.setAnalyticsInfo(by: objects)
        }
    }
    
    func setAnalyticsInfo(by operations: [FinanceOperation]) {
        let clients = Set(operations.compactMap(\.clientId))
        let amounts = operations.compactMap(\.amount)
        let amountSum = amounts.reduce(0, +)
        
        self.financeAnalytics = [
            .commonIncome(income: amountSum),
            .averageClientBill(bill: amountSum / Double(clients.count)),
            .paidBills(percent: Double(operations.filter({ $0.status == .done }).count) / Double(operations.count) * 100),
            .accountsReceivables(sum: operations.filter({ $0.status == .pending }).reduce(0, { $0 + $1.amount }))
        ]
    }
}

// MARK: - Actions
extension FinanceAnalyticsViewModel {
    func setIsTransactionType(_ value: Bool) {
        self.isTransactionType = value
        self.fetch()
    }
    
    func generationButtonDidTap() {
        let alert = UIAlertController(title: "Выгрузка отчета", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Выгрузить в PDF", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            
            var title = "Финансовые показатели"
            if self.isTransactionType,
               let selectedTransactionType {
                title += "\n\(selectedTransactionType.title)"
            }
            
            let text = self.financeAnalytics.compactMap(\.text).joined(separator: "\n")
            
            let data = PDFManager.createPDFData(metadata: .init(creator: self.currentUser?.login ?? "", title: "Финансовые показатели"), title: title) {
                _ = $0.addMultiLineText(fontSize: 14, weight: .medium, text: text, indent: 74, cursor: $1, pdfSize: $2)
            }
            
            self.present.send(PDFViewerViewController(documentData: data))
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { _ in
            alert.dismiss(animated: true)
        }))
        
        self.present.send(alert)
    }
}
