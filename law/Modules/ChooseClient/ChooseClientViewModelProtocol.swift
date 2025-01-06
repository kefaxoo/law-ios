//
//  ChooseClientViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 07.01.25.
//

import Foundation

protocol ChooseClientViewModelProtocol {
    var clients: [ClientInfo] { get }
    var clientsPublished: CPublisher<[ClientInfo]> { get }
    var clientDidSelect: CPassthroughSubject<ClientInfo> { get }
    
    func clientDidSelect(at indexPath: IndexPath)
}
