//
//  FinanceOperationsViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

final class FinanceOperationsViewModel: FinanceOperationsViewModelProtocol {
    @Published var operations = [FinanceOperation]()
    var operationsPublished: CPublisher<[FinanceOperation]> {
        $operations.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var present = CPassthroughSubject<UIViewController>()
    var pushVC = CPassthroughSubject<BaseViewController>()
    
    @UserDefaultsWrapper(key: .currentUserId, value: nil)
    private var currentUserId: String?
    private var currentUser: User?
    
    init() {
        self.fetchOperations()
        if let currentUserId {
            DatabaseService.shared.fetchObjects(
                type: User.self,
                predicate: #Predicate { $0.id == currentUserId }
            ) { [weak self] objects, error in
                self?.currentUser = objects?.first
            }
        }
    }
    
    func fetchOperations() {
        DatabaseService.shared.fetchObjects(type: FinanceOperation.self) { [weak self] objects, error in
            self?.operations = objects ?? []
        }
    }
}

// MARK: - Actions
extension FinanceOperationsViewModel {
    func tableViewDidTap(at indexPath: IndexPath) {
        let operation = self.operations[indexPath.row]
        let clientId = operation.clientId
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Экспорт", style: .default, handler: { [weak self] _ in
            DatabaseService.shared.fetchObjects(type: ClientInfo.self, predicate: #Predicate { $0.id == clientId }) { objects, error in
                guard let client = objects?.first else { return }
                
                let data = PDFManager.createPDFData(metadata: .init(creator: self?.currentUser?.login ?? "", title: operation.id), title: "Чек об операции") { context, cursorY, pdfSize in
                    _ = context.addMultiLineText(
                        fontSize: 14,
                        weight: .medium,
                        text: """
                            Идентификатор операции: \(operation.id)
                            Клиент: \(client.fullName)
                            Идентификатор дела: \(operation.caseId)

                            Сумма: \(operation.amount)
                            Тип операции: \(operation.transactionType.title)
                        """,
                        indent: 74,
                        cursor: cursorY,
                        pdfSize: pdfSize
                    )
                }
                
                self?.present.send(PDFViewerViewController(documentData: data))
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Редактирование", style: .default, handler: { [weak self] _ in
            self?.pushVC.send(AddFinanceOperationFactory.create(operation: operation))
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: { _ in
            actionSheet.dismiss(animated: true)
        }))
        
        self.present.send(actionSheet)
    }
    
    func rightBarButtonDidTap() {
        self.pushVC.send(AddFinanceOperationFactory.create())
    }
}
