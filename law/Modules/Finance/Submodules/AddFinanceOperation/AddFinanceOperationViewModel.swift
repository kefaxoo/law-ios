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
    
    init() {
        self.currentStatus = .pending
        self.currentPaymentMethod = .cash
    }
}
