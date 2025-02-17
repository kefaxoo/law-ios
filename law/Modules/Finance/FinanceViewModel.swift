//
//  FinanceViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import Foundation

final class FinanceViewModel: ActionsViewModelProtocol {
    @Published var actions: [any ActionsProtocol] = FinanceActions.allCases
    var actionsPublisher: CPublisher<[any ActionsProtocol]> {
        $actions.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var pushVC = CPassthroughSubject<BaseViewController>()
}

// MARK: - Actions
extension FinanceViewModel {
    func actionDidTap(at indexPath: IndexPath) {
        self.pushVC.send(self.actions[indexPath.row].vc)
    }
}
