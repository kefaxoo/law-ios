//
//  MenuActions.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation

enum MenuActions: CaseIterable {
    case clients
}

extension MenuActions: ActionsProtocol {
    var title: String {
        switch self {
            case .clients:
                "Управление клиентами и делами"
        }
    }
    
    var vc: BaseViewController {
        switch self {
            case .clients:
                ClientsCasesFactory.create()
        }
    }
}
