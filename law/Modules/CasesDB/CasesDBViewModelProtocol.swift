//
//  CasesDBViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import Foundation

protocol CasesDBViewModelProtocol {
    var clients: [ClientInfo] { get }
    var clientsPublished: CPublisher<[ClientInfo]> { get }
    var pushVC: CPassthroughSubject<BaseViewController> { get }
    
    func clientDidTap(at indexPath: IndexPath)
}
