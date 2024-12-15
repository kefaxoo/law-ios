//
//  ClientsCasesActions.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation

enum ClientsCasesActions: CaseIterable {
    case clientsCasesDB
}

extension ClientsCasesActions: ActionsProtocol {
    var title: String {
        switch self {
            case .clientsCasesDB:
                "База данных клиентов и история взаимодействия"
        }
    }
    
    var vc: BaseViewController {
        switch self {
            case .clientsCasesDB:
                ClientsCasesDBFactory.create()
        }
    }
}
