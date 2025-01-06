//
//  ChooseCaseViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 07.01.25.
//

import Foundation

final class ChooseCaseViewModel: ChooseCaseViewModelProtocol {
    @Published var cases = [ClientCase]()
    var casesPublished: CPublisher<[ClientCase]> {
        $cases.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var caseDidSelect = CPassthroughSubject<ClientCase>()
    
    init(client: ClientInfo) {
        let id = client.id as String
        DatabaseService.shared.fetchObjects(type: ClientCase.self, predicate: #Predicate { $0.clientId == id }) { [weak self] objects, error in
            self?.cases = objects?.filter({ $0.status == .active }) ?? []
        }
    }
}

// MARK: - Actions
extension ChooseCaseViewModel {
    func caseDidSelect(at indexPath: IndexPath) {
        self.caseDidSelect.send(self.cases[indexPath.row])
    }
}
