//
//  ClientsCasesDBViewModel.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit
import SwiftData

final class ClientsCasesDBViewModel: ClientsCasesDBViewModelProtocol {
    @Published var selectedSegmentIndex = 0
    var selectedSegmentIndexPublished: CPublisher<Int> {
        $selectedSegmentIndex.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var cellId: String {
        switch self.selectedSegmentIndex {
            case 0:
                ClientInfoTableViewCell.id
            default:
                ""
        }
    }
    
    private var clients = [ClientInfo]()
    private var cases = [ClientInteractionHistory]()
    
    @Published var tableViewContent: [any PersistentModel] = []
    var tableViewContentPublished: CPublisher<[any PersistentModel]> {
        $tableViewContent.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var pushVC = CPassthroughSubject<BaseViewController>()
    
    init() {
        self.fetchClientsInfo()
        
        DatabaseService.shared.fetchObjects(type: ClientInteractionHistory.self) { [weak self] objects, error in
            let objects = objects ?? []
            self?.cases = objects
            if self?.selectedSegmentIndex == 1 {
                self?.tableViewContent = objects
            }
        }
    }
}

// MARK: - Actions
extension ClientsCasesDBViewModel {
    func setSelectedSegmentIndex(_ index: Int) {
        self.selectedSegmentIndex = index
        switch index {
            case 0:
                self.tableViewContent = self.clients
            case 1:
                self.tableViewContent = self.cases
            default:
                break
        }
    }
    
    func rightBarButtonItemDidTap() {
        self.pushVC.send(AddClientFactory.create())
    }
}

extension ClientsCasesDBViewModel {
    func fetchClientsInfo() {
        DatabaseService.shared.fetchObjects(type: ClientInfo.self) { [weak self] objects, error in
            let objects = objects ?? []
            self?.clients = objects
            if self?.selectedSegmentIndex == 0 {
                self?.tableViewContent = objects
            }
        }
    }
}
