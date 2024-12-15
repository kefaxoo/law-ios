//
//  ClientsCasesDBViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import UIKit
import SwiftData

protocol ClientsCasesDBViewModelProtocol {
    var selectedSegmentIndex: Int { get }
    var selectedSegmentIndexPublished: CPublisher<Int> { get }
    var cellId: String { get }
    
    var tableViewContent: [any PersistentModel] { get }
    var tableViewContentPublished: CPublisher<[any PersistentModel]> { get }
    
    var pushVC: CPassthroughSubject<BaseViewController> { get }
    
    // MARK: - Actions
    func setSelectedSegmentIndex(_ index: Int)
    func rightBarButtonItemDidTap()
    
    func fetchClientsInfo()
}
