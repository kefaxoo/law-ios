//
//  ClientsCasesViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation

final class ClientsCasesViewModel: ActionsViewModelProtocol {
    @Published var actions: [any ActionsProtocol] = ClientsCasesActions.allCases
    var actionsPublisher: CPublisher<[any ActionsProtocol]> {
        $actions.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var pushVC = CPassthroughSubject<BaseViewController>()
}

// MARK: - Actions
extension ClientsCasesViewModel {
    func actionDidTap(at indexPath: IndexPath) {
        self.pushVC.send(self.actions[indexPath.row].vc)
    }
}
