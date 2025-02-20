//
//  ReceivablesClientsViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 20.02.25.
//

import Foundation

final class ReceivablesClientsViewModel: ReceivablesClientsViewModelProtocol {
    @Published var clientsAndDebts = [ReceivablesClientsViewModelProtocol.ClientDebt]()
    var clientsAndDebtsPublished: CPublisher<[ReceivablesClientsViewModelProtocol.ClientDebt]> {
        $clientsAndDebts.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    init() {
        DatabaseService.shared.fetchObjects(type: FinanceOperation.self) { [weak self] objects, error in
            guard let operations = objects?.filter({ $0.status == .pending }) else {
                debugPrint(error as Any)
                return
            }
            
            let clientIds = Set(operations.compactMap(\.clientId))
            DatabaseService.shared.fetchObjects(type: ClientInfo.self, predicate: #Predicate { clientIds.contains($0.id) }) { objects, error in
                guard let objects else { return }
                
                self?.clientsAndDebts = objects.compactMap { client in
                    (client, operations.filter({ $0.clientId == client.id }).reduce(0, { $0 + $1.amount }))
                }
            }
        }
    }
}
