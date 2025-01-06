//
//  ClientsCasesActions.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation

enum ClientsCasesActions: CaseIterable {
    case clientsCasesDB
    case casesDB
    case calendar
}

extension ClientsCasesActions: ActionsProtocol {
    var title: String {
        switch self {
            case .clientsCasesDB:
                "База данных клиентов и история взаимодействия"
            case .casesDB:
                "Дела клиентов"
            case .calendar:
                "Календарь"
        }
    }
    
    var vc: BaseViewController {
        switch self {
            case .clientsCasesDB:
                ClientsCasesDBFactory.create()
            case .casesDB:
                CasesDBFactory.create()
            case .calendar:
                CalendarFactory.create()
        }
    }
}
