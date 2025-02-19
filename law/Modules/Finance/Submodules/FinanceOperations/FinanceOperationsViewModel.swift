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
    
    init() {
        self.fetchOperations()
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
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Экспорт", style: .default, handler: { [weak self] _ in
            // TODO: create pdf
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Редактирование", style: .default, handler: { [weak self] _ in
            // TODO: push create/edit vc
        }))
        
        self.present.send(actionSheet)
    }
    
    func rightBarButtonDidTap() {
        self.pushVC.send(AddFinanceOperationFactory.create())
    }
}
