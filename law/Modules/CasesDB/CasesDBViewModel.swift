//
//  CasesDBViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import Foundation

final class CasesDBViewModel: CasesDBViewModelProtocol {
    @Published var clients = [ClientInfo]()
    var clientsPublished: CPublisher<[ClientInfo]> {
        $clients.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var pushVC = CPassthroughSubject<BaseViewController>()
    
    init() {
        DatabaseService.shared.fetchObjects(type: ClientInfo.self) { [weak self] objects, error in
            self?.clients = objects ?? []
        }
    }
}

// MARK: - Actions
extension CasesDBViewModel {
    func clientDidTap(at indexPath: IndexPath) {
        self.pushVC.send(ClientCasesFactory.create(client: self.clients[indexPath.row]))
    }
}
