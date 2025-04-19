//
//  ClientsCasesDBViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit
import SwiftData

final class ClientsCasesDBViewModel: ClientsCasesDBViewModelProtocol {
    private var clients = [ClientInfo]()
    
    @Published var tableViewContent: [any PersistentModel] = []
    var tableViewContentPublished: CPublisher<[any PersistentModel]> {
        $tableViewContent.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var pushVC = CPassthroughSubject<BaseViewController>()
    
    init() {
        self.fetchClientsInfo()
    }
}

// MARK: - Actions
extension ClientsCasesDBViewModel {
    func rightBarButtonItemDidTap() {
        self.pushVC.send(AddClientFactory.create())
    }
}

extension ClientsCasesDBViewModel {
    func fetchClientsInfo() {
        DatabaseService.shared.fetchObjects(type: ClientInfo.self) { [weak self] objects, error in
            let objects = objects ?? []
            self?.clients = objects
            self?.tableViewContent = objects
        }
    }
}

// MARK: - Search
extension ClientsCasesDBViewModel {
    func searchBar(textDidChange text: String) {
        guard !text.isEmpty else {
            self.tableViewContent = self.clients
            return
        }
        
        let text = text.lowercased()
        self.tableViewContent = self.clients.filter({ $0.fullName.lowercased().contains(text) })
    }
}
