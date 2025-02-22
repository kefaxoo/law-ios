//
//  MenuActions.swift
//  law
//
//  Created by Bahdan Piatrouski on 16.12.24.
//

import Foundation

enum MenuActions: CaseIterable {
    case clients
    case docsManagment
    case finance
    case analytics
}

extension MenuActions: ActionsProtocol {
    var title: String {
        switch self {
            case .clients:
                "Управление клиентами и делами"
            case .docsManagment:
                "Документооборот"
            case .finance:
                "Финансовые операции"
            case .analytics:
                "Отчетность и аналитика"
        }
    }
    
    var vc: BaseViewController {
        switch self {
            case .clients:
                ClientsCasesFactory.create()
            case .docsManagment:
                DocsManagementFactory.create()
            case .finance:
                FinanceFactory.create()
            case .analytics:
                AnalyticsFactory.create()
        }
    }
}
