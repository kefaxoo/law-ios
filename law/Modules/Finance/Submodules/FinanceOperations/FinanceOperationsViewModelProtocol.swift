//
//  FinanceOperationsViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.02.25.
//

import UIKit

protocol FinanceOperationsViewModelProtocol {
    var operations: [FinanceOperation] { get }
    var operationsPublished: CPublisher<[FinanceOperation]> { get }
    
    var present: CPassthroughSubject<UIViewController> { get }
    var pushVC: CPassthroughSubject<BaseViewController> { get }
    
    func tableViewDidTap(at indexPath: IndexPath)
    func rightBarButtonDidTap()
    
    func fetchOperations()
}
