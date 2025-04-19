//
//  ClientsCasesDBViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit
import SwiftData

protocol ClientsCasesDBViewModelProtocol {
    var tableViewContent: [any PersistentModel] { get }
    var tableViewContentPublished: CPublisher<[any PersistentModel]> { get }
    
    var pushVC: CPassthroughSubject<BaseViewController> { get }
    
    // MARK: - Actions
    func rightBarButtonItemDidTap()
    
    func fetchClientsInfo()
    
    // MARK: - Search
    func searchBar(textDidChange text: String)
}
