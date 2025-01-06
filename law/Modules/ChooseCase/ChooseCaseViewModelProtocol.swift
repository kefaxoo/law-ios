//
//  ChooseCaseViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 07.01.25.
//

import Foundation

protocol ChooseCaseViewModelProtocol {
    var cases: [ClientCase] { get }
    var casesPublished: CPublisher<[ClientCase]> { get }
    
    var caseDidSelect: CPassthroughSubject<ClientCase> { get }
    
    func caseDidSelect(at indexPath: IndexPath)
}
