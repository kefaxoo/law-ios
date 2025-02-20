//
//  ReceivablesClientsViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 20.02.25.
//

import Foundation

protocol ReceivablesClientsViewModelProtocol {
    typealias ClientDebt = (client: ClientInfo, debt: Double)
    
    var clientsAndDebts: [ReceivablesClientsViewModelProtocol.ClientDebt] { get }
    var clientsAndDebtsPublished: CPublisher<[ReceivablesClientsViewModelProtocol.ClientDebt]> { get }
}
