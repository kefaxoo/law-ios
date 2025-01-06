//
//  ClientCasesViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import Foundation
import SwiftData

final class ClientCasesViewModel: ClientCasesViewModelProtocol {
    var client: ClientInfo
    @Published var cases = [ClientCase]()
    var casesPublised: CPublisher<[ClientCase]> {
        $cases.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var pushVC = CPassthroughSubject<BaseViewController>()
    
    init(client: ClientInfo) {
        self.client = client
        
        self.fetchCases()
    }
    
    func fetchCases() {
        let clientId = self.client.id as String
        DatabaseService.shared.fetchObjects(type: ClientCase.self, predicate: #Predicate<ClientCase> { $0.clientId == clientId }) { [weak self] objects, error in
            guard let self else { return }
            
            self.cases = objects ?? []
        }
    }
}

// MARK: - Actions
extension ClientCasesViewModel {
    func rightBarButtonDidTap() {
        self.pushVC.send(AddClientCaseFactory.create(client: self.client))
    }
    
    func caseDidTap(at indexPath: IndexPath) {
        self.pushVC.send(AddClientCaseFactory.create(client: self.client, clientCase: self.cases[indexPath.row]))
    }
}
