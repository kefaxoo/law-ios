//
//  ChooseClientViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 07.01.25.
//

import Foundation

final class ChooseClientViewModel: ChooseClientViewModelProtocol {
    @Published var clients = [ClientInfo]()
    var clientsPublished: CPublisher<[ClientInfo]> {
        $clients.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var clientDidSelect = CPassthroughSubject<ClientInfo>()
    
    init() {
        DatabaseService.shared.fetchObjects(type: ClientInfo.self) { [weak self] objects, error in
            self?.clients = objects ?? []
        }
    }
}

// MARK: - Actions
extension ChooseClientViewModel {
    func clientDidSelect(at indexPath: IndexPath) {
        self.clientDidSelect.send(self.clients[indexPath.row])
    }
}
