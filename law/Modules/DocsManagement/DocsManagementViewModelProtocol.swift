//
//  DocsManagementViewModelProtocol.swift
//  law
//
//  Created by Bahdan Piatrouski on 11.01.25.
//

import Foundation

protocol DocsManagementViewModelProtocol {
    var pushVC: CPassthroughSubject<BaseViewController> { get }
    
    func rightBarButtonDidTap()
}
