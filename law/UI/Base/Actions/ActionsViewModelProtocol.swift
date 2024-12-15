//
//  ActionsViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation

protocol ActionsViewModelProtocol {
    var actions: [ActionsProtocol] { get }
    var actionsPublisher: CPublisher<[ActionsProtocol]> { get }
    
    var pushVC: CPassthroughSubject<BaseViewController> { get }
    
    func actionDidTap(at indexPath: IndexPath)
}
