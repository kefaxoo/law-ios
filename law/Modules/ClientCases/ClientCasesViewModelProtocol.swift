//
//  ClientCasesViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 17.12.24.
//

import Foundation

protocol ClientCasesViewModelProtocol {
    var client: ClientInfo { get }
    var cases: [ClientCase] { get }
    var casesPublised: CPublisher<[ClientCase]> { get }
    
    var pushVC: CPassthroughSubject<BaseViewController> { get }
    
    func rightBarButtonDidTap()
    
    func fetchCases()
    
    func caseDidTap(at indexPath: IndexPath)
}
