//
//  AnalyticsViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 22.02.25.
//

import Foundation

final class AnalyticsViewModel: ActionsViewModelProtocol {
    @Published var actions: [any ActionsProtocol] = AnalyticType.allCases
    var actionsPublisher: CPublisher<[any ActionsProtocol]> {
        $actions.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var pushVC = CPassthroughSubject<BaseViewController>()
}

// MARK: - Actions
extension AnalyticsViewModel {
    func actionDidTap(at indexPath: IndexPath) {
        self.pushVC.send(self.actions[indexPath.row].vc)
    }
}
